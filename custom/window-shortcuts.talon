window full:
    user.snap_to_full_with_stage_manager()
key(alt-cmd-ctrl-shift-enter):
    user.snap_to_full_with_stage_manager()

check slack:
    user.switcher_focus("Slack")
    sleep(200ms)
    key(shift-cmd-a)
coder open <word>$:
    key(cmd-space)
    sleep(100ms)
    insert("code {word}")
dev site <word>:
    key(cmd-space)
    sleep(100ms)
    insert("dv {word}")
    sleep(100ms)
    key(enter)
(stage|staging) site <word>:
    key(cmd-space)
    sleep(100ms)
    insert("qa {word}")
    sleep(100ms)
    key(enter)
pilot site <word>:
    key(cmd-space)
    sleep(100ms)
    insert("pilot {word}")
    sleep(100ms)
    key(enter)
prod site <word>:
    key(cmd-space)
    sleep(100ms)
    insert("prod {word}")
    sleep(100ms)
    key(enter)
replay dev <word>:
    key(cmd-space)
    sleep(100ms)
    insert("dv {word}")
    sleep(100ms)
    key(alt-enter)
replay (stage|staging) <word>:
    key(cmd-space)
    sleep(100ms)
    insert("qa {word}")
    sleep(100ms)
    key(alt-enter)
replay pilot <word>:
    key(cmd-space)
    sleep(100ms)
    insert("pilot {word}")
    sleep(100ms)
    key(alt-enter)
replay prod <word>:
    key(cmd-space)
    sleep(100ms)
    insert("prod {word}")
    sleep(100ms)
    key(alt-enter)
