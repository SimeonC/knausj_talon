from talon import Module

mod = Module()

@mod.capture(rule="opus | sonnet | haiku")
def claude_model(m) -> str:
    """Claude model name"""
    return str(m)
