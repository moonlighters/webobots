lexer grammar waffle;
options {
  language=Python;

}

T8 : '=' ;
T9 : '+' ;
T10 : '-' ;
T11 : '*' ;
T12 : '(' ;
T13 : ')' ;

// $ANTLR src "waffle.g" 28
ID      : ('a'..'z'|'A'..'Z')+ ;

// $ANTLR src "waffle.g" 30
INT     : '0'..'9'+ ;

// $ANTLR src "waffle.g" 32
NEWLINE : '\r'? '\n' ;

// $ANTLR src "waffle.g" 34
WS      : (' '|'\t'|'\n'|'\r')+ {self.skip()} ;
