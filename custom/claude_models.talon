app: Ghostty

(switch [to]|model) <user.claude_model>:
    insert("/model {user.claude_model}")
    sleep(50ms)
    key(enter)
