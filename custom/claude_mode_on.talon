os: mac
mode: user.claude_mode
-
^send|submit$:
    key(enter)
    mode.disable("user.claude_mode")
    mode.enable("command")
    mode.disable("dictation")

key(esc):
    mode.disable("user.claude_mode")
    mode.enable("command")
    mode.disable("dictation")

key(ctrl-alt-cmd-shift-a):
    mode.disable("dictation")
    mode.disable("user.claude_mode")
    mode.enable("command")
    key(cmd-a)
    key(delete)
    sleep(100ms)
    key(ctrl-alt-cmd-shift-8)