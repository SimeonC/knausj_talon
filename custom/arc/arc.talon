os: mac
app: Arc
-
tag(): browser
tag(): user.tabs

add split|split right|new split: key(ctrl-shift-=)
close split: key(ctrl-shift--)
split next|cross: key("ctrl-shift-]")
split (prev|last|previous): key("ctrl-shift-[")

space next: key(cmd-alt-right)
space (last|prev): key(cmd-alt-left)
space <number>: key("ctrl-{number}")

(copy|get) (address|url|link): key(cmd-shift-c)
(copy|get) markdown (address|url|link): key(cmd-shift-alt-c)
change url: key(cmd-l)
[toggle] ((dev|developer) tools|console): key(cmd-alt-i)
refresh it: key(cmd-r)
force refresh: key(cmd-shift-r)

tab open|new tab|tab new|quick actions|please$: key(cmd-t)
please <user.text>:
    key(cmd-t)
    sleep(200ms)
    insert(user.text)
tab (archive|close): key(cmd-w)
tab (dupe|duplicate|copy): key(cmd-shift-d)
tab (pin|unpin): key(cmd-d)
tab (previous|last|prev): key("cmd-{")
tab next: key("cmd-}")
reopen tab: key(cmd-shift-t)
tab <number>: key("cmd-{number}")

go back: key("cmd-[")
go forward: key("cmd-]")
toggle full screen: key(ctrl-cmd-f)

toggle sidebar: key(cmd-s)
sidebar <number>: key("cmd-{number}")

center this: key(cmd-j)
find this: key(cmd-shift-alt-f)

new (easel|whiteboard|board): key(ctrl-shift-e)
new note: key(ctrl-n)
new note in split|new split note: key(ctrl-alt-n)
new window: key(cmd-n)

view archive: key(cmd-ctrl-shift-a)
view (downloads|download): key(cmd-ctrl-shift-d)
view history: key(cmd-ctrl-shift-h)
view library: key(cmd-ctrl-shift-l)
view source: key(cmd-ctrl-shift-s)

open in space: key(cmd-o)