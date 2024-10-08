% Parser to the program
program(t_program(K)) --> block(K).

block(t_block(D)) --> declarations(D).
block(t_block(D, C)) --> declarations(D), commands(C).

declarations(t_decl(D1, D2)) --> declaration(D1), declarations(D2).
declarations(t_decl(D)) --> declaration(D).

declaration(t_const(X,Y)) --> ['const'], identifier(X), ['='], number(Y), [';'].
declaration(t_var(X)) --> ['var'], identifier(X), [';'].
declaration(t_bool(X)) --> ['bool'], identifier(X), [';'].
declaration(t_var(X, Y)) --> ['var'], identifier(X), ['='], expression(Y), [';'].
declaration(t_bool(X, Y)) --> ['bool'], identifier(X), ['='], boolean(Y), [';'].
declaration(t_list(X, Y)) --> ['var'], identifier(X), ['='], list(Y), [';'].
declaration(t_func(X, Y, Z)) --> ['func'], identifier(X), ['('], params(Y), [')'], ['{'], commands(Z), ['}'].
declaration(t_dict(X, Y)) --> ['var'], identifier(X), ['='], dict(Y), [';'].

commands(t_cmd(C1, C2)) --> command(C1), commands(C2).
commands(t_cmd(C)) --> command(C).

command(t_b_assign(X, Y)) --> identifier(X), ['='], boolean((Y)), [';']. 
command(t_assign(X,Y)) --> identifier(X), ['='], expression(Y), [';'].
command(t_if(X, Y)) --> ['if'],['('], statement(X), [')'], ['{'], commands(Y),['}'].
command(t_if_else(X, Y, Z)) --> ['if'],['('], statement(X), [')'], ['{'], commands(Y),['}'], ['else'],['{'], commands(Z),['}'].
command(t_ternary(X, C, Y, Z)) --> identifier(X), ['='], ['('], identifier(C), [')'], ['?'], expression(Y), [':'], expression(Z), [;].
command(t_while(X,Y)) --> ['while'],['('], boolean(X), [')'], ['{'], commands(Y),['}'].
command(t_print(X)) --> ['print'],['('], statement(X), [')'], [';'].
command(t_for(X, Y, Z, C)) --> ['for'], ['var'], identifier(X), ['in'], ['range'], ['('], number(Y), [','], number(Z), [')'], ['{'], commands(C), ['}'].
command(t_for_list(X,Y, C)) --> ['for'], ['var'], identifier(X), ['in'], identifier(Y), ['{'], commands(C), ['}'].
command(t_func(X, Y)) --> ['func'], identifier(X), ['('], params(Y), [')'], [';'].

statement(X) --> expression(X); boolean(X).

boolean((true)) --> ['true'].
boolean((false)) --> ['false'].
boolean(t_equal(X, Y)) --> expression(X), ['=='], expression(Y).
boolean(t_notEqual(X, Y)) --> expression(X), ['!='], expression(Y).
boolean(t_greaterThan(X, Y)) --> expression(X), ['>'], expression(Y).
boolean(t_greaterThanEqualTo(X, Y)) --> expression(X), ['>='], expression(Y).
boolean(t_lessThan(X,Y)) --> expression(X), ['<'], expression(Y).
boolean(t_lessThanEqualTo(X,Y)) --> expression(X), ['<='], expression(Y).
boolean(t_not(X)) --> ['not'], statement(X).
boolean(t_and(X, Y)) --> identifier(X), ['and'], identifier(Y).
boolean(t_or(X, Y)) --> identifier(X), ['or'], identifier(Y).

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
expression(X) --> ['('], expression(X), [')'].

string_literal(t_string(X)) --> string_chars(L), { atomics_to_string(L, ' ', X) }.
string_chars([X|Xs]) --> [X], { X \= '"' }, string_chars(Xs).
string_chars([]) --> [].

params([X]) --> identifier(X); number(X).
params([X|Xs]) --> identifier(X), [','], params(Xs); number(X), [','], params(Xs).

list((X)) --> ['['], numbers_list(X), [']'].

numbers_list([X]) --> expression(X).
numbers_list([X|Xs]) --> expression(X), [','], numbers_list(Xs).

dict((X)) --> ['{'], dict_pairs(X), ['}'].

dict_pairs([X]) --> dict_pair(X).
dict_pairs([X|Xs]) --> dict_pair(X), [','], dict_pairs(Xs).

dict_pair(t_pair(X, Y)) --> quoted_string(X), [':'], dict_value(Y).

dict_value(X) --> number(X); quoted_string(X).

quoted_string(t_string(X)) --> ['"'], inner_quoted_chars(X), ['"'].

inner_quoted_chars(X) --> quoted_chars(Y), { atomics_to_string(Y, '', X) }.

quoted_chars([X|Xs]) --> [X], { X \= '"'}, quoted_chars(Xs).
quoted_chars([]) --> [].

identifier(X) --> ['"'], string_literal(X), ['"'].
identifier(t_id(Id)) --> [A], { atom(A), atom_chars(A, C), all_alpha(C), atom_concat('', A, Id) }.
all_alpha([]).
all_alpha([H|T]) :- char_type(H, alpha), all_alpha(T).

digit(D) --> [C], { atom(C), atom_number(C, D), D >= 0, D =< 9 }.
number(num(N)) --> [A], { atom(A), atom_number(A, N) }.