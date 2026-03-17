from talon import Module

mod = Module()

@mod.capture(rule="opus | sonnet | haiku")
def claude_model(m) -> str:
    """Claude model name"""
    word = str(m)
    if word == "opus":
        return "opus[1m]"
    return word
