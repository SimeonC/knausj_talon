from talon import Module, Context
from ..code.delayed_speech_off import DelayedSpeechOffActions

mod = Module()

ctx = Context()

@ctx.action_class("user")
class PushToTalon:
    def push_to_talk_on():
        DelayedSpeechOffActions.delayed_speech_on()
    def push_to_talk_off():
        DelayedSpeechOffActions.delayed_speech_on()
