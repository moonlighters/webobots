##
#
# Antlr parser helper
# 
# Some methods, that are used by both parser and lexer classes

from antlr3.constants import EOF

def getTokenErrorDisplay(t):
    s = t.text
    if s is None:
        if t.type == EOF:
            s = "<EOF>"
        else:
            s = "<"+t.type+">"

    return "'%s'" % s

def getErrorHeader(e):
    return "line %d:" % e.line

def getCharErrorDisplay(c):
    if c == EOF:
        c = '<EOF>'
    return "'%s'" % str(c)
