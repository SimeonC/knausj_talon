from talon import Module, Context
from re import sub

mod = Module()
ctx = Context()

@mod.capture(rule="(clock in|clock out|start break|end break|open|display)")
def king_of_time_action(m) -> str:
    return f"{m}".replace(" ", "_").lower()