mode: command
mode: dictation
-
^vibe on$:
    user.vscode("composer.startComposerPrompt")
    mode.disable("command")
    mode.enable("dictation")
^vibe new$:
    user.vscode("composer.newAgentChat")
    mode.disable("command")
    mode.enable("dictation")
^generate$:
    user.vscode("aipopup.action.modal.generate")
    mode.disable("command")
    mode.enable("dictation")
^except|accept$:
    key(cmd-enter)
    mode.disable("dictation")
    mode.enable("command")
^vibe send$:
    key(enter)
^vibe (clear|off)$:
    mode.disable("dictation")
    mode.enable("command")
    key(esc)
^vibe stop$:
    key(cmd-backspace)
    key(cmd-backspace)
^next file$:
    user.vscode("editor.action.inlineDiffs.nextDiffFile")
^prev file$:
    user.vscode("editor.action.inlineDiffs.previousDiffFile")
^next change$:
    user.vscode("editor.action.inlineDiffs.nextChange")
^prev change$:
    user.vscode("editor.action.inlineDiffs.previousChange")
^(accept|except) this$:
    user.vscode("editor.action.inlineDiffs.acceptPartialEdit")
    user.vscode("editor.action.inlineDiffs.nextChange")
^(accept|except) all$:
    user.vscode("editor.action.inlineDiffs.acceptAll")
^(reject|throw) this$:
    user.vscode("editor.action.inlineDiffs.rejectPartialEdit")
    user.vscode("editor.action.inlineDiffs.nextChange")
^(reject|throw) (all|file)$:
    key(cmd-backspace)
^nope$:
    key(cmd-z)
^clear all$:
    key(cmd-a)
    key(backspace)
