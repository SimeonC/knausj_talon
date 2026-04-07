"""Wispr Flow + Talon: mute/latch gestures from wispr_bridge (Swift CGEventTap sibling).

Bridge (running at HID level, before Wispr app intercepts):
- Detects physical ⌘F12 and Escape key presses
- Sends "down"/"up" for F12 chords, "escape" for Escape key
- Forwards all events (never swallows; Wispr swallows at app level)
- Routes through Unix socket to Talon

Gestures:
- Hold chord (⌘F12 ≥320ms): speech & mic muted during hold, restored on release.
- Single tap (⌘F12 <320ms): speech & mic muted during tap, restored on release (no action).
- Double-tap (<320ms twice within 450ms): latch — speech & mic off until Escape or second ⌘F12.
  - Unlatch via: Escape key (detected by bridge) OR second ⌘F12 press (within next N seconds).
"""

import atexit
import os
import subprocess
import sys
import time
import traceback
from typing import Optional

from talon import Module, actions

mod = Module()

mod.mode(
    "wispr_flow_latched",
    "Wispr latched: speech off until gesture end or user.wispr_flow_unlatch()",
)

# --- tuning ---
_HOLD_THRESHOLD_MS = 320.0
_DOUBLE_TAP_MS = 450.0
_GLITCH_UP_IGNORE_MS = 40.0

_DEBUG = False
_DEBUG_NOTIFY = False
_TRACE_GESTURE = True

_latched = False
_down_ts: Optional[float] = None
_last_short_release_ts: Optional[float] = None
_speech_before_sequence: Optional[bool] = None
_speech_before_latch: Optional[bool] = None
_mic_before_latch: Optional[str] = None
_last_trace_mono: Optional[float] = None
_trace_seq = 0


def _log(msg: str, *, notify: bool = False) -> None:
    if not _DEBUG:
        return
    print("wispr_flow: %s" % msg)
    if notify and _DEBUG_NOTIFY:
        actions.app.notify("Wispr Flow", msg)


def _trace(source: str, edge: str) -> None:
    global _last_trace_mono, _trace_seq
    if not _TRACE_GESTURE:
        return
    now = time.perf_counter()
    _trace_seq += 1
    delta = (
        "" if _last_trace_mono is None else " Δ%.1fms" % ((now - _last_trace_mono) * 1000)
    )
    _last_trace_mono = now
    hold = (
        ""
        if _down_ts is None
        else " since_down=%.0fms" % ((now - _down_ts) * 1000)
    )
    print(
        "wispr_flow[trace #%s]%s %s %s latched=%s down_ts=%s%s"
        % (_trace_seq, delta, source, edge, _latched, _down_ts is not None, hold)
    )


def _unlatch() -> None:
    global _latched, _down_ts, _last_short_release_ts, _speech_before_sequence
    global _speech_before_latch, _mic_before_latch
    if not _latched:
        return
    print("wispr_flow: >>> UNLATCH called")
    traceback.print_stack()
    _log("unlatch")
    _latched = False
    _down_ts = None
    _last_short_release_ts = None
    _speech_before_sequence = None
    actions.mode.disable("user.wispr_flow_latched")
    # Restore speech to what it was before the gesture sequence
    if _speech_before_latch:
        actions.speech.enable()
    # Restore mic to what it was before the gesture sequence
    if _mic_before_latch:
        actions.sound.set_microphone(_mic_before_latch)
    _speech_before_latch = None
    _mic_before_latch = None


def _gesture_down() -> None:
    global _down_ts, _speech_before_sequence, _mic_before_latch
    _log("gesture down")
    if _speech_before_sequence is None:
        _speech_before_sequence = actions.speech.enabled()
    if _mic_before_latch is None:
        _mic_before_latch = actions.sound.active_microphone()
    actions.speech.disable()
    actions.sound.set_microphone("None")
    _down_ts = time.perf_counter()


