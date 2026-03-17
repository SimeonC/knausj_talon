from talon import Context, Module, actions, app

ctx = Context()
mod = Module()

mod.apps.arc = "app.name: Arc"
mod.apps.arc = """
os: mac
app.bundle: company.thebrowser.Browser

"""
ctx.matches = r"""
app: arc
"""


@ctx.action_class("user")
class UserActions:
    def tab_close_wrapper():
        actions.sleep("180ms")
        actions.app.tab_close()

    def command_search(command: str = ""):
        actions.key("cmd-l")
        if command != "":
            actions.sleep("200ms")
            actions.insert(command)

    def address_copy_address():
        actions.key("cmd-shift-c")


@ctx.action_class("browser")
class BrowserActions:
    def show_extensions():
        actions.app.tab_open()
        actions.browser.go("arc://extensions")
