os: mac
app: Tower
-
show services: key(ctrl-cmd-s)
show repos: key(ctrl-cmd-r)
show (work|working|working copy): key(cmd-1)
show history: key(cmd-2)
show stash: key(cmd-3)
show pr: key(cmd-4)
show branch review: key(cmd-5)
show reflog: key(cmd-6)
show head: key(cmd-0)

go back: key(cmd-[)
go forward: key(cmd-])

tab next: key(ctrl-tab)
tab prev: key(ctrl-shift-tab)
tab open [<word>]:
    key(cmd-t)
    key(cmd-shift-o)
    insert(word or "")
quick open [<word>]:
    key(cmd-shift-o)
    insert(word or "")

checkout: key(cmd-shift-b)
merge: key(cmd-shift-m)
rebase: key(cmd-shift-r)
rebase onto: key(cmd-shift-ctrl-r)
stash: key(cmd-shift-s)
restore: key(cmd-shift-alt-s)
commit: key(cmd-shift-c)
commit submit:
    key(cmd-shift-c)
    sleep(100ms)
    key(cmd-enter)
stage all: key(cmd-shift-e)
unstage all: key(cmd-shift-alt-e)
discard all:
    key(cmd-a)
    key(cmd-shift-backspace)
discard (this | selected):
    key(cmd-shift-backspace)
fetch:
    key(cmd-shift-f)
    key(enter)
pull: key(cmd-shift-p)
push: key(cmd-shift-u)
force push: key(cmd-ctrl-u)
new branch: key(cmd-b)
diff: key(cmd-shift-d)

unfold all: key(cmd-alt-right)
fold all: key(cmd-alt-left)

view tree: key(cmd-ctrl-t)
view list: key(cmd-ctrl-l)