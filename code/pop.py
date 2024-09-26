from talon import Module, noise, actions

mod = Module()
@mod.action_class
class Actions:
    def pop(): "Action that occurs on pop."

def on_pop(active):
    actions.user.pop()

noise.register("pop", on_pop)
