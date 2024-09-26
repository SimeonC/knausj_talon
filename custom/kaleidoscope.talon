os: mac
app: Kaleidoscope
-

(choose | pick) (left|a): key(cmd-right)
(choose | pick) (left|a) first: key(cmd-alt-right)
(choose | pick) (right|b): key(cmd-left)
(choose | pick) (right|b) first: key(cmd-alt-left)

next change: key(cmd-down)
next conflict: key(cmd-alt-down)
(prev|previous|last) change: key(cmd-up)
(prev|previous|last) conflict: key(cmd-alt-up)6

(confirm|accept) changes:
    key(cmd-s)
    key(cmd-w)
    sleep(200ms)
    user.switcher_focus("Tower")