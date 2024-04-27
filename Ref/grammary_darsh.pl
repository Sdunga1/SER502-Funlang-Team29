
program(block) --> block.


block([S | Rest]) --> statement(S), block(Rest).
block([]) --> [].


statement(assignment(S)) --> assignment(S).
statement(unary_operation(U)) --> unary_operation(U).
statement(if_check(I)) --> if_check(I).
statement(for_loop(F)) --> for_loop(F).
statement(for_in_range_loop(F)) --> for_in_range_loop(F).
statement(perform_while(W)) --> perform_while(W).
statement(list_declaration(L)) --> list_declaration(L).
statement(dictionary_declaration(D)) --> dictionary_declaration(D).
statement(function_declaration(F)) --> function_declaration(F).
statement(function_call(F)) --> function_call(F).
statement(try_catch(T)) --> try_catch(T).
statement(print_statement(P)) --> print_statement(P).


assignment(Identifier = Expr) --> 
    [identifier(Identifier)], 
    ['='], 
    expression(Expr), 
    [';'].


unary_operation(IncDec) --> 
    [identifier(Identifier)], 
    inc_dec_op(Operator),
    { IncDec =.. [Operator, Identifier] }.


if_check(if(Cond, TrueBlock, MaybeElseBlock)) --> 
    ['if'], ['('], expression(Cond), [')'], 
    ['{'], block(TrueBlock), ['}'], 
    else_clause(MaybeElseBlock).

else_clause(none) --> [].
else_clause(else(Block)) --> ['else'], ['{'], block(Block), ['}'].


for_loop(for(Init, Cond, Incr, Body)) --> 
    ['for'], ['('], assignment(Init), expression(Cond), [';'], unary_operation(Incr), [')'], 
    ['{'], block(Body), ['}'].


for_in_range_loop(for_in_range(Identifier, Start, End, Body)) --> 
    ['for'], identifier(Identifier), ['in'], ['range'], ['('], 
    expression(Start), [','], expression(End), [')'], 
    ['{'], block(Body), ['}'].


perform_while(while(Cond, Body)) --> 
    ['while'], ['('], expression(Cond), [')'], 
    ['{'], block(Body), ['}'].


list_declaration(Identifier = List) --> 
    [identifier(Identifier)], 
    ['='], list_literal(List), 
    [';'].


dictionary_declaration(Identifier = Dict) --> 
    [identifier(Identifier)], 
    ['='], dictionary_literal(Dict), 
    [';'].


function_declaration(func(Name, Params, Body)) --> 
    ['func'], identifier(Name), 
    ['('], parameters(Params), [')'], 
    ['{'], block(Body), ['}'].


function_call(call(Name, Args)) --> 
    [identifier(Name)], 
    ['('], arguments(Args), [')'], 
    [';'].


try_catch(try(Body, CatchBlock)) --> 
    ['try'], ['{'], block(Body), ['}'], 
    ['catch'], ['('], identifier(CatchIdentifier), [')'], 
    ['{'], block(CatchBlock), ['}'].


print_statement(print(Expr)) --> 
    ['print'], ['('], expression(Expr), [')'], 
    [';'].


expression(Op) --> 
    non_op_expression(Expr1), 
    binary_operation(Op1), 
    non_op_expression(Expr2),
    { Op =.. [Op1, Expr1, Expr2] }.

expression(Expr) --> non_op_expression(Expr).


non_op_expression(unary_expression(UOp, E)) --> unary_operation(UOp), non_op_expression(E).
non_op_expression(literal(Lit)) --> literal(Lit).
non_op_expression(identifier(Id)) --> [identifier(Id)].
non_op_expression(func_call(FC)) --> function_call(FC).
non_op_expression(list_access(Id, Expr)) --> 
    [identifier(Id)], ['['], expression(Expr), [']'].
non_op_expression(dict_access(Id, Key)) --> 
    [identifier(Id)], ['['], literal(Key), [']'].
non_op_expression(parens(Expr)) --> ['('], expression(Expr), [')'].


list_literal(list(Elements)) --> 
    ['['], 
    list_elements(Elements), 
    [']'].

list_elements([E | Rest]) --> expression(E), [','], list_elements(Rest).
list_elements([E]) --> expression(E).
list_elements([]) --> [].

dictionary_literal(dict(Pairs)) --> 
    ['{'], 
    dictionary_pairs(Pairs), 
    ['}'].

dictionary_pairs([K-V | Rest]) --> 
    expression(K), 
    [':'], expression(V), [','], dictionary_pairs(Rest).
dictionary_pairs([K-V]) --> 
    expression(K), [':'], expression(V).
dictionary_pairs([]) --> [].


identifier(Identifier) --> [identifier(Identifier)].

parameters([Param | Rest]) --> identifier(Param), [','], parameters(Rest).
parameters([Param]) --> identifier(Param).
parameters([]) --> [].

arguments([Arg | Rest]) --> expression(Arg), [','], arguments(Rest).
arguments([Arg]) --> expression(Arg).
arguments([]) --> [].


literal(numeric(N)) --> [numeric(N)].
literal(string(S)) --> [string(S)].
literal(boolean(B)) --> [boolean(B)].


binary_operation(Op) --> [binary_operator(Op)].
unary_operation(Op) --> [unary_operator(Op)].
inc_dec_op(Op) --> [inc_dec_op(Op)].


whitespace --> [whitespace(_)].
comment --> [comment(_)].

