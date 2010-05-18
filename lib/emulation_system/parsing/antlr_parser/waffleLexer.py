# $ANTLR 3.1.2 /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g 2010-05-19 02:55:30

import sys
from antlr3 import *
from antlr3.compat import set, frozenset


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


class waffleLexer(Lexer):

    grammarFileName = "/home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g"
    antlr_version = version_str_to_tuple("3.1.2")
    antlr_version_str = "3.1.2"

    def __init__(self, input=None, state=None):
        if state is None:
            state = RecognizerSharedState()
        Lexer.__init__(self, input, state)

        self.dfa6 = self.DFA6(
            self, 6,
            eot = self.DFA6_eot,
            eof = self.DFA6_eof,
            min = self.DFA6_min,
            max = self.DFA6_max,
            accept = self.DFA6_accept,
            special = self.DFA6_special,
            transition = self.DFA6_transition
            )






    # $ANTLR start "T__11"
    def mT__11(self, ):

        try:
            _type = T__11
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:7:7: ( '=' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:7:9: '='
            pass 
            self.match(61)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__11"



    # $ANTLR start "T__12"
    def mT__12(self, ):

        try:
            _type = T__12
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:8:7: ( 'if' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:8:9: 'if'
            pass 
            self.match("if")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__12"



    # $ANTLR start "T__13"
    def mT__13(self, ):

        try:
            _type = T__13
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:9:7: ( '(' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:9:9: '('
            pass 
            self.match(40)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__13"



    # $ANTLR start "T__14"
    def mT__14(self, ):

        try:
            _type = T__14
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:10:7: ( ')' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:10:9: ')'
            pass 
            self.match(41)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__14"



    # $ANTLR start "T__15"
    def mT__15(self, ):

        try:
            _type = T__15
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:11:7: ( 'else' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:11:9: 'else'
            pass 
            self.match("else")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__15"



    # $ANTLR start "T__16"
    def mT__16(self, ):

        try:
            _type = T__16
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:12:7: ( 'end' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:12:9: 'end'
            pass 
            self.match("end")



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__16"



    # $ANTLR start "T__17"
    def mT__17(self, ):

        try:
            _type = T__17
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:13:7: ( '+' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:13:9: '+'
            pass 
            self.match(43)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__17"



    # $ANTLR start "T__18"
    def mT__18(self, ):

        try:
            _type = T__18
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:14:7: ( '-' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:14:9: '-'
            pass 
            self.match(45)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__18"



    # $ANTLR start "T__19"
    def mT__19(self, ):

        try:
            _type = T__19
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:15:7: ( '*' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:15:9: '*'
            pass 
            self.match(42)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__19"



    # $ANTLR start "T__20"
    def mT__20(self, ):

        try:
            _type = T__20
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:16:7: ( '/' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:16:9: '/'
            pass 
            self.match(47)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "T__20"



    # $ANTLR start "ID"
    def mID(self, ):

        try:
            _type = ID
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:48:9: ( LETTER ( DIGIT | LETTER )* )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:48:11: LETTER ( DIGIT | LETTER )*
            pass 
            self.mLETTER()
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:48:18: ( DIGIT | LETTER )*
            while True: #loop1
                alt1 = 2
                LA1_0 = self.input.LA(1)

                if ((48 <= LA1_0 <= 57) or (65 <= LA1_0 <= 90) or LA1_0 == 95 or (97 <= LA1_0 <= 122)) :
                    alt1 = 1


                if alt1 == 1:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:
                    pass 
                    if (48 <= self.input.LA(1) <= 57) or (65 <= self.input.LA(1) <= 90) or self.input.LA(1) == 95 or (97 <= self.input.LA(1) <= 122):
                        self.input.consume()
                    else:
                        mse = MismatchedSetException(None, self.input)
                        self.recover(mse)
                        raise mse



                else:
                    break #loop1





            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "ID"



    # $ANTLR start "LETTER"
    def mLETTER(self, ):

        try:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:51:9: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' ) )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:51:11: ( 'a' .. 'z' | 'A' .. 'Z' | '_' )
            pass 
            if (65 <= self.input.LA(1) <= 90) or self.input.LA(1) == 95 or (97 <= self.input.LA(1) <= 122):
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse





        finally:

            pass

    # $ANTLR end "LETTER"



    # $ANTLR start "NUMBER"
    def mNUMBER(self, ):

        try:
            _type = NUMBER
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:9: ( ( DIGIT )+ ( '.' ( DIGIT )+ )? )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:11: ( DIGIT )+ ( '.' ( DIGIT )+ )?
            pass 
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:11: ( DIGIT )+
            cnt2 = 0
            while True: #loop2
                alt2 = 2
                LA2_0 = self.input.LA(1)

                if ((48 <= LA2_0 <= 57)) :
                    alt2 = 1


                if alt2 == 1:
                    # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:11: DIGIT
                    pass 
                    self.mDIGIT()


                else:
                    if cnt2 >= 1:
                        break #loop2

                    eee = EarlyExitException(2, self.input)
                    raise eee

                cnt2 += 1


            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:18: ( '.' ( DIGIT )+ )?
            alt4 = 2
            LA4_0 = self.input.LA(1)

            if (LA4_0 == 46) :
                alt4 = 1
            if alt4 == 1:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:20: '.' ( DIGIT )+
                pass 
                self.match(46)
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:24: ( DIGIT )+
                cnt3 = 0
                while True: #loop3
                    alt3 = 2
                    LA3_0 = self.input.LA(1)

                    if ((48 <= LA3_0 <= 57)) :
                        alt3 = 1


                    if alt3 == 1:
                        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:53:24: DIGIT
                        pass 
                        self.mDIGIT()


                    else:
                        if cnt3 >= 1:
                            break #loop3

                        eee = EarlyExitException(3, self.input)
                        raise eee

                    cnt3 += 1








            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "NUMBER"



    # $ANTLR start "DIGIT"
    def mDIGIT(self, ):

        try:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:56:9: ( '0' .. '9' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:56:11: '0' .. '9'
            pass 
            self.matchRange(48, 57)




        finally:

            pass

    # $ANTLR end "DIGIT"



    # $ANTLR start "NEWLINE"
    def mNEWLINE(self, ):

        try:
            _type = NEWLINE
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:58:9: ( ( '\\r' )? '\\n' )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:58:11: ( '\\r' )? '\\n'
            pass 
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:58:11: ( '\\r' )?
            alt5 = 2
            LA5_0 = self.input.LA(1)

            if (LA5_0 == 13) :
                alt5 = 1
            if alt5 == 1:
                # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:58:11: '\\r'
                pass 
                self.match(13)



            self.match(10)



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "NEWLINE"



    # $ANTLR start "WS"
    def mWS(self, ):

        try:
            _type = WS
            _channel = DEFAULT_CHANNEL

            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:60:9: ( ( ' ' | '\\t' | '\\n' | '\\r' ) )
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:60:11: ( ' ' | '\\t' | '\\n' | '\\r' )
            pass 
            if (9 <= self.input.LA(1) <= 10) or self.input.LA(1) == 13 or self.input.LA(1) == 32:
                self.input.consume()
            else:
                mse = MismatchedSetException(None, self.input)
                self.recover(mse)
                raise mse

            #action start
            self.skip()
            #action end



            self._state.type = _type
            self._state.channel = _channel

        finally:

            pass

    # $ANTLR end "WS"



    def mTokens(self):
        # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:8: ( T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | ID | NUMBER | NEWLINE | WS )
        alt6 = 14
        alt6 = self.dfa6.predict(self.input)
        if alt6 == 1:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:10: T__11
            pass 
            self.mT__11()


        elif alt6 == 2:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:16: T__12
            pass 
            self.mT__12()


        elif alt6 == 3:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:22: T__13
            pass 
            self.mT__13()


        elif alt6 == 4:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:28: T__14
            pass 
            self.mT__14()


        elif alt6 == 5:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:34: T__15
            pass 
            self.mT__15()


        elif alt6 == 6:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:40: T__16
            pass 
            self.mT__16()


        elif alt6 == 7:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:46: T__17
            pass 
            self.mT__17()


        elif alt6 == 8:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:52: T__18
            pass 
            self.mT__18()


        elif alt6 == 9:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:58: T__19
            pass 
            self.mT__19()


        elif alt6 == 10:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:64: T__20
            pass 
            self.mT__20()


        elif alt6 == 11:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:70: ID
            pass 
            self.mID()


        elif alt6 == 12:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:73: NUMBER
            pass 
            self.mNUMBER()


        elif alt6 == 13:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:80: NEWLINE
            pass 
            self.mNEWLINE()


        elif alt6 == 14:
            # /home/nia/coding/ruby/rails/webobots_application/lib/emulation_system/parsing/antlr_parser/waffle.g:1:88: WS
            pass 
            self.mWS()







    # lookup tables for DFA #6

    DFA6_eot = DFA.unpack(
        u"\2\uffff\1\12\2\uffff\1\12\6\uffff\1\16\2\uffff\1\23\2\12\2\uffff"
        u"\1\12\1\27\1\30\2\uffff"
        )

    DFA6_eof = DFA.unpack(
        u"\31\uffff"
        )

    DFA6_min = DFA.unpack(
        u"\1\11\1\uffff\1\146\2\uffff\1\154\6\uffff\1\12\2\uffff\1\60\1\163"
        u"\1\144\2\uffff\1\145\2\60\2\uffff"
        )

    DFA6_max = DFA.unpack(
        u"\1\172\1\uffff\1\146\2\uffff\1\156\6\uffff\1\12\2\uffff\1\172\1"
        u"\163\1\144\2\uffff\1\145\2\172\2\uffff"
        )

    DFA6_accept = DFA.unpack(
        u"\1\uffff\1\1\1\uffff\1\3\1\4\1\uffff\1\7\1\10\1\11\1\12\1\13\1"
        u"\14\1\uffff\1\15\1\16\3\uffff\1\15\1\2\3\uffff\1\6\1\5"
        )

    DFA6_special = DFA.unpack(
        u"\31\uffff"
        )

            
    DFA6_transition = [
        DFA.unpack(u"\1\16\1\15\2\uffff\1\14\22\uffff\1\16\7\uffff\1\3\1"
        u"\4\1\10\1\6\1\uffff\1\7\1\uffff\1\11\12\13\3\uffff\1\1\3\uffff"
        u"\32\12\4\uffff\1\12\1\uffff\4\12\1\5\3\12\1\2\21\12"),
        DFA.unpack(u""),
        DFA.unpack(u"\1\17"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\20\1\uffff\1\21"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\22"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\12\12\7\uffff\32\12\4\uffff\1\12\1\uffff\32\12"),
        DFA.unpack(u"\1\24"),
        DFA.unpack(u"\1\25"),
        DFA.unpack(u""),
        DFA.unpack(u""),
        DFA.unpack(u"\1\26"),
        DFA.unpack(u"\12\12\7\uffff\32\12\4\uffff\1\12\1\uffff\32\12"),
        DFA.unpack(u"\12\12\7\uffff\32\12\4\uffff\1\12\1\uffff\32\12"),
        DFA.unpack(u""),
        DFA.unpack(u"")
    ]

    # class definition for DFA #6

    DFA6 = DFA
 



def main(argv, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr):
    from antlr3.main import LexerMain
    main = LexerMain(waffleLexer)
    main.stdin = stdin
    main.stdout = stdout
    main.stderr = stderr
    main.execute(argv)


if __name__ == '__main__':
    main(sys.argv)
