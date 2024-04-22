
program(t_program(K)) --> block(K).

block(t_block(Decl, Cmd)) --> declaration(Decl), [';'], commands(Cmd).

declarations(t_decl(Decl1, Decl2)) --> declaration(Decl1), [';'], declaration(Decl2).
declarations(Decl) --> declaration(Decl).

declaration(t_const(X,Y)) --> ['const'], identifier(X), ['='], number(Y).
declaration(t_var(X)) --> ['var'], identifier(X).
declaration(t_var(X, Y)) --> ['var'], identifier(X), ['='], number(Y).
declaration(t_var(X, Y)) --> ['var'], identifier(X), ['='], expression(Y).
declaration(t_var(X, Y)) --> ['var'], identifier(X), ['='], list(Y).

list(t_list(X)) --> ['['], numbers_list(X), [']'].

numbers_list([X]) --> number(X).
numbers_list([X|Xs]) --> number(X), [','], numbers_list(Xs).

commands(t_cmd(Cmd1, Cmd2)) --> command(Cmd1), [';'], commands(Cmd2).
commands(Cmd) --> command(Cmd).

command(t_assign(X,Y)) --> identifier(X), ['='], expression(Y).
command(t_if(X, Y)) --> ['if'],['('], boolean(X), [')'], ['{'], commands(Y),['}'].
command(t_if_else(X, Y, Z)) --> ['if'],['('], boolean(X), [')'], ['{'], commands(Y),['}'], ['else'],['{'], commands(Z),['}'].
command(t_while(X,Y)) --> ['while'],['('], boolean(X), [')'], ['{'], commands(Y),['}'].
command(t_print(X)) --> ['print'],['('], statement(X), [')'], [';'].
command(t_for(Var, X, Y, Cmd)) --> ['for'], declaration(Var), ['in', 'range', '('], number(X), [','], number(Y), [')'], ['{'], commands(Cmd), ['}'].

command(Cmd) --> block(Cmd).

statement(X) --> expression(X); boolean(X).

boolean(b(boolValue(true))) --> ['true'].
boolean(b(boolValue(false))) --> ['false'].
boolean(t_equal(X, Y)) --> expression(X), ['='], expression(Y).
boolean(t_greaterThan(X, Y)) --> expression(X), ['>='], expression(Y).
boolean(t_lessThan(X,Y)) --> expression(X), ['<='], expression(Y).
boolean(t_not(X)) --> ['not'], boolean(X).

expression(t_add(X,Y)) --> identifier(X),['+'],expression(Y).
expression(t_add(X,Y)) --> number(X),['+'],expression(Y).
expression(t_sub(X,Y)) --> identifier(X),['-'],expression(Y).
expression(t_sub(X,Y)) --> number(X),['-'],expression(Y).
expression(t_mul(X,Y)) --> identifier(X),['*'],expression(Y).
expression(t_mul(X,Y)) --> number(X),['*'],expression(Y).
expression(t_div(X,Y)) --> identifier(X),['/'],expression(Y).
expression(t_div(X,Y)) --> number(X),['/'],expression(Y).
expression(t_index(L, I)) --> identifier(L), ['['], expression(I), [']'].
expression(X) --> identifier(X).
expression(X) --> number(X).
expression((X)) --> ['"'], string_literal(X), ['"'].

string_literal(X) --> string_chars(List), { atomics_to_string(List, ' ', X) }.
string_chars([X|Xs]) --> [X], { X \= '"' }, string_chars(Xs).
string_chars([]) --> [].

identifier(t_id(Id)) --> [A], { atom(A), atom_chars(A, Chars), all_alpha(Chars), atom_concat('', A, Id) }.
all_alpha([]).
all_alpha([H|T]) :- char_type(H, alpha), all_alpha(T).

digit(D) --> [C], { atom(C), atom_number(C, D), D >= 0, D =< 9 }.
number(num(N)) --> [A], { atom(A), atom_number(A, N) }.

