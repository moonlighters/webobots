#!/usr/bin/env python
# -*- coding: utf-8 -*-

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

errors = lexer.errors_list + parser.errors_list
if len(errors) > 0:
    #sys.stderr.write("There were %i error(s)!\n" % errc);
    for msg in errors:
        print msg.encode('utf8')
    sys.exit(1)

root = r.tree
print root.toStringTree();

#nodes = antlr3.tree.CommonTreeNodeStream(root)
#nodes.setTokenStream(tokens)

