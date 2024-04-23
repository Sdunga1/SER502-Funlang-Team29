grammar Funlang;

program : block ;

block : (statement | printStatement)* ;

statement : assignment
          | unaryOperation
          | ifCheck
          | ternaryOperation
          | forLoop
          | forInRangeLoop
          | performWhile
          | listDeclaration
          | dictionaryDeclaration
          | functionDeclaration
          | functionCall
          | tryCatchBlock
          | printStatement
          ;

assignment : identifier = expression ;
unaryOperation : identifier inc_dec_op ;
ifCheck : 'if' '(' expression ')' '{' block '}' ('else' '{' block '}')? ;
% Added missing ternary Operator grammar
ternaryOperation : 'if' '(' expression ')' '?' expression ':' expression ';' ;
forLoop : 'for' '(' assignment expression ';' unaryOperation ')' '{' block '}' ;
forInRangeLoop : 'for' identifier 'in' 'range' '(' expression ',' expression ')' '{' block '}' ;
performWhile : 'while' '(' expression ')' '{' block '}' ;
listDeclaration : identifier '=' listLiteral ';' ;
dictionaryDeclaration : identifier '=' dictionaryLiteral ';' ;
functionDeclaration : 'func' identifier '(' parameters? ')' '{' block '}' ;
functionCall : identifier '(' arguments? ')' ';' ;
tryCatchBlock : 'try' '{' block '}' 'catch' '(' identifier ')' '{' block '}' ;
printStatement : 'print' '(' expression ')' ';' ;

declarative_statement : 'var' IDENT ('=' expression)? ';';


expression : nonOpExpression (binaryOperator nonOpExpression)* ;

nonOpExpression : unaryExpression
                | literal
                | identifier
                | functionCall
                | listAccess
                | dictionaryAccess
                | '(' expression ')'
                ;

unaryExpression : unaryOperator nonOpExpression ;
listAccess : IDENTIFIER '[' expression ']' ;
dictionaryAccess : IDENTIFIER '[' literal ']' ;

listLiteral : '[' (expression (',' expression)*)? ']' ;
dictionaryLiteral : '{' (expression ':' expression (',' expression ':' expression)*)? '}' ;

literal : NUMERIC_LITERAL | STRING_LITERAL | BOOLEAN_LITERAL | listLiteral | dictionaryLiteral ;

binaryOperator : '+' | '-' | '*' | '/' | 'and' | 'or' ;

unaryOperator : 'not' ;

parameters : IDENTIFIER (',' IDENTIFIER)* ;

arguments : expression (',' expression)* ;

IDENTIFIER : [a-zA-Z][a-zA-Z0-9_]* ;
NUMERIC_LITERAL : '-'? [0-9]+ ('.' [0-9]+)? ;
STRING_LITERAL : '"' (~["\\] | '\\' .)* '"' ;
BOOLEAN_LITERAL : 'true' | 'false' ;
WS : [ \t\r\n]+ -> skip ;
COMMENT : '/*' .*? '*/' -> skip ;
LINE_COMMENT : '//' ~[\r\n]* -> skip ;

