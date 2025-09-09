os: mac
app: Kaleidoscope
-

(choose | pick) (left|a|air): key(cmd-ctrl-right)
(choose | pick) (left|a|air) first: key(cmd-alt-right)
(choose | pick) (right|b|bat): key(cmd-ctrl-left)
(choose | pick) (right|b|bat) first: key(cmd-alt-left)

next change: key(cmd-down)
next conflict: key(cmd-alt-down)
(prev|previous|last) change: key(cmd-up)
(prev|previous|last) conflict: key(cmd-alt-up)

(confirm|accept) changes:
    key(cmd-w)
    sleep(200ms)
    key(enter)
    sleep(200ms)
    user.switcher_focus("Tower")