program_eval(t_program(Block), EnvIn) :-
    eval_block(Block, EnvIn, _).

eval_block(t_block(Decls, Cmds), EnvIn, EnvOut) :-
    eval_declarations(Decls, EnvIn, EnvMid),
    eval_commands(Cmds, EnvMid, EnvOut).

eval_declarations(t_decl(Decls), EnvIn, EnvOut) :-
    eval_declaration(Decls, EnvIn, EnvOut).

eval_declarations(t_decl(Decls, Rest), EnvIn, EnvOut) :-
    eval_declaration(Decls, EnvIn, EnvMid),
    eval_declarations(Rest, EnvMid, EnvOut).

eval_declaration(t_list(t_id(Var), Items), Env, UpdatedEnv) :-
    eval_list(Items, Env, EvaluatedItems),
    update_env(Var, EvaluatedItems, Env, UpdatedEnv).

eval_declaration(t_var(t_id(Var), Expr), Env, UpdatedEnv) :-
    eval_expression(Expr, Env, Value),
    update_env(Var, Value, Env, UpdatedEnv).

eval_declaration(t_var(t_id(Var)), Env, UpdatedEnv) :-
    update_env(Var, 0, Env, UpdatedEnv).

eval_declaration(t_bool(t_id(Var), Expr), Env, UpdatedEnv) :-
    Expr = 'true',
    update_env(Var, Expr, Env, UpdatedEnv);
    Expr = 'false',
    update_env(Var, Expr, Env, UpdatedEnv);
    eval_expression(Expr, Expr2),
    update_env(Var, Expr2, Env, UpdatedEnv).

eval_declaration(t_bool(t_id(Var)), Env, UpdatedEnv) :-
    update_env(Var, 'false', Env, UpdatedEnv).

eval_declaration(t_func(t_id(Var), Params, Cmds), Env, UpdatedEnv) :-
    update_env(Var, (Params, Cmds, Env), Env, UpdatedEnv).

eval_commands(t_cmd(Command), EnvIn, EnvOut) :-
    eval_command(Command, EnvIn, EnvOut).
eval_commands(t_cmd(Command, Rest), EnvIn, EnvOut) :-
    eval_command(Command, EnvIn, EnvMid),
    eval_commands(Rest, EnvMid, EnvOut).

eval_command(t_assign(t_id(Var), Expr), Env, UpdatedEnv) :-
    eval_expression(Expr, Env, Value),
    update_env(Var, Value, Env, UpdatedEnv).

eval_command(t_b_assign(t_id(Var), Expr), Env, UpdatedEnv) :-
    update_env(Var, Expr, Env, UpdatedEnv).

eval_command(t_print(Expr), Env, Env) :-
    eval_expression(Expr, Env, Value),
    print(Value),
    format("~n").

eval_command(t_if_else(Cond, True, _), Env, Val) :-
    eval_condition(Cond, Env),
    eval_commands(True, Env, Val).
eval_command(t_if_else(Cond, _, False), Env, Val) :-
    \+ eval_condition(Cond, Env),
    eval_commands(False, Env, Val).

eval_command(t_for(t_id(X), num(Start), num(End), Cmds), EnvIn, EnvOut) :-
    StartIndex is Start,
    EndIndex is End - 1,
    (   between(StartIndex, EndIndex, I),
        update_env(X, num(I), EnvIn, NewEnv),
        eval_commands(Cmds, NewEnv, _),
        fail;
    	EnvOut = EnvIn 
    ).

eval_command(t_for_list(t_id(X), t_id(Y), Cmds), EnvIn, EnvOut) :-
    lookup(Y, EnvIn, List), 
    loop_through_list(List, X, Cmds, EnvIn, EnvOut).

eval_command(t_func(t_id(FuncName), ArgExpressions), EnvIn, EnvOut) :-
    lookup(FuncName, EnvIn, (Params, Cmds, ClosureEnv)),
    eval_arg_expressions(ArgExpressions, EnvIn, ArgValues),
    assign_params_to_env(Params, ArgValues, ClosureEnv, NewEnv),
    eval_commands(Cmds, NewEnv, EnvOut).  

eval_command(t_while(Cond, Cmds), EnvIn, EnvOut) :-
    eval_while(Cond, Cmds, EnvIn, EnvOut).

eval_command(t_ternary(t_id(Res), Cond, Expr1, Expr2), EnvIn, EnvOut) :-
    eval_condition(Cond, EnvIn),
    !,
    eval_expression(Expr1, EnvIn, Value1),
    update_env(Res, Value1, EnvIn, EnvOut);
    eval_expression(Expr2, EnvIn, Value2),
    update_env(Res, Value2, EnvIn, EnvOut).

eval_expression(t_add(Expr1, Expr2), Env, Val) :-
    eval_expression(Expr1, Env, Val1),
    eval_expression(Expr2, Env, Val2),
    Val is Val1 + Val2.

