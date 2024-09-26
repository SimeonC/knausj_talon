tag: browser
win.title: /codepen\.io/
-

complete: key(ctrl-space)
scout [<words>]:
    key(cmd-f)
    insert(words or "")
scout next: key(cmd-g)
scout (last|prev): key(cmd-shift-g)
replace [<words>]:
    key(cmd-alt-f)
    insert(words or "")
(outdent|dedent):
    key(cmd-[)
indent:
    key(cmd-])
format: key(shift-tab)
comment: key(cmd-/)

show html: key(cmd-alt-1)
show css: key(cmd-alt-2)
show (js|javascript): key(cmd-alt-3)
show console: key(cmd-alt-4)
show preview: key(cmd-alt-0)

run: key(cmd-shift-7)
(save|disk): key(cmd-s)

paste js:
    key(cmd-alt-3)
    sleep(20ms)
    key(cmd-a)
    sleep(20ms)
    key(cmd-v)
    sleep(20ms)
    key(cmd-shift-7)
    sleep(20ms)
    key(cmd-s)
    sleep(20ms)
