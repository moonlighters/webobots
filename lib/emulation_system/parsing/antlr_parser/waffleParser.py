# $ANTLR 3.1.2 /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g 2010-05-19 02:55:30

import sys
from antlr3 import *
from antlr3.compat import set, frozenset

from antlr3.tree import *



# for convenience in actions
HIDDEN = BaseRecognizer.HIDDEN

# token types
LETTER=8
T__20=20
NUMBER=7
ID=6
EOF=-1
T__19=19
WS=10
T__16=16
T__15=15
T__18=18
NEWLINE=5
T__17=17
T__12=12
T__11=11
T__14=14
T__13=13
BLOCK=4
DIGIT=9

# token names
tokenNames = [
    "<invalid>", "<EOR>", "<DOWN>", "<UP>", 
    "BLOCK", "NEWLINE", "ID", "NUMBER", "LETTER", "DIGIT", "WS", "'='", 
    "'if'", "'('", "')'", "'else'", "'end'", "'+'", "'-'", "'*'", "'/'"
]




class waffleParser(Parser):
    grammarFileName = "/home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g"
    antlr_version = version_str_to_tuple("3.1.2")
    antlr_version_str = "3.1.2"
    tokenNames = tokenNames

    def __init__(self, input, state=None):
        if state is None:
            state = RecognizerSharedState()

        Parser.__init__(self, input, state)







                
        self._adaptor = CommonTreeAdaptor()


        
    def getTreeAdaptor(self):
        return self._adaptor

    def setTreeAdaptor(self, adaptor):
        self._adaptor = adaptor

    adaptor = property(getTreeAdaptor, setTreeAdaptor)

             
    def emitErrorMessage(self, msg):
        self.errors_list.append(msg)


    class prog_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "prog"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:18:1: prog : block ;
    def prog(self, ):

        retval = self.prog_return()
        retval.start = self.input.LT(1)

        root_0 = None

        block1 = None



        self.errors_list = []; 
        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:19:9: ( block )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:19:11: block
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_block_in_prog91)
                block1 = self.block()

                self._state.following.pop()
                self._adaptor.addChild(root_0, block1.tree)



                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "prog"

    class block_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "block"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:1: block : ( stat )* -> ^( BLOCK[\"block\"] ( stat )* ) ;
    def block(self, ):

        retval = self.block_return()
        retval.start = self.input.LT(1)

        root_0 = None

        stat2 = None


        stream_stat = RewriteRuleSubtreeStream(self._adaptor, "rule stat")
        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:9: ( ( stat )* -> ^( BLOCK[\"block\"] ( stat )* ) )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:11: ( stat )*
                pass 
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:11: ( stat )*
                while True: #loop1
                    alt1 = 2
                    LA1_0 = self.input.LA(1)

                    if ((NEWLINE <= LA1_0 <= ID) or LA1_0 == 12) :
                        alt1 = 1


                    if alt1 == 1:
                        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:11: stat
                        pass 
                        self._state.following.append(self.FOLLOW_stat_in_block109)
                        stat2 = self.stat()

                        self._state.following.pop()
                        stream_stat.add(stat2.tree)


                    else:
                        break #loop1



                # AST Rewrite
                # elements: stat
                # token labels: 
                # rule labels: retval
                # token list labels: 
                # rule list labels: 
                # wildcard labels: 

                retval.tree = root_0

                if retval is not None:
                    stream_retval = RewriteRuleSubtreeStream(self._adaptor, "rule retval", retval.tree)
                else:
                    stream_retval = RewriteRuleSubtreeStream(self._adaptor, "token retval", None)


                root_0 = self._adaptor.nil()
                # 21:33: -> ^( BLOCK[\"block\"] ( stat )* )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:36: ^( BLOCK[\"block\"] ( stat )* )
                root_1 = self._adaptor.nil()
                root_1 = self._adaptor.becomeRoot(self._adaptor.create(BLOCK, "block"), root_1)

                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:21:53: ( stat )*
                while stream_stat.hasNext():
                    self._adaptor.addChild(root_1, stream_stat.nextTree())


                stream_stat.reset();

                self._adaptor.addChild(root_0, root_1)



                retval.tree = root_0



                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "block"

    class stat_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "stat"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:23:1: stat : ( assig | ifelse | NEWLINE ->);
    def stat(self, ):

        retval = self.stat_return()
        retval.start = self.input.LT(1)

        root_0 = None

        NEWLINE5 = None
        assig3 = None

        ifelse4 = None


        NEWLINE5_tree = None
        stream_NEWLINE = RewriteRuleTokenStream(self._adaptor, "token NEWLINE")

        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:23:9: ( assig | ifelse | NEWLINE ->)
                alt2 = 3
                LA2 = self.input.LA(1)
                if LA2 == ID:
                    alt2 = 1
                elif LA2 == 12:
                    alt2 = 2
                elif LA2 == NEWLINE:
                    alt2 = 3
                else:
                    nvae = NoViableAltException("", 2, 0, self.input)

                    raise nvae

                if alt2 == 1:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:23:11: assig
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_assig_in_stat148)
                    assig3 = self.assig()

                    self._state.following.pop()
                    root_0 = self._adaptor.becomeRoot(assig3.tree, root_0)


                elif alt2 == 2:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:24:11: ifelse
                    pass 
                    root_0 = self._adaptor.nil()

                    self._state.following.append(self.FOLLOW_ifelse_in_stat177)
                    ifelse4 = self.ifelse()

                    self._state.following.pop()
                    root_0 = self._adaptor.becomeRoot(ifelse4.tree, root_0)


                elif alt2 == 3:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:25:11: NEWLINE
                    pass 
                    NEWLINE5=self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_stat190) 
                    stream_NEWLINE.add(NEWLINE5)

                    # AST Rewrite
                    # elements: 
                    # token labels: 
                    # rule labels: retval
                    # token list labels: 
                    # rule list labels: 
                    # wildcard labels: 

                    retval.tree = root_0

                    if retval is not None:
                        stream_retval = RewriteRuleSubtreeStream(self._adaptor, "rule retval", retval.tree)
                    else:
                        stream_retval = RewriteRuleSubtreeStream(self._adaptor, "token retval", None)


                    root_0 = self._adaptor.nil()
                    # 25:33: ->
                    root_0 = None


                    retval.tree = root_0


                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "stat"

    class assig_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "assig"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:28:1: assig : ID '=' expr NEWLINE -> ^( '=' ID expr ) ;
    def assig(self, ):

        retval = self.assig_return()
        retval.start = self.input.LT(1)

        root_0 = None

        ID6 = None
        char_literal7 = None
        NEWLINE9 = None
        expr8 = None


        ID6_tree = None
        char_literal7_tree = None
        NEWLINE9_tree = None
        stream_NEWLINE = RewriteRuleTokenStream(self._adaptor, "token NEWLINE")
        stream_ID = RewriteRuleTokenStream(self._adaptor, "token ID")
        stream_11 = RewriteRuleTokenStream(self._adaptor, "token 11")
        stream_expr = RewriteRuleSubtreeStream(self._adaptor, "rule expr")
        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:28:9: ( ID '=' expr NEWLINE -> ^( '=' ID expr ) )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:28:11: ID '=' expr NEWLINE
                pass 
                ID6=self.match(self.input, ID, self.FOLLOW_ID_in_assig225) 
                stream_ID.add(ID6)
                char_literal7=self.match(self.input, 11, self.FOLLOW_11_in_assig227) 
                stream_11.add(char_literal7)
                self._state.following.append(self.FOLLOW_expr_in_assig229)
                expr8 = self.expr()

                self._state.following.pop()
                stream_expr.add(expr8.tree)
                NEWLINE9=self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_assig231) 
                stream_NEWLINE.add(NEWLINE9)

                # AST Rewrite
                # elements: 11, ID, expr
                # token labels: 
                # rule labels: retval
                # token list labels: 
                # rule list labels: 
                # wildcard labels: 

                retval.tree = root_0

                if retval is not None:
                    stream_retval = RewriteRuleSubtreeStream(self._adaptor, "rule retval", retval.tree)
                else:
                    stream_retval = RewriteRuleSubtreeStream(self._adaptor, "token retval", None)


                root_0 = self._adaptor.nil()
                # 28:33: -> ^( '=' ID expr )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:28:36: ^( '=' ID expr )
                root_1 = self._adaptor.nil()
                root_1 = self._adaptor.becomeRoot(stream_11.nextNode(), root_1)

                self._adaptor.addChild(root_1, stream_ID.nextNode())
                self._adaptor.addChild(root_1, stream_expr.nextTree())

                self._adaptor.addChild(root_0, root_1)



                retval.tree = root_0



                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "assig"

    class ifelse_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "ifelse"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:30:1: ifelse : 'if' '(' expr ')' NEWLINE ifblock= block ( 'else' elseblock= block )? 'end' NEWLINE -> ^( 'if' expr $ifblock ( $elseblock)? ) ;
    def ifelse(self, ):

        retval = self.ifelse_return()
        retval.start = self.input.LT(1)

        root_0 = None

        string_literal10 = None
        char_literal11 = None
        char_literal13 = None
        NEWLINE14 = None
        string_literal15 = None
        string_literal16 = None
        NEWLINE17 = None
        ifblock = None

        elseblock = None

        expr12 = None


        string_literal10_tree = None
        char_literal11_tree = None
        char_literal13_tree = None
        NEWLINE14_tree = None
        string_literal15_tree = None
        string_literal16_tree = None
        NEWLINE17_tree = None
        stream_NEWLINE = RewriteRuleTokenStream(self._adaptor, "token NEWLINE")
        stream_15 = RewriteRuleTokenStream(self._adaptor, "token 15")
        stream_16 = RewriteRuleTokenStream(self._adaptor, "token 16")
        stream_13 = RewriteRuleTokenStream(self._adaptor, "token 13")
        stream_14 = RewriteRuleTokenStream(self._adaptor, "token 14")
        stream_12 = RewriteRuleTokenStream(self._adaptor, "token 12")
        stream_block = RewriteRuleSubtreeStream(self._adaptor, "rule block")
        stream_expr = RewriteRuleSubtreeStream(self._adaptor, "rule expr")
        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:30:9: ( 'if' '(' expr ')' NEWLINE ifblock= block ( 'else' elseblock= block )? 'end' NEWLINE -> ^( 'if' expr $ifblock ( $elseblock)? ) )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:30:11: 'if' '(' expr ')' NEWLINE ifblock= block ( 'else' elseblock= block )? 'end' NEWLINE
                pass 
                string_literal10=self.match(self.input, 12, self.FOLLOW_12_in_ifelse253) 
                stream_12.add(string_literal10)
                char_literal11=self.match(self.input, 13, self.FOLLOW_13_in_ifelse255) 
                stream_13.add(char_literal11)
                self._state.following.append(self.FOLLOW_expr_in_ifelse257)
                expr12 = self.expr()

                self._state.following.pop()
                stream_expr.add(expr12.tree)
                char_literal13=self.match(self.input, 14, self.FOLLOW_14_in_ifelse259) 
                stream_14.add(char_literal13)
                NEWLINE14=self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_ifelse261) 
                stream_NEWLINE.add(NEWLINE14)
                self._state.following.append(self.FOLLOW_block_in_ifelse277)
                ifblock = self.block()

                self._state.following.pop()
                stream_block.add(ifblock.tree)
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:32:11: ( 'else' elseblock= block )?
                alt3 = 2
                LA3_0 = self.input.LA(1)

                if (LA3_0 == 15) :
                    alt3 = 1
                if alt3 == 1:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:32:12: 'else' elseblock= block
                    pass 
                    string_literal15=self.match(self.input, 15, self.FOLLOW_15_in_ifelse290) 
                    stream_15.add(string_literal15)
                    self._state.following.append(self.FOLLOW_block_in_ifelse306)
                    elseblock = self.block()

                    self._state.following.pop()
                    stream_block.add(elseblock.tree)



                string_literal16=self.match(self.input, 16, self.FOLLOW_16_in_ifelse320) 
                stream_16.add(string_literal16)
                NEWLINE17=self.match(self.input, NEWLINE, self.FOLLOW_NEWLINE_in_ifelse322) 
                stream_NEWLINE.add(NEWLINE17)

                # AST Rewrite
                # elements: 12, elseblock, ifblock, expr
                # token labels: 
                # rule labels: ifblock, retval, elseblock
                # token list labels: 
                # rule list labels: 
                # wildcard labels: 

                retval.tree = root_0

                if ifblock is not None:
                    stream_ifblock = RewriteRuleSubtreeStream(self._adaptor, "rule ifblock", ifblock.tree)
                else:
                    stream_ifblock = RewriteRuleSubtreeStream(self._adaptor, "token ifblock", None)


                if retval is not None:
                    stream_retval = RewriteRuleSubtreeStream(self._adaptor, "rule retval", retval.tree)
                else:
                    stream_retval = RewriteRuleSubtreeStream(self._adaptor, "token retval", None)


                if elseblock is not None:
                    stream_elseblock = RewriteRuleSubtreeStream(self._adaptor, "rule elseblock", elseblock.tree)
                else:
                    stream_elseblock = RewriteRuleSubtreeStream(self._adaptor, "token elseblock", None)


                root_0 = self._adaptor.nil()
                # 34:33: -> ^( 'if' expr $ifblock ( $elseblock)? )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:34:36: ^( 'if' expr $ifblock ( $elseblock)? )
                root_1 = self._adaptor.nil()
                root_1 = self._adaptor.becomeRoot(stream_12.nextNode(), root_1)

                self._adaptor.addChild(root_1, stream_expr.nextTree())
                self._adaptor.addChild(root_1, stream_ifblock.nextTree())
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:34:57: ( $elseblock)?
                if stream_elseblock.hasNext():
                    self._adaptor.addChild(root_1, stream_elseblock.nextTree())


                stream_elseblock.reset();

                self._adaptor.addChild(root_0, root_1)



                retval.tree = root_0



                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "ifelse"

    class expr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "expr"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:1: expr : multExpr ( ( '+' | '-' ) multExpr )* ;
    def expr(self, ):

        retval = self.expr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal19 = None
        char_literal20 = None
        multExpr18 = None

        multExpr21 = None


        char_literal19_tree = None
        char_literal20_tree = None

        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:9: ( multExpr ( ( '+' | '-' ) multExpr )* )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:11: multExpr ( ( '+' | '-' ) multExpr )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_multExpr_in_expr357)
                multExpr18 = self.multExpr()

                self._state.following.pop()
                self._adaptor.addChild(root_0, multExpr18.tree)
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:20: ( ( '+' | '-' ) multExpr )*
                while True: #loop5
                    alt5 = 2
                    LA5_0 = self.input.LA(1)

                    if ((17 <= LA5_0 <= 18)) :
                        alt5 = 1


                    if alt5 == 1:
                        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:21: ( '+' | '-' ) multExpr
                        pass 
                        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:21: ( '+' | '-' )
                        alt4 = 2
                        LA4_0 = self.input.LA(1)

                        if (LA4_0 == 17) :
                            alt4 = 1
                        elif (LA4_0 == 18) :
                            alt4 = 2
                        else:
                            nvae = NoViableAltException("", 4, 0, self.input)

                            raise nvae

                        if alt4 == 1:
                            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:22: '+'
                            pass 
                            char_literal19=self.match(self.input, 17, self.FOLLOW_17_in_expr361)

                            char_literal19_tree = self._adaptor.createWithPayload(char_literal19)
                            root_0 = self._adaptor.becomeRoot(char_literal19_tree, root_0)



                        elif alt4 == 2:
                            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:36:27: '-'
                            pass 
                            char_literal20=self.match(self.input, 18, self.FOLLOW_18_in_expr364)

                            char_literal20_tree = self._adaptor.createWithPayload(char_literal20)
                            root_0 = self._adaptor.becomeRoot(char_literal20_tree, root_0)




                        self._state.following.append(self.FOLLOW_multExpr_in_expr368)
                        multExpr21 = self.multExpr()

                        self._state.following.pop()
                        self._adaptor.addChild(root_0, multExpr21.tree)


                    else:
                        break #loop5





                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "expr"

    class multExpr_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "multExpr"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:39:1: multExpr : atom ( ( '*' | '/' ) atom )* ;
    def multExpr(self, ):

        retval = self.multExpr_return()
        retval.start = self.input.LT(1)

        root_0 = None

        char_literal23 = None
        char_literal24 = None
        atom22 = None

        atom25 = None


        char_literal23_tree = None
        char_literal24_tree = None

        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:9: ( atom ( ( '*' | '/' ) atom )* )
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:11: atom ( ( '*' | '/' ) atom )*
                pass 
                root_0 = self._adaptor.nil()

                self._state.following.append(self.FOLLOW_atom_in_multExpr395)
                atom22 = self.atom()

                self._state.following.pop()
                self._adaptor.addChild(root_0, atom22.tree)
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:16: ( ( '*' | '/' ) atom )*
                while True: #loop7
                    alt7 = 2
                    LA7_0 = self.input.LA(1)

                    if ((19 <= LA7_0 <= 20)) :
                        alt7 = 1


                    if alt7 == 1:
                        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:17: ( '*' | '/' ) atom
                        pass 
                        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:17: ( '*' | '/' )
                        alt6 = 2
                        LA6_0 = self.input.LA(1)

                        if (LA6_0 == 19) :
                            alt6 = 1
                        elif (LA6_0 == 20) :
                            alt6 = 2
                        else:
                            nvae = NoViableAltException("", 6, 0, self.input)

                            raise nvae

                        if alt6 == 1:
                            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:18: '*'
                            pass 
                            char_literal23=self.match(self.input, 19, self.FOLLOW_19_in_multExpr399)

                            char_literal23_tree = self._adaptor.createWithPayload(char_literal23)
                            root_0 = self._adaptor.becomeRoot(char_literal23_tree, root_0)



                        elif alt6 == 2:
                            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:40:23: '/'
                            pass 
                            char_literal24=self.match(self.input, 20, self.FOLLOW_20_in_multExpr402)

                            char_literal24_tree = self._adaptor.createWithPayload(char_literal24)
                            root_0 = self._adaptor.becomeRoot(char_literal24_tree, root_0)




                        self._state.following.append(self.FOLLOW_atom_in_multExpr406)
                        atom25 = self.atom()

                        self._state.following.pop()
                        self._adaptor.addChild(root_0, atom25.tree)


                    else:
                        break #loop7





                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "multExpr"

    class atom_return(ParserRuleReturnScope):
        def __init__(self):
            ParserRuleReturnScope.__init__(self)

            self.tree = None




    # $ANTLR start "atom"
    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:43:1: atom : ( NUMBER | ID | '(' expr ')' );
    def atom(self, ):

        retval = self.atom_return()
        retval.start = self.input.LT(1)

        root_0 = None

        NUMBER26 = None
        ID27 = None
        char_literal28 = None
        char_literal30 = None
        expr29 = None


        NUMBER26_tree = None
        ID27_tree = None
        char_literal28_tree = None
        char_literal30_tree = None

        try:
            try:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:43:9: ( NUMBER | ID | '(' expr ')' )
                alt8 = 3
                LA8 = self.input.LA(1)
                if LA8 == NUMBER:
                    alt8 = 1
                elif LA8 == ID:
                    alt8 = 2
                elif LA8 == 13:
                    alt8 = 3
                else:
                    nvae = NoViableAltException("", 8, 0, self.input)

                    raise nvae

                if alt8 == 1:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:43:11: NUMBER
                    pass 
                    root_0 = self._adaptor.nil()

                    NUMBER26=self.match(self.input, NUMBER, self.FOLLOW_NUMBER_in_atom428)

                    NUMBER26_tree = self._adaptor.createWithPayload(NUMBER26)
                    self._adaptor.addChild(root_0, NUMBER26_tree)



                elif alt8 == 2:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:44:11: ID
                    pass 
                    root_0 = self._adaptor.nil()

                    ID27=self.match(self.input, ID, self.FOLLOW_ID_in_atom440)

                    ID27_tree = self._adaptor.createWithPayload(ID27)
                    self._adaptor.addChild(root_0, ID27_tree)



                elif alt8 == 3:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:45:11: '(' expr ')'
                    pass 
                    root_0 = self._adaptor.nil()

                    char_literal28=self.match(self.input, 13, self.FOLLOW_13_in_atom452)
                    self._state.following.append(self.FOLLOW_expr_in_atom455)
                    expr29 = self.expr()

                    self._state.following.pop()
                    self._adaptor.addChild(root_0, expr29.tree)
                    char_literal30=self.match(self.input, 14, self.FOLLOW_14_in_atom457)


                retval.stop = self.input.LT(-1)


                retval.tree = self._adaptor.rulePostProcessing(root_0)
                self._adaptor.setTokenBoundaries(retval.tree, retval.start, retval.stop)


            except RecognitionException, re:
                self.reportError(re)
                self.recover(self.input, re)
                retval.tree = self._adaptor.errorNode(self.input, retval.start, self.input.LT(-1), re)
        finally:

            pass

        return retval

    # $ANTLR end "atom"


    # Delegated rules


 

    FOLLOW_block_in_prog91 = frozenset([1])
    FOLLOW_stat_in_block109 = frozenset([1, 5, 6, 12])
    FOLLOW_assig_in_stat148 = frozenset([1])
    FOLLOW_ifelse_in_stat177 = frozenset([1])
    FOLLOW_NEWLINE_in_stat190 = frozenset([1])
    FOLLOW_ID_in_assig225 = frozenset([11])
    FOLLOW_11_in_assig227 = frozenset([6, 7, 13])
    FOLLOW_expr_in_assig229 = frozenset([5])
    FOLLOW_NEWLINE_in_assig231 = frozenset([1])
    FOLLOW_12_in_ifelse253 = frozenset([13])
    FOLLOW_13_in_ifelse255 = frozenset([6, 7, 13])
    FOLLOW_expr_in_ifelse257 = frozenset([14])
    FOLLOW_14_in_ifelse259 = frozenset([5])
    FOLLOW_NEWLINE_in_ifelse261 = frozenset([5, 6, 12])
    FOLLOW_block_in_ifelse277 = frozenset([15, 16])
    FOLLOW_15_in_ifelse290 = frozenset([5, 6, 12])
    FOLLOW_block_in_ifelse306 = frozenset([16])
    FOLLOW_16_in_ifelse320 = frozenset([5])
    FOLLOW_NEWLINE_in_ifelse322 = frozenset([1])
    FOLLOW_multExpr_in_expr357 = frozenset([1, 17, 18])
    FOLLOW_17_in_expr361 = frozenset([6, 7, 13])
    FOLLOW_18_in_expr364 = frozenset([6, 7, 13])
    FOLLOW_multExpr_in_expr368 = frozenset([1, 17, 18])
    FOLLOW_atom_in_multExpr395 = frozenset([1, 19, 20])
    FOLLOW_19_in_multExpr399 = frozenset([6, 7, 13])
    FOLLOW_20_in_multExpr402 = frozenset([6, 7, 13])
    FOLLOW_atom_in_multExpr406 = frozenset([1, 19, 20])
    FOLLOW_NUMBER_in_atom428 = frozenset([1])
    FOLLOW_ID_in_atom440 = frozenset([1])
    FOLLOW_13_in_atom452 = frozenset([6, 7, 13])
    FOLLOW_expr_in_atom455 = frozenset([14])
    FOLLOW_14_in_atom457 = frozenset([1])



def main(argv, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr):
    from antlr3.main import ParserMain
    main = ParserMain("waffleLexer", waffleParser)
    main.stdin = stdin
    main.stdout = stdout
    main.stderr = stderr
    main.execute(argv)


if __name__ == '__main__':
    main(sys.argv)