eval_expression(t_sub(Expr1, Expr2), Env, Val) :-
    eval_expression(Expr1, Env, Val1),
    eval_expression(Expr2, Env, Val2),
    Val is Val1 - Val2.

eval_expression(t_mul(Expr1, Expr2), Env, Val) :-
    eval_expression(Expr1, Env, Val1),
    eval_expression(Expr2, Env, Val2),
    Val is Val1 * Val2.

eval_expression(t_div(Expr1, Expr2), Env, Val) :-
    eval_expression(Expr1, Env, Val1),
    eval_expression(Expr2, Env, Val2),
    (Val2 =:= 0; Val is Val1 / Val2).

eval_expression(t_id(Var), Env, Value) :-
    lookup(Var, Env, Value).

eval_expression(t_not(t_id(Var)), Env, Value) :-
    lookup(Var, Env, X),
    toggle_boolean(X, Value).

eval_expression(num(N), _, N).

eval_expression(t_string(Var), Env, Value) :-
    lookup(Var, Env, Value).

eval_expression(t_string(Str), _, Str).

eval_expression(t_index(t_id(L), t_id(I)), Env, Result) :-
    lookup(L, Env, List),
    lookup(I, Env, num(Index)),
    nth0(Index, List, Result).

eval_expression(t_and(Expr1, Expr2), Env, Result) :-
    eval_expression(Expr1, Env, Result1),
    eval_expression(Expr2, Env, Result2),
    logical_and(Result1, Result2, Result).

eval_expression(t_or(Expr1, Expr2), Env, Result) :-
    eval_expression(Expr1, Env, Result1),
    eval_expression(Expr2, Env, Result2),
    logical_or(Result1, Result2, Result).

eval_expression(t_not(Expr), Result) :-
    eval_expression(Expr, Env), 
    toggle_boolean(Env, Result). 

eval_expression('true', 'true').
eval_expression('false', 'false').

eval_condition(t_greaterThan(t_id(X), num(Y)), Env) :-
    lookup(X, Env, ValX),
    ValX > Y.

eval_condition(t_greaterThanEqualTo(t_id(X), num(Y)), Env) :-
    lookup(X, Env, ValX),
    ValX >= Y.

eval_condition(t_lessThan(t_id(X), num(Y)), Env) :-
    lookup(X, Env, ValX),
    ValX < Y.

eval_condition(t_lessThanEqualTo(t_id(X), num(Y)), Env) :-
    lookup(X, Env, ValX),
    ValX =< Y.

eval_condition(t_equal(t_id(X), num(Y)), Env) :-
    lookup(X, Env, ValX),
    ValX == Y.
eval_condition(t_notEqual(t_id(X), num(Y)), Env) :-
    lookup(X, Env, ValX),
    ValX \= Y.

eval_condition(t_not(Cond), Env) :-
    \+ eval_condition(Cond, Env).

eval_list([], _, []).
eval_list([H|T], Env, [HVal|TVal]) :-
    eval_expression(H, Env, HVal),
    eval_list(T, Env, TVal).

loop_through_list([], _, _, Env, Env). 
loop_through_list([H|T], X, Cmds, EnvIn, EnvOut) :-
    update_env(X, H, EnvIn, NewEnv), 
    eval_commands(Cmds, NewEnv, TempEnv), 
    loop_through_list(T, X, Cmds, TempEnv, EnvOut).  

eval_while(Cond, Cmds, EnvIn, EnvOut) :-
    eval_condition(Cond, EnvIn), 
    !,
    eval_commands(Cmds, EnvIn, EnvMid),
    eval_while(Cond, Cmds, EnvMid, EnvOut);
    EnvOut = EnvIn.

eval_arg_expressions([], _, []).
eval_arg_expressions([H|T], Env, [HVal|TVal]) :-
    eval_expression(H, Env, HVal),
    eval_arg_expressions(T, Env, TVal).

assign_params_to_env([], [], Env, Env).
assign_params_to_env([t_id(P)|PT], [V|VT], Env, UpdatedEnv) :-
    update_env(P, V, Env, TempEnv),
    assign_params_to_env(PT, VT, TempEnv, UpdatedEnv).

toggle_boolean('true', 'false').
toggle_boolean('false', 'true').

logical_and('true', 'true', 'true').
logical_and('true', 'false', 'false').
logical_and('false', 'true', 'false').
logical_and('false', 'false', 'false'). 

logical_or('true', 'true', 'true').
logical_or('true', 'false', 'true').
logical_or('false', 'true', 'true').
logical_or('false', 'false', 'false'). 

lookup(Var, [(Var, Val)|_], Val).
lookup(Var, [_|Rest], Val) :-
    lookup(Var, Rest, Val).

update_env(Var, NewVal, [], [(Var, NewVal)]).
update_env(Var, NewVal, [(Var, _)|Rest], [(Var, NewVal)|Rest]).
update_env(Var, NewVal, [(Var2, Val2)|Rest], [(Var2, Val2)|UpdatedRest]) :-
    Var \= Var2,
    update_env(Var, NewVal, Rest, UpdatedRest).