# $ANTLR 3.0.1 waffle.g 2010-05-18 18:39:36

from antlr3 import *
from antlr3.compat import set, frozenset

from antlr3.tree import *



# for convenience in actions
HIDDEN = BaseRecognizer.HIDDEN

# token types
WS=7
NEWLINE=4
INT=6
ID=5
EOF=-1

# token names
tokenNames = [
    "<invalid>", "<EOR>", "<DOWN>", "<UP>", 
    "NEWLINE", "ID", "INT", "WS", "'='", "'+'", "'-'", "'*'", "'('", "')'"
]



class waffleParser(Parser):
    grammarFileName = "waffle.g"
    tokenNames = tokenNames

    def __init__(self, input):
        Parser.__init__(self, input)



                
        self.adaptor = CommonTreeAdaptor()




    class prog_return(object):
        def __init__(self):
            self.start = None
            self.stop = None

            self.tree = None


    # $ANTLR start prog
    # waffle.g:9:1: prog : ( stat )+ ;
    def prog(self, ):

        retval = self.prog_return()
        retval.start = self.input.LT(1)

        root_0 = None

        stat1 = None



        try:
            try:
                # waffle.g:9:9: ( ( stat )+ )
                # waffle.g:9:11: ( stat )+
                root_0 = self.adaptor.nil()

                # waffle.g:9:11: ( stat )+
                cnt1 = 0
                while True: #loop1
                    alt1 = 2
                    LA1_0 = self.input.LA(1)

                    if ((NEWLINE <= LA1_0 <= INT) or LA1_0 == 12) :
                        alt1 = 1


                    if alt1 == 1:
                        # waffle.g:9:13: stat
                        self.following.append(self.FOLLOW_stat_in_prog59)
                        stat1 = self.stat()
                        self.following.pop()

                        self.adaptor.addChild(root_0, stat1.tree)
                        #action start
                        print stat1.tree.toStringTree();
                        #action end


                    else:
                        if cnt1 >= 1:
                            break #loop1

                        eee = EarlyExitException(1, self.input)
                        raise eee

                    cnt1 += 1





                retval.stop = self.input.LT(-1)


                retval.tree = self.adaptor.rulePostProcessing(root_0)
                self.adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)

            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
        finally:

            pass

        return retval

    # $ANTLR end prog

    class stat_return(object):
        def __init__(self):
            self.start = None
            self.stop = None

            self.tree = None


    # $ANTLR start stat
    # waffle.g:11:1: stat : ( expr NEWLINE -> expr | ID '=' expr NEWLINE -> ^( '=' ID expr ) | NEWLINE ->);
    def stat(self, ):

        retval = self.stat_return()
        retval.start = self.input.LT(1)

        root_0 = None

        NEWLINE3 = None
        ID4 = None
        char_literal5 = None
        NEWLINE7 = None
        NEWLINE8 = None
        expr2 = None

        expr6 = None


        NEWLINE3_tree = None
        ID4_tree = None
        char_literal5_tree = None
        NEWLINE7_tree = None
        NEWLINE8_tree = None
        stream_NEWLINE = RewriteRuleTokenStream(self.adaptor, "token NEWLINE")
        stream_ID = RewriteRuleTokenStream(self.adaptor, "token ID")
        stream_8 = RewriteRuleTokenStream(self.adaptor, "token 8")
        stream_expr = RewriteRuleSubtreeStream(self.adaptor, "rule expr")
        try:
            try:
                # waffle.g:11:9: ( expr NEWLINE -> expr | ID '=' expr NEWLINE -> ^( '=' ID expr ) | NEWLINE ->)
                alt2 = 3
                LA2 = self.input.LA(1)
                if LA2 == INT or LA2 == 12:
                    alt2 = 1
                elif LA2 == ID:
                    LA2_2 = self.input.LA(2)

                    if (LA2_2 == 8) :
                        alt2 = 2
                    elif (LA2_2 == NEWLINE or (9 <= LA2_2 <= 11)) :
                        alt2 = 1
                    else:
                        nvae = NoViableAltException("11:1: stat : ( expr NEWLINE -> expr | ID '=' expr NEWLINE -> ^( '=' ID expr ) | NEWLINE ->);", 2, 2, self.input)

                        raise nvae

                elif LA2 == NEWLINE:
                    alt2 = 3
                else:
                    nvae = NoViableAltException("11:1: stat : ( expr NEWLINE -> expr | ID '=' expr NEWLINE -> ^( '=' ID expr ) | NEWLINE ->);", 2, 0, self.input)

                    raise nvae

                if alt2 == 1:
                    # waffle.g:11:11: expr NEWLINE
                    self.following.append(self.FOLLOW_expr_in_stat76)
                    expr2 = self.expr()
                    self.following.pop()

                    stream_expr.add(expr2.tree)
                    NEWLINE3 = self.input.LT(1)
                    self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_stat78)

                    stream_NEWLINE.add(NEWLINE3)
                    # AST Rewrite
                    # elements: expr
                    # token labels: 
                    # rule labels: retval
                    # token list labels: 
                    # rule list labels: 

                    retval.tree = root_0

                    if retval is not None:
                        stream_retval = RewriteRuleSubtreeStream(self.adaptor, "token retval", retval.tree)
                    else:
                        stream_retval = RewriteRuleSubtreeStream(self.adaptor, "token retval", None)


                    root_0 = self.adaptor.nil()
                    # 11:25: -> expr
                    self.adaptor.addChild(root_0, stream_expr.next())





                elif alt2 == 2:
                    # waffle.g:12:11: ID '=' expr NEWLINE
                    ID4 = self.input.LT(1)
                    self.match(self.input, ID, self.FOLLOW_ID_in_stat95)

                    stream_ID.add(ID4)
                    char_literal5 = self.input.LT(1)
                    self.match(self.input, 8, self.FOLLOW_8_in_stat97)

                    stream_8.add(char_literal5)
                    self.following.append(self.FOLLOW_expr_in_stat99)
                    expr6 = self.expr()
                    self.following.pop()

                    stream_expr.add(expr6.tree)
                    NEWLINE7 = self.input.LT(1)
                    self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_stat101)

                    stream_NEWLINE.add(NEWLINE7)
                    # AST Rewrite
                    # elements: 8, expr, ID
                    # token labels: 
                    # rule labels: retval
                    # token list labels: 
                    # rule list labels: 

                    retval.tree = root_0

                    if retval is not None:
                        stream_retval = RewriteRuleSubtreeStream(self.adaptor, "token retval", retval.tree)
                    else:
                        stream_retval = RewriteRuleSubtreeStream(self.adaptor, "token retval", None)


                    root_0 = self.adaptor.nil()
                    # 12:31: -> ^( '=' ID expr )
                    # waffle.g:12:34: ^( '=' ID expr )
                    root_1 = self.adaptor.nil()
                    root_1 = self.adaptor.becomeRoot(stream_8.next(), root_1)

                    self.adaptor.addChild(root_1, stream_ID.next())
                    self.adaptor.addChild(root_1, stream_expr.next())

                    self.adaptor.addChild(root_0, root_1)





                elif alt2 == 3:
                    # waffle.g:13:11: NEWLINE
                    NEWLINE8 = self.input.LT(1)
                    self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_stat123)

                    stream_NEWLINE.add(NEWLINE8)
                    # AST Rewrite
                    # elements: 
                    # token labels: 
                    # rule labels: retval
                    # token list labels: 
                    # rule list labels: 

                    retval.tree = root_0

                    if retval is not None:
                        stream_retval = RewriteRuleSubtreeStream(self.adaptor, "token retval", retval.tree)
                    else:
                        stream_retval = RewriteRuleSubtreeStream(self.adaptor, "token retval", None)


                    root_0 = self.adaptor.nil()
                    # 13:25: ->
                    root_0 = self.adaptor.nil()




                retval.stop = self.input.LT(-1)


                retval.tree = self.adaptor.rulePostProcessing(root_0)
                self.adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)

            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
        finally:

            pass

        return retval

    # $ANTLR end stat

    class expr_return(object):
        def __init__(self):
            self.start = None
            self.stop = None

            self.tree = None


    # $ANTLR start expr
    # waffle.g:16:1: expr : multExpr ( ( '+' | '-' ) multExpr )* ;
    def expr(self, ):

        retval = self.expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal10 = None
        char_literal11 = None
        multExpr9 = None

        multExpr12 = None


        char_literal10_tree = None
        char_literal11_tree = None

        try:
            try:
                # waffle.g:16:9: ( multExpr ( ( '+' | '-' ) multExpr )* )
                # waffle.g:16:11: multExpr ( ( '+' | '-' ) multExpr )*
                root_0 = self.adaptor.nil()

                self.following.append(self.FOLLOW_multExpr_in_expr151)
                multExpr9 = self.multExpr()
                self.following.pop()

                self.adaptor.addChild(root_0, multExpr9.tree)
                # waffle.g:16:20: ( ( '+' | '-' ) multExpr )*
                while True: #loop4
                    alt4 = 2
                    LA4_0 = self.input.LA(1)

                    if ((9 <= LA4_0 <= 10)) :
                        alt4 = 1


                    if alt4 == 1:
                        # waffle.g:16:21: ( '+' | '-' ) multExpr
                        # waffle.g:16:21: ( '+' | '-' )
                        alt3 = 2
                        LA3_0 = self.input.LA(1)

                        if (LA3_0 == 9) :
                            alt3 = 1
                        elif (LA3_0 == 10) :
                            alt3 = 2
                        else:
                            nvae = NoViableAltException("16:21: ( '+' | '-' )", 3, 0, self.input)

                            raise nvae

                        if alt3 == 1:
                            # waffle.g:16:22: '+'
                            char_literal10 = self.input.LT(1)
                            self.match(self.input, 9, self.FOLLOW_9_in_expr155)


                            char_literal10_tree = self.adaptor.createWithPayload(char_literal10)
                            root_0 = self.adaptor.becomeRoot(char_literal10_tree, root_0)


                        elif alt3 == 2:
                            # waffle.g:16:27: '-'
                            char_literal11 = self.input.LT(1)
                            self.match(self.input, 10, self.FOLLOW_10_in_expr158)


                            char_literal11_tree = self.adaptor.createWithPayload(char_literal11)
                            root_0 = self.adaptor.becomeRoot(char_literal11_tree, root_0)



                        self.following.append(self.FOLLOW_multExpr_in_expr162)
                        multExpr12 = self.multExpr()
                        self.following.pop()

                        self.adaptor.addChild(root_0, multExpr12.tree)


                    else:
                        break #loop4





                retval.stop = self.input.LT(-1)


                retval.tree = self.adaptor.rulePostProcessing(root_0)
                self.adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)

            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
        finally:

            pass

        return retval

    # $ANTLR end expr

    class multExpr_return(object):
        def __init__(self):
            self.start = None
            self.stop = None

            self.tree = None


    # $ANTLR start multExpr
    # waffle.g:19:1: multExpr : atom ( '*' atom )* ;
    def multExpr(self, ):

        retval = self.multExpr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal14 = None
        atom13 = None

        atom15 = None


        char_literal14_tree = None

        try:
            try:
                # waffle.g:20:9: ( atom ( '*' atom )* )
                # waffle.g:20:11: atom ( '*' atom )*
                root_0 = self.adaptor.nil()

                self.following.append(self.FOLLOW_atom_in_multExpr189)
                atom13 = self.atom()
                self.following.pop()

                self.adaptor.addChild(root_0, atom13.tree)
                # waffle.g:20:16: ( '*' atom )*
                while True: #loop5
                    alt5 = 2
                    LA5_0 = self.input.LA(1)

                    if (LA5_0 == 11) :
                        alt5 = 1


                    if alt5 == 1:
                        # waffle.g:20:17: '*' atom
                        char_literal14 = self.input.LT(1)
                        self.match(self.input, 11, self.FOLLOW_11_in_multExpr192)


                        char_literal14_tree = self.adaptor.createWithPayload(char_literal14)
                        root_0 = self.adaptor.becomeRoot(char_literal14_tree, root_0)
                        self.following.append(self.FOLLOW_atom_in_multExpr195)
                        atom15 = self.atom()
                        self.following.pop()

                        self.adaptor.addChild(root_0, atom15.tree)


                    else:
                        break #loop5





                retval.stop = self.input.LT(-1)


                retval.tree = self.adaptor.rulePostProcessing(root_0)
                self.adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)

            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
        finally:

            pass

        return retval

    # $ANTLR end multExpr

    class atom_return(object):
        def __init__(self):
            self.start = None
            self.stop = None

            self.tree = None


    # $ANTLR start atom
    # waffle.g:23:1: atom : ( INT | ID | '(' expr ')' );
    def atom(self, ):

        retval = self.atom_return()
        retval.start = self.input.LT(1)

        root_0 = None

        INT16 = None
        ID17 = None
        char_literal18 = None
        char_literal20 = None
        expr19 = None


        INT16_tree = None
        ID17_tree = None
        char_literal18_tree = None
        char_literal20_tree = None

        try:
            try:
                # waffle.g:23:9: ( INT | ID | '(' expr ')' )
                alt6 = 3
                LA6 = self.input.LA(1)
                if LA6 == INT:
                    alt6 = 1
                elif LA6 == ID:
                    alt6 = 2
                elif LA6 == 12:
                    alt6 = 3
                else:
                    nvae = NoViableAltException("23:1: atom : ( INT | ID | '(' expr ')' );", 6, 0, self.input)

                    raise nvae

                if alt6 == 1:
                    # waffle.g:23:11: INT
                    root_0 = self.adaptor.nil()

                    INT16 = self.input.LT(1)
                    self.match(self.input, INT, self.FOLLOW_INT_in_atom217)


                    INT16_tree = self.adaptor.createWithPayload(INT16)
                    self.adaptor.addChild(root_0, INT16_tree)



                elif alt6 == 2:
                    # waffle.g:24:11: ID
                    root_0 = self.adaptor.nil()

                    ID17 = self.input.LT(1)
                    self.match(self.input, ID, self.FOLLOW_ID_in_atom229)


                    ID17_tree = self.adaptor.createWithPayload(ID17)
                    self.adaptor.addChild(root_0, ID17_tree)



                elif alt6 == 3:
                    # waffle.g:25:11: '(' expr ')'
                    root_0 = self.adaptor.nil()

                    char_literal18 = self.input.LT(1)
                    self.match(self.input, 12, self.FOLLOW_12_in_atom241)

                    self.following.append(self.FOLLOW_expr_in_atom244)
                    expr19 = self.expr()
                    self.following.pop()

                    self.adaptor.addChild(root_0, expr19.tree)
                    char_literal20 = self.input.LT(1)
                    self.match(self.input, 13, self.FOLLOW_13_in_atom246)



                retval.stop = self.input.LT(-1)


                retval.tree = self.adaptor.rulePostProcessing(root_0)
                self.adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)

            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
        finally:

            pass

        return retval

    # $ANTLR end atom


 

    FOLLOW_stat_in_prog59 = frozenset([1, 4, 5, 6, 12])
    FOLLOW_expr_in_stat76 = frozenset([4])
    FOLLOW_NEWLINE_in_stat78 = frozenset([1])
    FOLLOW_ID_in_stat95 = frozenset([8])
    FOLLOW_8_in_stat97 = frozenset([5, 6, 12])
    FOLLOW_expr_in_stat99 = frozenset([4])
    FOLLOW_NEWLINE_in_stat101 = frozenset([1])
    FOLLOW_NEWLINE_in_stat123 = frozenset([1])
    FOLLOW_multExpr_in_expr151 = frozenset([1, 9, 10])
    FOLLOW_9_in_expr155 = frozenset([5, 6, 12])
    FOLLOW_10_in_expr158 = frozenset([5, 6, 12])
    FOLLOW_multExpr_in_expr162 = frozenset([1, 9, 10])
    FOLLOW_atom_in_multExpr189 = frozenset([1, 11])
    FOLLOW_11_in_multExpr192 = frozenset([5, 6, 12])
    FOLLOW_atom_in_multExpr195 = frozenset([1, 11])
    FOLLOW_INT_in_atom217 = frozenset([1])
    FOLLOW_ID_in_atom229 = frozenset([1])
    FOLLOW_12_in_atom241 = frozenset([5, 6, 12])
    FOLLOW_expr_in_atom244 = frozenset([13])
    FOLLOW_13_in_atom246 = frozenset([1])

