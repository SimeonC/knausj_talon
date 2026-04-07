import CoreGraphics
import Foundation

enum Phase {
    case idle
    case active
    case drainingF12
}

class Bridge {
    var phase: Phase = .idle
    var socketFd: Int32 = -1
    let socketPath: String
    var tap: CFMachPort?

    init(socketPath: String) {
        self.socketPath = socketPath
    }

    func connectSocket() -> Int32 {
        let fd = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard fd >= 0 else { return -1 }
        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        withUnsafeMutablePointer(to: &addr.sun_path) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: 104) { charPtr in
                _ = socketPath.withCString { strncpy(charPtr, $0, 103) }
            }
        }
        let addrLen = socklen_t(MemoryLayout<sockaddr_un>.size)
        let result = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.connect(fd, $0, addrLen)
            }
        }
        if result < 0 { Darwin.close(fd); return -1 }
        return fd
    }

    func ensureConnected() {
        if socketFd >= 0 { return }
        while true {
            let fd = connectSocket()
            if fd >= 0 {
                socketFd = fd
                fputs("wispr-flow-bridge: connected\n", stderr)
                return
            }
            fputs("wispr-flow-bridge: reconnecting...\n", stderr)
            Thread.sleep(forTimeInterval: 0.5)
        }
    }

    func send(_ message: String) {
        ensureConnected()
        let bytes = Array(message.utf8)
        let result = Darwin.write(socketFd, bytes, bytes.count)
        if result <= 0 || errno == EPIPE {
            Darwin.close(socketFd)
            socketFd = -1
            fputs("wispr-flow-bridge: reconnecting...\n", stderr)
            Thread.sleep(forTimeInterval: 0.5)
            ensureConnected()
            _ = Darwin.write(socketFd, bytes, bytes.count)
        }
    }

    func handle(type: CGEventType, event: CGEvent?) -> Unmanaged<CGEvent>? {
        // Tap-disabled pseudo-events arrive with a nil event; re-enable and return nil.
        let disabledByTimeout = CGEventType(rawValue: 0xFFFFFFFE)!
        let disabledByUserInput = CGEventType(rawValue: 0xFFFFFFFD)!

        if type == disabledByTimeout || type == disabledByUserInput {
            if let tap = tap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return nil
        }

        guard let event = event else { return nil }

        let keycode = event.getIntegerValueField(.keyboardEventKeycode)
        let isF12 = keycode == 111
        let isEscape = keycode == 53

        // Escape key: send escape message (for unlatching)
        if isEscape && type == .keyDown {
            fputs("wispr-flow-bridge: escape\n", stderr)
            send("escape\n")
            return Unmanaged.passRetained(event)
        }

        switch type {
        case .keyDown:
            guard isF12 else { return Unmanaged.passRetained(event) }
            let flags = event.flags
            let hasCommand = flags.contains(.maskCommand)
            let isRepeat = event.getIntegerValueField(.keyboardEventAutorepeat) != 0

            switch phase {
            case .idle:
                if hasCommand {
                    phase = .active
                    fputs("wispr-flow-bridge: chord down\n", stderr)
                    send("down\n")
                }
            case .active, .drainingF12:
                if isRepeat { return Unmanaged.passRetained(event) }
            }

        case .keyUp:
            guard isF12 else { return Unmanaged.passRetained(event) }
            switch phase {
            case .active:
                phase = .idle
                fputs("wispr-flow-bridge: chord up\n", stderr)
                send("up\n")
            case .drainingF12:
                phase = .idle
            case .idle:
                break
            }

        case .flagsChanged:
            if phase == .active {
                let flags = event.flags
                if !flags.contains(.maskCommand) {
                    phase = .drainingF12
                    fputs("wispr-flow-bridge: chord up\n", stderr)
                    send("up\n")
                }
            }

        default:
            break
        }

        return Unmanaged.passRetained(event)
    }
}

// Main entry point
let socketPath = ProcessInfo.processInfo.environment["WISPR_FLOW_BRIDGE_SOCKET"]
    ?? (NSHomeDirectory() + "/.talon/wispr_flow_bridge.sock")

fputs("wispr-flow-bridge: listening (pid=\(getpid()))\n", stderr)

let bridge = Bridge(socketPath: socketPath)

let eventMask: CGEventMask =
    (1 << CGEventType.keyDown.rawValue) |
    (1 << CGEventType.keyUp.rawValue) |
    (1 << CGEventType.flagsChanged.rawValue)

guard let tap = CGEvent.tapCreate(
    tap: .cghidEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: eventMask,
    callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
        let bridge = Unmanaged<Bridge>.fromOpaque(refcon!).takeUnretainedValue()
        return bridge.handle(type: type, event: event)
    },
    userInfo: Unmanaged.passRetained(bridge).toOpaque()
) else {
    fputs("wispr-flow-bridge: failed to create CGEventTap (check Accessibility permissions)\n", stderr)
    exit(1)
}

bridge.tap = tap

let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
CGEvent.tapEnable(tap: tap, enable: true)
CFRunLoopRun()
