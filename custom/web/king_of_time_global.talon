# tag: browser
# win.title: /KING OF TIME/
-

^(timesheet|time sheet) <user.king_of_time_action>$:
    key(alt-cmd-ctrl-shift-n)
    sleep(400ms)
    insert("https://s2.kingtime.jp/independent/recorder/personal/?talon_action={king_of_time_action}")
    #key(enter)

^(timesheet|time sheet)$:
    key(alt-cmd-ctrl-shift-n)
    sleep(400ms)
    insert("https://s2.kingtime.jp/independent/recorder/personal/#")
    key(enter)