from talon import Context, Module, actions, app

ctx = Context()
mod = Module()

mod.apps.dia = "app.name: Dia"
mod.apps.dia = """
os: mac
app.bundle: company.thebrowser.dia

"""
ctx.matches = r"""
app: dia
"""


@ctx.action_class("user")
class UserActions:
    def address_copy_address():
        actions.key("cmd-shift-c")


@ctx.action_class("browser")
class BrowserActions:
    def show_extensions():
        actions.app.tab_open()
        actions.browser.go("chrome://extensions")
