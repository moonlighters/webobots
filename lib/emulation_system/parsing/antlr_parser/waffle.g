grammar waffle;

options {
        language=Python;
        output=AST;
        ASTLabelType=CommonTree;
}

tokens {
        NODE;
}

@parser::header{
import antlr_parser_helper
}
@lexer::header{
import antlr_parser_helper
}
@parser::init {
self.errors_list = [];
}
@lexer::init {
self.errors_list = [];
}
@parser::members{
def emitErrorMessage(self, msg):
    self.errors_list.append(msg)

def getTokenErrorDisplay(self, t):
    return antlr_parser_helper.getTokenErrorDisplay(t)

def getErrorHeader(self, e):
    return antlr_parser_helper.getErrorHeader(e)

def getCharErrorDisplay(self, c):
    return antlr_parser_helper.getCharErrorDisplay(c)

def getErrorMessage(self, e, tokenNames):
    return antlr_parser_helper.getParserErrorMessage(self, e, tokenNames)
}
@lexer::members{
def emitErrorMessage(self, msg):
    self.errors_list.append(msg)

def getTokenErrorDisplay(self, t):
    return antlr_parser_helper.getTokenErrorDisplay(t)

def getErrorHeader(self, e):
    return antlr_parser_helper.getErrorHeader(e)

def getCharErrorDisplay(self, c):
    return antlr_parser_helper.getCharErrorDisplay(c)

def getErrorMessage(self, e, tokenNames):
    return antlr_parser_helper.getLexerErrorMessage(self, e, tokenNames)
}

prog    : block EOF!;

block   : stat*                 -> ^(NODE["block"] stat*) ;

stat    :  assig^
        | ifelse^
        | loop^
        | funcdef^
        | funccall NEWLINE      -> funccall
        | ret^
        | log^
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
          'end'                 -> ^(NODE["funcdef"] $name ^(NODE["params"] $p*) block)
        ;

ret     : 'return'^ expr? NEWLINE! ;

log     : '@log' i+=log_item (',' i+=log_item)* NEWLINE
                                -> ^(NODE["log"] $i*)
        ;

log_item: expr^
        | STRING^
        ;

funccall: ID '(' ( arg+=expr (',' arg+=expr)* )? ')'
                                -> ^(NODE["funccall"] ID ^(NODE["params"] $arg*))
        ;

expr    : andExpr ('or'^  andExpr)* ;

andExpr : notExpr ('and'^ notExpr)* ;

notExpr : cmpExpr^
        | 'not'^ notExpr
        ;

cmpExpr : addExpr (CMP_OP^ addExpr)? ;

addExpr : multExpr (('+'^|'-'^) multExpr)* ;

multExpr
        : atom (('*'^|'/'^) atom)*
        ;

atom    : NUMBER
        | funccall
        | variable^
        | '('! expr ')'!
        | '-' atom              -> ^(NODE["uminus"] atom) /* unary minus */
        | '+' atom              -> ^(NODE["uplus"] atom) /* unary plus */
        ;

variable: ID                    -> ^(NODE["var"] ID)
        ;

STRING  : '"' .* '"'
        ;

NUMBER  : DIGIT+ ( '.' DIGIT+ )? ; /* integer or float */

ID      : LETTER (DIGIT | LETTER)* ;

CMP_OP  : ('>'|'<'|'=='|'!='|'<='|'>=') ;

fragment
DIGIT   : '0'..'9' ;

fragment
LETTER  : ('a'..'z'|'A'..'Z'|'_') ;

COMMENT : '#' (~ NEWLINE)* {self.skip()} ;

NEWLINE :  '\r' | '\n';

WS      : (' '|'\t'|'\n'|'\r') {self.skip()} ;
