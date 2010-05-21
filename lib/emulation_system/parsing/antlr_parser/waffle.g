grammar waffle;

options {
        language=Python;
        output=AST;
        ASTLabelType=CommonTree;
}

tokens {
        NODE;
}

@members{
def emitErrorMessage(self, msg):
    self.errors_list.append(msg)
}

prog    @init { self.errors_list = []; }
        : block;
        
block   : stat*                 -> ^(NODE["block"] stat*) ;

stat    :  assig^                
        | ifelse^
        | loop^
        | funcdef^
        | funccall NEWLINE      -> funccall
        | NEWLINE               ->
        ;

assig   : ID '=' expr NEWLINE   -> ^('=' ID expr) ;

ifelse  : 'if' expr NEWLINE
          ifblock = block
          ('else'
          elseblock = block)?
          'end' NEWLINE         -> ^('if' expr $ifblock $elseblock?)
        ;

loop    : 'while' expr NEWLINE
          block
          'end' NEWLINE         -> ^('while' expr block)
        ;

funcdef : 'def' name=ID
          '(' ( p+=ID (',' p+=ID)* )? ')' NEWLINE
          block
          'end'                 -> ^(NODE["funcdef'"] $name ^(NODE["params"] $p*) block)
        ;

funccall: ID '(' ( arg+=expr (',' arg+=expr)* )? ')'
                                -> ^(NODE["funccall"] ID ^(NODE["params"] $arg*))
        ;

expr    : multExpr (('+'^|'-'^) multExpr)*
        ;

multExpr
        : atom (('*'^|'/'^) atom)*
        ;

atom    : NUMBER
        | (ID '(') => funccall
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
