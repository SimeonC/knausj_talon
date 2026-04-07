"""Unix socket server: receives chord events from wispr-flow-bridge sibling process.

Listens on ~/.talon/wispr_flow_bridge.sock (or $WISPR_FLOW_BRIDGE_SOCKET).
Calls wispr_flow_shadow_f18_down/up on the Talon main thread via cron.

Restart Talon after editing this file or the binary — the server thread is not
hot-reloaded cleanly.
"""

import os
import socket
import threading
import time
from talon import actions, cron

_SOCK_PATH = os.environ.get(
    "WISPR_FLOW_BRIDGE_SOCKET",
    os.path.expanduser("~/.talon/wispr_flow_bridge.sock"),
)

_server_thread: threading.Thread | None = None


def _handle_conn(conn: socket.socket) -> None:
    print("wispr_flow_bridge_server: client connected")
    try:
        buf = b""
        while True:
            chunk = conn.recv(256)
            if not chunk:
                break
            buf += chunk
            while b"\n" in buf:
                line_bytes, buf = buf.split(b"\n", 1)
                line = line_bytes.decode("utf-8", errors="replace").strip()
                print("wispr_flow_bridge_server: recv %r at %.3f" % (line, time.perf_counter()))
                if line == "down":
                    cron.after("0ms", lambda: actions.user.wispr_flow_shadow_f18_down())
                elif line == "up":
                    cron.after("0ms", lambda: actions.user.wispr_flow_shadow_f18_up())
                elif line == "escape":
                    cron.after("0ms", lambda: actions.user.wispr_flow_unlatch())
                elif line:
                    print("wispr_flow_bridge_server: unknown: %r" % line)
    except Exception as e:
        print("wispr_flow_bridge_server: connection error: %s" % e)
    finally:
        conn.close()
        print("wispr_flow_bridge_server: client disconnected")


def _serve_loop(srv: socket.socket) -> None:
    while True:
        try:
            conn, _ = srv.accept()
            t = threading.Thread(target=_handle_conn, args=(conn,), daemon=True)
            t.start()
        except Exception as e:
            print("wispr_flow_bridge_server: accept error: %s" % e)
            break


def _start_server() -> None:
    global _server_thread
    if _server_thread is not None:
        print(
            "wispr_flow_bridge_server: already listening — skipping "
            "(restart Talon to re-bind after edits)"
        )
        return
    try:
        if os.path.exists(_SOCK_PATH):
            os.unlink(_SOCK_PATH)
        srv = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        srv.bind(_SOCK_PATH)
        os.chmod(_SOCK_PATH, 0o600)
        srv.listen(5)
        print("wispr_flow_bridge_server: listening on %s" % _SOCK_PATH)
    except Exception as e:
        print("wispr_flow_bridge_server: failed to bind: %s" % e)
        return
    _server_thread = threading.Thread(target=_serve_loop, args=(srv,), daemon=True, name="wispr_bridge_server")
    _server_thread.start()


_start_server()
