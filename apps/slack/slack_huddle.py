from talon import Module, actions

mod = Module()

@mod.action_class
class Actions:
    def toggle_microphone():
        """Toggles microphone between 'None' and 'System Default'"""
        current_microphone = actions.sound.active_microphone()
        if current_microphone != "None":
            actions.sound.set_microphone("None")
        else:
            actions.sound.set_microphone("System Default")
