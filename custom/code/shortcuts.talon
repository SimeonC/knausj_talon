banger: insert('!!')
ellipsis|splat: insert("...")
item <number>:
    insert("[{number}]")
item <word>:
    insert("['{word}']")
drip [<phrase>]:
    insert(', ')
    user.parse_phrase(phrase or "")
line drip [<phrase>]:
    insert(',')
    key(enter)
    user.parse_phrase(phrase or "")
box|square:
    insert('[]')
    key(left)
generic|diamond:
    insert('<>')
    key(left)
import react:
    insert("import * as React from 'react';")
toggle word wrap: key(alt-z)
focus ribbon: key(cmd-shift-.)