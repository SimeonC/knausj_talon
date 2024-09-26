
confirm: key(enter)
submit: key(cmd-enter)
cancel|flay: key(esc)
slap: edit.line_insert_down()
alfred [<phrase>]:
  key(cmd-space)
  sleep(100ms)
  insert(phrase or "")
alfred this: key(alt-cmd-ctrl-shift-space)
(one pass|passwords) [<user.text>]:
  key(alt-cmd-ctrl-shift-1)
  sleep(200ms)
  insert(user.text or "")
meetings: key(alt-cmd-ctrl-shift-e)
clippy: key(alt-cmd-ctrl-shift-c)
^command <number>$: key("cmd-number}")
exec <user.text>:
  insert(user.text)
  key(enter)
(preferences|app settings): key(cmd-,)
emojis: key(ctrl-cmd-space)
toggle (dark mode|theme): key(alt-cmd-ctrl-shift-d)
github <user.text>:
  key(cmd-space)
  sleep(100ms)
  insert("gh ")
  insert(user.text or "")
open (code|dev) <user.text>:
  key(cmd-space)
  sleep(100ms)
  insert("code ")
  insert(user.text)
  sleep(500ms)
  key(enter)

toggle lights: key(alt-cmd-ctrl-shift-f11)

(little|many|mini) arc: key(alt-cmd-ctrl-shift-n)
(little|many|mini) arc this: key(alt-cmd-ctrl-shift-m)

huddle unmute:
  mode.enable("user.slack_huddle")
  mode.disable("command")
  key(cmd-shift-space)
  speech.disable()

pick color: key(alt-cmd-ctrl-shift-p)

compare copy: key(alt-cmd-ctrl-shift-2)
compare copy with: key(alt-cmd-ctrl-shift-3)