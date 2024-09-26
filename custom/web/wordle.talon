tag: browser
win.title: /Wordle/
-

clear|clear all:
    key(backspace)
    repeat(5)
submit: key(enter)
share: 
    key(ctrl-alt-s)
    key(ctrl-alt-s)
    sleep(200ms)
    user.switcher_focus("Slack")
    sleep(400ms)
    key(cmd-k)
    insert("wordle")
    sleep(50ms)
    key(enter)
    sleep(200ms)
    edit.paste()