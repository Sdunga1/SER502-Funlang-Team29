S -> program
program -> block

block -> declarations 
       | declarations commands

declarations  -> declaration declarations
               | declaration

declaration  -> const_declaration
              | var_declaration
              | bool_declaration
              | var_assignment
              | bool_assignment
              | list_declaration
              | func_declaration
              | dict_declaration

const_declaration -> "const" identifier "=" number ";"
var_declaration -> "var" identifier ";"
bool_declaration -> "bool" identifier ";"
var_assignment -> "var" identifier "=" expression ";"
bool_assignment -> "bool" identifier "=" boolean ";"
list_declaration -> "var" identifier "=" list ";"
func_declaration -> "func" identifier "(" params ")" "{" commands "}"
dict_declaration -> "var" identifier "=" dict ";"

commands -> command commands
          | command

command -> boolean_assignment
         | assignment
         | if_statement
         | if_else_statement
         | ternary_statement
         | while_loop
         | print_statement
         | for_range_statement
         | for_list_statement
         | func_declaration

boolean_assignment -> identifier "=" boolean ";"
assignment -> identifier "=" expression ";"
if_statement -> "if" "(" statement ")" "{" commands "}"
if_else_statement -> "if" "(" statement ")" "{" commands "}" "else" "{" commands "}"
ternary_statement -> identifier "=" "(" identifier ")" "?" expression ":" expression ";"
while_loop -> "while" "(" boolean ")" "{" commands "}"
print_statement -> "print" "(" statement ")" ";"
for_range_statement -> "for" "var" identifier "in" "range" "(" number "," number ")" "{" commands "}"
for_list_statement -> "for" "var" identifier "in" identifier "{" commands "}"

statement -> expression
           | boolean

boolean -> 'true'
         | 'false'
         | expression '==' expression
         | expression '!=' expression
         | expression '>' expression
         | expression '>=' expression
         | expression '<' expression
         | expression '<=' expression
         | 'not' statement
         | identifier 'and' identifier
         | identifier 'or' identifier

expression -> identifier '+' expression
            | number '+' expression
            | identifier '-' expression
            | number '-' expression
            | identifier '*' expression
            | number '*' expression
            | identifier '/' expression
            | number '/' expression
            | identifier '[' expression ']'
            | identifier
            | number
            | '(' expression ')'

string_literal -> '"' string_chars '"'

string_chars -> character
              | string_chars character

params -> identifier
        | number
        | identifier ',' params
        | number ',' params

list -> '[' numbers_list ']'

numbers_list -> expression
              | expression ',' numbers_list

dict -> '{' dict_pairs '}'

dict_pairs -> dict_pair
            | dict_pair ',' dict_pairs

dict_pair -> quoted_string ':' dict_value

dict_value -> number
            | quoted_string

quoted_string -> '"' inner_quoted_chars '"'

inner_quoted_chars --> quoted_chars, { atomics_to_string(Y, '', X) }.

/*
quoted_chars([X|Xs]) --> [X], { X \= '"'}, quoted_chars(Xs).
quoted_chars([]) --> [].

identifier(X) --> ['"'], string_literal(X), ['"'].
identifier(t_id(Id)) --> [A], { atom(A), atom_chars(A, C), all_alpha(C), atom_concat('', A, Id) }.
all_alpha([]).
all_alpha([H|T]) :- char_type(H, alpha), all_alpha(T).
*/

digit -> [D], { D >= 0, D =< 9 }
number -> num(N), { atom(N) }
