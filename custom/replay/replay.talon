os: mac
app: Replay
-
tab open|new tab|tab new$: key(cmd-t)
tab close: key(cmd-w)
tab (previous|last|prev): key("cmd-{")
tab next: key("cmd-}")
reopen tab: key(cmd-shift-t)
tab <number>: key("cmd-{number}")

go back: key("cmd-[")
go forward: key("cmd-]")

refresh it: key(cmd-r)

view info: key(ctrl-alt-1)
view comments: key(ctrl-alt-2)
view source: key(ctrl-alt-3)
view search: key(ctrl-alt-4)
view (debug|debugger|pause): key(ctrl-alt-5)

file hunt [phrase]:
    key(cmd-p)
    sleep(100ms)
    insert(phrase or "")
func hunt [phrase]:
    key(cmd-p)
    sleep(100ms)
    insert(user.formatted_text(phrase or "", "PRIVATE_CAMEL_CASE"))
scout all [phrase]:
    key(cmd-shift-f)
    sleep(100ms)
    insert(phrase or "")

next log: key(ctrl-alt-shift-right)
(prev|previous) log: key(ctrl-alt-shift-left)
step back: key(ctrl-alt-left)
step next: key(ctrl-alt-right)
step in: key(ctrl-alt-down)
step out: key(ctrl-alt-up)

add log: key(ctrl-alt-enter)
scout: key(cmd-f)
scout [phrase]:
    key(cmd-f)
    sleep(100ms)
    insert(phrase or "")
scout next: key(cmd-g)
scout (prev|previous): key(cmd-shift-g)