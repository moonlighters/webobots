#!/usr/bin/env python

import sys
import antlr3
import antlr3.tree
from waffleLexer import waffleLexer
from waffleParser import waffleParser

char_stream = antlr3.ANTLRInputStream(sys.stdin)
lexer = waffleLexer(char_stream)
tokens = antlr3.CommonTokenStream(lexer)
parser = waffleParser(tokens)
r = parser.prog()

root = r.tree

nodes = antlr3.tree.CommonTreeNodeStream(root)
nodes.setTokenStream(tokens)
