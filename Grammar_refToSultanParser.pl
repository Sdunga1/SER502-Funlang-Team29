program -> block.

block -> declaration ';' commands.
block -> declaration ';' declaration ';' commands.
block -> declaration.

declarations -> declaration ';' declaration.
declarations -> declaration.

declaration -> 'const' identifier '=' number.
declaration -> 'var' identifier.
declaration -> 'var' identifier '=' number.
declaration -> 'var' identifier '=' expression.
declaration -> 'var' identifier '=' list.
declaration -> function_declaration.

list -> '[' numbers_list ']'.

numbers_list -> number ',' numbers_list.
numbers_list -> number.

commands -> command ';' commands.
commands -> command.

command -> identifier '=' expression.
command -> 'if' '(' boolean ')' '{' commands '}'.
command -> 'if' '(' boolean ')' '{' commands '}' 'else' '{' commands '}'.
command -> 'while' '(' boolean ')' '{' commands '}'.
command -> 'print' '(' statement ')' ';'.
command -> 'for' declaration 'in' 'range' '(' number ',' number ')' '{' commands '}'.
command -> function_call.

command -> block.

statement -> expression.
statement -> boolean.

boolean -> 'true'.
boolean -> 'false'.
boolean -> expression '==' expression.
boolean -> expression '=' expression.
boolean -> expression '>' expression.
boolean -> expression '>=' expression.
boolean -> expression '<' expression.
boolean -> expression '<=' expression.
boolean -> 'not' boolean.

expression -> identifier '+' expression.
expression -> number '+' expression.
expression -> identifier '-' expression.
expression -> number '-' expression.
expression -> identifier '*' expression.
expression -> number '*' expression.
expression -> identifier '/' expression.
expression -> number '/' expression.
expression -> identifier '[' expression ']'.
expression -> identifier.
expression -> number.
expression -> function_call.
expression -> '(' string_literal ')'.


string_literal -> string_chars.

string_chars -> character string_chars.
string_chars -> empty.

identifier -> alpha.
identifier -> alpha alpha.
identifier -> alpha digit.
identifier -> identifier alpha.
identifier -> identifier digit.

number -> digit.
number -> digit number.

% Grammar for function call
function_declaration -> 'func' identifier '(' parameters ')' '{' commands '}'.
function_call -> identifier '(' arguments ')' ';'.

parameters -> identifier ',' parameters.
parameters -> identifier.

arguments -> expression ',' arguments.
arguments -> expression.
