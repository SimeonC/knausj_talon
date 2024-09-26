mode: command
mode: dictation
not speech.engine: dragon
-
# We define this *only* if the speech engine isn't Dragon, because if you're using Dragon,
# "go to sleep" is used to specifically control Dragon, and not affect Talon.
#
# It's a useful and well known command, though, so if you're using any other speech
# engine, this controls Talon.
#
# For a note about the optional <phrase>, see to_sleep_mode.talon.
^drowse [<phrase>]$:
    key(alt-cmd-ctrl-shift-f4)
    speech.disable()
drowse <phrase> resume$: skip()
key(alt-cmd-ctrl-shift-f13):
    key(alt-cmd-ctrl-shift-f4)
    speech.disable()