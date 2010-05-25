# -*- coding: utf-8 -*-
##
#
# Antlr parser helper
# 
# Some methods, that are used by both parser and lexer classes

from antlr3 import *
from antlr3.constants import EOF

def getTokenErrorDisplay(t):
    s = t.text
    if s is None:
        if t.type == EOF:
            return u'конец файла'
        else:
            s = "<"+t.type+">"
    if s == '\n':
        return u'конец строки'
    return "'%s'" % s

def getErrorHeader(e):
    if e.line != 0:
        return u"строка %d:" % e.line #e.charPositionInLine
    else:
        return u"конец файла:"

def getCharErrorDisplay(c):
    if c == EOF:
        return u'конец файла'
    if c == '\n':
        return u'конец строки'
    return "'%s'" % str(c)

def getParserErrorMessage(parser, e, tokenNames):
    if isinstance(e, UnwantedTokenException):
        tokenName = "<unknown>"
        if e.expecting == EOF:
            tokenName = "EOF"

        else:
            tokenName = parser.tokenNames[e.expecting]

        msg = u"неожиданный %s, ожидается %s" % (
            parser.getTokenErrorDisplay(e.getUnexpectedToken()),
            tokenName
            )

    elif isinstance(e, MissingTokenException):
        tokenName = "<unknown>"
        if e.expecting == EOF:
            tokenName = u'конец файла'

        else:
            tokenName = parser.tokenNames[e.expecting]

        msg = u"ожидался %s около %s" % (
            tokenName, parser.getTokenErrorDisplay(e.token)
            )

    elif isinstance(e, MismatchedTokenException):
        tokenName = "<unknown>"
        if e.expecting == EOF:
            tokenName = "EOF"
        else:
            tokenName = parser.tokenNames[e.expecting]

        msg = u"неожиданный " \
              + parser.getTokenErrorDisplay(e.token) \
              + u", ожидается " \
              + tokenName

    elif isinstance(e, MismatchedTreeNodeException):
        tokenName = "<unknown>"
        if e.expecting == EOF:
            tokenName = "EOF"
        else:
            tokenName = parser.tokenNames[e.expecting]

        msg = u"неподходящий узел дерева: %s, ожидался %s" \
              % (e.node, tokenName)

    elif isinstance(e, NoViableAltException):
        msg = u"невозможно продолжить разобр около " \
              + parser.getTokenErrorDisplay(e.token)

    elif isinstance(e, EarlyExitException):
        msg = u"недостаточно символов около " \
              + parser.getTokenErrorDisplay(e.token)

    elif isinstance(e, MismatchedSetException):
        msg = u"не ожидался " \
              + parser.getTokenErrorDisplay(e.token) \
              + u", ожидается набор " \
              + repr(e.expecting)

    elif isinstance(e, MismatchedNotSetException):
        msg = u"не ожидался " \
              + parser.getTokenErrorDisplay(e.token) \
              + u", ожидается набор " \
              + repr(e.expecting)

    elif isinstance(e, FailedPredicateException):
        msg = u"правило " \
              + e.ruleName \
              + u", не удовлетворен предикат: {" \
              + e.predicateText \
              + "}?"

    else:
        msg = str(e)

    return msg

def getLexerErrorMessage(lexer, e, tokenNames):
    msg = None
    
    if isinstance(e, MismatchedTokenException):
        msg = u"неожиданный символ " \
              + lexer.getCharErrorDisplay(e.c) \
              + u", ожидается " \
              + lexer.getCharErrorDisplay(e.expecting)

    elif isinstance(e, NoViableAltException):
        msg = u"невозможно разобрать символ " \
              + lexer.getCharErrorDisplay(e.c)

    elif isinstance(e, EarlyExitException):
        msg = u"недостаточно символов около " \
              + lexer.getCharErrorDisplay(e.c)
        
    elif isinstance(e, MismatchedNotSetException):
        msg = u"неожиданный символ " \
              + lexer.getCharErrorDisplay(e.c) \
              + u", ожидается набор " \
              + repr(e.expecting)

    elif isinstance(e, MismatchedSetException):
        msg = u"неожиданный символ " \
              + lexer.getCharErrorDisplay(e.c) \
              + u", ожидается набор " \
              + repr(e.expecting)

    elif isinstance(e, MismatchedRangeException):
        msg = u"неожиданный символ, " \
              + lexer.getCharErrorDisplay(e.c) \
              + u", ожидался символ в пределах " \
              + lexer.getCharErrorDisplay(e.a) \
              + ".." \
              + lexer.getCharErrorDisplay(e.b)

    else:
        msg = getParserMessage(lexer, e, tokenNames)

    return msg