def _gesture_up(from_bridge: bool = False) -> None:
    global _latched, _down_ts, _last_short_release_ts
    global _speech_before_sequence, _speech_before_latch, _mic_before_latch

    if _down_ts is None:
        _log("gesture up ignored (no prior down)")
        return

    duration_ms = (time.perf_counter() - _down_ts) * 1000
    if not from_bridge and duration_ms < _GLITCH_UP_IGNORE_MS:
        _log(
            "gesture up ignored (glitch %.0fms < %.0fms)"
            % (duration_ms, _GLITCH_UP_IGNORE_MS)
        )
        return

    _down_ts = None

    if duration_ms >= _HOLD_THRESHOLD_MS:
        _last_short_release_ts = None
        if _speech_before_sequence:
            actions.speech.enable()
        if _mic_before_latch:
            actions.sound.set_microphone(_mic_before_latch)
        _speech_before_sequence = None
        _mic_before_latch = None
        _log("gesture up hold %.0fms -> re-enable speech & mic" % duration_ms)
        return

    # Check for double-tap (second tap within 450ms of previous release)
    global _just_latched
    now = time.perf_counter()
    if (
        _last_short_release_ts is not None
        and (now - _last_short_release_ts) * 1000 <= _DOUBLE_TAP_MS
    ):
        # Double-tap: enter latch mode
        _last_short_release_ts = None
        _latched = True
        _speech_before_latch = _speech_before_sequence
        # _mic_before_latch already saved in _gesture_down()
        _speech_before_sequence = None
        actions.mode.enable("user.wispr_flow_latched")
        actions.sound.set_microphone("None")
        print("wispr_flow: >>> LATCH ENTERED (double-tap %.0fms)" % duration_ms)
        _log("gesture up %.0fms -> double-tap latch" % duration_ms)
        return

    # Single tap: restore state immediately (no action, just muted during tap)
    _last_short_release_ts = now
    if _speech_before_sequence:
        actions.speech.enable()
    if _mic_before_latch:
        actions.sound.set_microphone(_mic_before_latch)
    _speech_before_sequence = None
    _mic_before_latch = None
    _log("gesture up %.0fms -> single tap (restored)" % duration_ms)


@mod.action_class
class Actions:
    def wispr_flow_chord_down() -> None:
        """Cmd+F12 down (injected or hardware): mute speech while not latched."""
        _trace("chord", "DOWN")
        if _latched:
            return
        _gesture_down()

    def wispr_flow_chord_up() -> None:
        """Cmd+F12 up: unlatch if latched; else tap / hold / double-tap."""
        _trace("chord", "UP")
        if _latched:
            _unlatch()
            return
        _gesture_up()

    def wispr_flow_shadow_f18_down() -> None:
        """Gesture start from wispr_key_bridge_mac (or optional F18 key); mute while not latched."""
        _trace("f18", "DOWN")
        if _latched:
            return
        _gesture_down()

    def wispr_flow_shadow_f18_up() -> None:
        """F18 up; same semantics as chord up."""
        _trace("f18", "UP")
        if _latched:
            _unlatch()
            return
        _gesture_up(from_bridge=True)

    def wispr_flow_shadow_f19_down() -> None:
        """Optional: F19 shadow key if you map that in Talon instead of F18."""
        _trace("f19", "DOWN")
        if _latched:
            return
        _gesture_down()

    def wispr_flow_shadow_f19_up() -> None:
        """F19 up: unlatch if latched; else tap / hold / double-tap."""
        _trace("f19", "UP")
        if _latched:
            _unlatch()
            return
        _gesture_up(from_bridge=True)

    def wispr_flow_unlatch() -> None:
        """Leave latched mode and re-enable speech (e.g. from a voice command)."""
        _unlatch()


_child: Optional[subprocess.Popen] = None  # type: ignore[type-arg]


def _kill_child() -> None:
    global _child
    p = _child
    if p is None:
        return
    try:
        p.terminate()
        try:
            p.wait(timeout=1.0)
        except subprocess.TimeoutExpired:
            p.kill()
    except Exception as e:
        print("wispr_flow: error stopping wispr-flow-bridge: %s" % e)
    _child = None


def _start_bridge_helper() -> None:
    global _child
    if sys.platform != "darwin":
        return
    binary = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "wispr_bridge",
        "wispr-flow-bridge",
    )
    if not os.path.isfile(binary):
        print(
            "wispr_flow: wispr-flow-bridge not found at %s — run wispr_bridge/install.sh"
            % binary
        )
        return
    sock_path = os.environ.get(
        "WISPR_FLOW_BRIDGE_SOCKET",
        os.path.expanduser("~/.talon/wispr_flow_bridge.sock"),
    )
    env = {**os.environ, "WISPR_FLOW_BRIDGE_SOCKET": sock_path}
    _child = subprocess.Popen(
        [binary],
        env=env,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )
    print("wispr_flow: spawned wispr-flow-bridge pid=%s" % _child.pid)
    atexit.register(_kill_child)


_start_bridge_helper()
