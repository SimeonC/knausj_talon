from talon import Context, Module, actions

mod = Module()

sleep_ctx = Context()
sleep_ctx.matches = r"""
mode: sleep
"""

wake_ctx = Context()

@sleep_ctx.action_class("user")
class SleepUserActions:
    def pop():
        print("pop action sleep")
        #actions.speech.enable()


@wake_ctx.action_class("user")
class WakeUserActions:
    def pop():
        print("pop action wake")
        #actions.core.repeat_phrase(1)