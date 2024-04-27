S -> program
program -> block

block -> declarations
block -> declarations commands

declarations -> declaration declarations
declarations -> declaration

declaration -> const_declaration
declaration -> var_declaration
declaration -> bool_declaration
declaration -> var_assignment
declaration -> bool_assignment
declaration -> list_declaration
declaration -> func_declaration
declaration -> dict_declaration

const_declaration -> "const" identifier "=" number ";"
var_declaration -> "var" identifier ";"
bool_declaration -> "bool" identifier ";"
var_assignment -> "var" identifier "=" expression ";"
bool_assignment -> "bool" identifier "=" boolean ";"
list_declaration -> "var" identifier "=" list ";"
func_declaration -> "func" identifier "(" params ")" "{" commands "}"
dict_declaration -> "var" identifier "=" dict ";"

commands -> command commands
commands -> command

command -> boolean_assignment
command -> assignment
command -> if_statement
command -> if_else_statement
command -> ternary_statement
command -> while_loop
command -> print_statement
command -> for_range_statement
command -> for_list_statement
command -> func_declaration

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
statement -> boolean

boolean -> "true"
boolean -> "false"
boolean -> expression "==" expression
boolean -> expression "!=" expression
boolean -> expression ">" expression
boolean -> expression ">=" expression
boolean -> expression "<" expression
boolean -> expression "<=" expression
boolean -> "not" statement
boolean -> identifier "and" identifier
boolean -> identifier "or" identifier

expression -> identifier "+" expression
expression -> number "+" expression
expression -> identifier "-" expression
expression -> number "-" expression
expression -> identifier "*" expression
expression -> number "*" expression
expression -> identifier "/" expression
expression -> number "/" expression
expression -> identifier "[" expression "]"
expression -> identifier
expression -> number
expression -> "(" expression ")"

list -> "[" numbers_list "]"

numbers_list -> expression
numbers_list -> expression "," numbers_list

dict -> "{" dict_pairs "}"

dict_pairs -> dict_pair
dict_pairs -> dict_pair "," dict_pairs

dict_pair -> quoted_string ":" dict_value

dict_value -> number
dict_value -> quoted_string

quoted_string -> '"' inner_quoted_chars '"'

inner_quoted_chars -> quoted_chars

identifier -> '"' string_literal '"'
identifier -> id

id -> atom

params -> identifier
params -> number
params -> identifier "," params
params -> number "," params
