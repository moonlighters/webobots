# $ANTLR 3.0.1 waffle.g 2010-05-18 18:39:37

from antlr3 import *
from antlr3.compat import set, frozenset


# for convenience in actions
HIDDEN = BaseRecognizer.HIDDEN

# token types
WS=7
NEWLINE=4
T10=10
T11=11
INT=6
T12=12
T13=13
T8=8
T9=9
ID=5
Tokens=14
EOF=-1

class waffleLexer(Lexer):

    grammarFileName = "waffle.g"

    def __init__(self, input=None):
        Lexer.__init__(self, input)





    # $ANTLR start T8
    def mT8(self, ):

        try:
            self.type = T8

            # waffle.g:7:4: ( '=' )
            # waffle.g:7:6: '='
            self.match(u'=')





        finally:

            pass

    # $ANTLR end T8



    # $ANTLR start T9
    def mT9(self, ):

        try:
            self.type = T9

            # waffle.g:8:4: ( '+' )
            # waffle.g:8:6: '+'
            self.match(u'+')





        finally:

            pass

    # $ANTLR end T9



    # $ANTLR start T10
    def mT10(self, ):

        try:
            self.type = T10

            # waffle.g:9:5: ( '-' )
            # waffle.g:9:7: '-'
            self.match(u'-')





        finally:

            pass

    # $ANTLR end T10



    # $ANTLR start T11
    def mT11(self, ):

        try:
            self.type = T11

            # waffle.g:10:5: ( '*' )
            # waffle.g:10:7: '*'
            self.match(u'*')





        finally:

            pass

    # $ANTLR end T11



    # $ANTLR start T12
    def mT12(self, ):

        try:
            self.type = T12

            # waffle.g:11:5: ( '(' )
            # waffle.g:11:7: '('
            self.match(u'(')





        finally:

            pass

    # $ANTLR end T12



    # $ANTLR start T13
    def mT13(self, ):

        try:
            self.type = T13

            # waffle.g:12:5: ( ')' )
            # waffle.g:12:7: ')'
            self.match(u')')





        finally:

            pass

    # $ANTLR end T13



    # $ANTLR start ID
    def mID(self, ):

        try:
            self.type = ID

            # waffle.g:28:9: ( ( 'a' .. 'z' | 'A' .. 'Z' )+ )
            # waffle.g:28:11: ( 'a' .. 'z' | 'A' .. 'Z' )+
            # waffle.g:28:11: ( 'a' .. 'z' | 'A' .. 'Z' )+
            cnt1 = 0
            while True: #loop1
                alt1 = 2
                LA1_0 = self.input.LA(1)

                if ((u'A' <= LA1_0 <= u'Z') or (u'a' <= LA1_0 <= u'z')) :
                    alt1 = 1


                if alt1 == 1:
                    # waffle.g:
                    if (u'A' <= self.input.LA(1) <= u'Z') or (u'a' <= self.input.LA(1) <= u'z'):
                        self.input.consume();

                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse




                else:
                    if cnt1 >= 1:
                        break #loop1

                    eee = EarlyExitException(1, self.input)
                    raise eee

                cnt1 += 1






        finally:

            pass

    # $ANTLR end ID



    # $ANTLR start INT
    def mINT(self, ):

        try:
            self.type = INT

            # waffle.g:30:9: ( ( '0' .. '9' )+ )
            # waffle.g:30:11: ( '0' .. '9' )+
            # waffle.g:30:11: ( '0' .. '9' )+
            cnt2 = 0
            while True: #loop2
                alt2 = 2
                LA2_0 = self.input.LA(1)

                if ((u'0' <= LA2_0 <= u'9')) :
                    alt2 = 1


                if alt2 == 1:
                    # waffle.g:30:11: '0' .. '9'
                    self.matchRange(u'0', u'9')



                else:
                    if cnt2 >= 1:
                        break #loop2

                    eee = EarlyExitException(2, self.input)
                    raise eee

                cnt2 += 1






        finally:

            pass

    # $ANTLR end INT



    # $ANTLR start NEWLINE
    def mNEWLINE(self, ):

        try:
            self.type = NEWLINE

            # waffle.g:32:9: ( ( '\\r' )? '\\n' )
            # waffle.g:32:11: ( '\\r' )? '\\n'
            # waffle.g:32:11: ( '\\r' )?
            alt3 = 2
            LA3_0 = self.input.LA(1)

            if (LA3_0 == u'\r') :
                alt3 = 1
            if alt3 == 1:
                # waffle.g:32:11: '\\r'
                self.match(u'\r')




            self.match(u'\n')





        finally:

            pass

    # $ANTLR end NEWLINE



    # $ANTLR start WS
    def mWS(self, ):

        try:
            self.type = WS

            # waffle.g:34:9: ( ( ' ' | '\\t' | '\\n' | '\\r' )+ )
            # waffle.g:34:11: ( ' ' | '\\t' | '\\n' | '\\r' )+
            # waffle.g:34:11: ( ' ' | '\\t' | '\\n' | '\\r' )+
            cnt4 = 0
            while True: #loop4
                alt4 = 2
                LA4_0 = self.input.LA(1)

                if ((u'\t' <= LA4_0 <= u'\n') or LA4_0 == u'\r' or LA4_0 == u' ') :
                    alt4 = 1


                if alt4 == 1:
                    # waffle.g:
                    if (u'\t' <= self.input.LA(1) <= u'\n') or self.input.LA(1) == u'\r' or self.input.LA(1) == u' ':
                        self.input.consume();

                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse




                else:
                    if cnt4 >= 1:
                        break #loop4

                    eee = EarlyExitException(4, self.input)
                    raise eee

                cnt4 += 1


            #action start
            self.skip()
            #action end




        finally:

            pass

    # $ANTLR end WS



    def mTokens(self):
        # waffle.g:1:8: ( T8 | T9 | T10 | T11 | T12 | T13 | ID | INT | NEWLINE | WS )
        alt5 = 10
        LA5 = self.input.LA(1)
        if LA5 == u'=':
            alt5 = 1
        elif LA5 == u'+':
            alt5 = 2
        elif LA5 == u'-':
            alt5 = 3
        elif LA5 == u'*':
            alt5 = 4
        elif LA5 == u'(':
            alt5 = 5
        elif LA5 == u')':
            alt5 = 6
        elif LA5 == u'A' or LA5 == u'B' or LA5 == u'C' or LA5 == u'D' or LA5 == u'E' or LA5 == u'F' or LA5 == u'G' or LA5 == u'H' or LA5 == u'I' or LA5 == u'J' or LA5 == u'K' or LA5 == u'L' or LA5 == u'M' or LA5 == u'N' or LA5 == u'O' or LA5 == u'P' or LA5 == u'Q' or LA5 == u'R' or LA5 == u'S' or LA5 == u'T' or LA5 == u'U' or LA5 == u'V' or LA5 == u'W' or LA5 == u'X' or LA5 == u'Y' or LA5 == u'Z' or LA5 == u'a' or LA5 == u'b' or LA5 == u'c' or LA5 == u'd' or LA5 == u'e' or LA5 == u'f' or LA5 == u'g' or LA5 == u'h' or LA5 == u'i' or LA5 == u'j' or LA5 == u'k' or LA5 == u'l' or LA5 == u'm' or LA5 == u'n' or LA5 == u'o' or LA5 == u'p' or LA5 == u'q' or LA5 == u'r' or LA5 == u's' or LA5 == u't' or LA5 == u'u' or LA5 == u'v' or LA5 == u'w' or LA5 == u'x' or LA5 == u'y' or LA5 == u'z':
            alt5 = 7
        elif LA5 == u'0' or LA5 == u'1' or LA5 == u'2' or LA5 == u'3' or LA5 == u'4' or LA5 == u'5' or LA5 == u'6' or LA5 == u'7' or LA5 == u'8' or LA5 == u'9':
            alt5 = 8
        elif LA5 == u'\r':
            LA5_9 = self.input.LA(2)

            if (LA5_9 == u'\n') :
                LA5_10 = self.input.LA(3)

                if ((u'\t' <= LA5_10 <= u'\n') or LA5_10 == u'\r' or LA5_10 == u' ') :
                    alt5 = 10
                else:
                    alt5 = 9
            else:
                alt5 = 10
        elif LA5 == u'\n':
            LA5_10 = self.input.LA(2)

            if ((u'\t' <= LA5_10 <= u'\n') or LA5_10 == u'\r' or LA5_10 == u' ') :
                alt5 = 10
            else:
                alt5 = 9
        elif LA5 == u'\t' or LA5 == u' ':
            alt5 = 10
        else:
            nvae = NoViableAltException("1:1: Tokens : ( T8 | T9 | T10 | T11 | T12 | T13 | ID | INT | NEWLINE | WS );", 5, 0, self.input)

            raise nvae

        if alt5 == 1:
            # waffle.g:1:10: T8
            self.mT8()



        elif alt5 == 2:
            # waffle.g:1:13: T9
            self.mT9()



        elif alt5 == 3:
            # waffle.g:1:16: T10
            self.mT10()



        elif alt5 == 4:
            # waffle.g:1:20: T11
            self.mT11()



        elif alt5 == 5:
            # waffle.g:1:24: T12
            self.mT12()



        elif alt5 == 6:
            # waffle.g:1:28: T13
            self.mT13()



        elif alt5 == 7:
            # waffle.g:1:32: ID
            self.mID()



        elif alt5 == 8:
            # waffle.g:1:35: INT
            self.mINT()



        elif alt5 == 9:
            # waffle.g:1:39: NEWLINE
            self.mNEWLINE()



        elif alt5 == 10:
            # waffle.g:1:47: WS
            self.mWS()








 

