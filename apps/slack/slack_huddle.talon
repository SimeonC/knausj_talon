os: mac
mode: user.slack_huddle
-
key(alt-cmd-ctrl-shift-f13):
    skip()
    key(cmd-shift-space)
    speech.toggle()
huddle switch:
    key(cmd-shift-h)
    sleep(200ms)
    key(cmd-shift-h)
    speech.disable()
huddle quit:
    user.switcher_focus("Slack")
    sleep(200ms)
    mode.disable("user.slack_huddle")
    mode.enable("command")
    key(cmd-shift-h)
    speech.enable()
huddle clear:
    mode.disable("user.slack_huddle")
    mode.enable("command")
^drowse$:
    key(cmd-shift-space)
    speech.disable()
