os: mac
app: Ghostty
mode: command
mode: dictation
-

^(claude|clawed) on$:
    mode.disable("command")
    mode.enable("dictation")

^(claude|clawed) send$:
    key(enter)

^(claude|clawed) off$:
    mode.disable("dictation")
    mode.enable("command")
    key(ctrl-c)

^(claude|clawed) stop$:
    key(ctrl-c)

^(claude|clawed) plan$:
    insert("/plan\n")

^(claude|clawed) fast$:
    insert("/model haiku\n")

^(claude|clawed) (think|slow)$:
    insert("/model opus[1m]\n")

^(claude|clawed) <user.claude_model>$:
    insert("/model {user.claude_model}\n")

^(claude|clawed) compact$:
    insert("/compact\n")

^(claude|clawed) clear$:
    insert("/clear\n")

^(claude|clawed) undo$:
    insert("/undo\n")

^(claude|clawed) next$:
    key(ctrl-alt-shift-cmd-tab)

^(claude|clawed) close$:
    insert('/exit')
    sleep(100ms)
    key(enter)
    sleep(500ms)
    insert('exit')
    key(enter)
    sleep(500ms)
    insert('exit')
    key(enter)

^(claude|clawed) close container$:
    insert('/exit')
    sleep(100ms)
    key(enter)
    sleep(500ms)
    insert('exit')
    key(enter)
    sleep(500ms)
    insert('exit')
    key(enter)
    sleep(500ms)
    insert('exit')
    key(enter)

^(claude|clawed) (switch|model) <user.claude_model>$:
    insert("/model {user.claude_model}\n")
