grammar waffle;

options {
        language=Python;
        output=AST;
        ASTLabelType=CommonTree;
}

tokens {
        BLOCK;
}

prog    : block {print $block.tree.toStringTree();};
        /*catch[Exception as e] { print "ERROR! ", e; sys.exit(1); }*/

block   : stat*                 -> ^(BLOCK["block"] stat*) ;

stat    : assig^                
        | ifelse^
        | NEWLINE               ->
        ;

assig   : ID '=' expr NEWLINE   -> ^('=' ID expr) ;

ifelse  : 'if' '(' expr ')' NEWLINE
          ifblock = block
          ('else'
          elseblock = block)?
          'end' NEWLINE         -> ^('if' expr $ifblock $elseblock?) ;

expr    : multExpr (('+'^|'-'^) multExpr)*
        ;

multExpr
        : atom (('*'^|'/'^) atom)*
        ;

atom    : NUMBER
        | ID
        | '('! expr ')'!
        ;

ID      : LETTER (DIGIT | LETTER)* ;

fragment 
LETTER  : ('a'..'z'|'A'..'Z'|'_') ;

NUMBER  : DIGIT+ ( '.' DIGIT+ )? /* integer or float */ ;

fragment
DIGIT   : '0'..'9' ;

NEWLINE : '\r'? '\n' ;

WS      : (' '|'\t'|'\n'|'\r') {self.skip()} ;
