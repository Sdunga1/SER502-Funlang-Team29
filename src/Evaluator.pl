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
    update_env(Var, Expr, Env, UpdatedEnv).

eval_declaration(t_bool(t_id(Var)), Env, UpdatedEnv) :-
    update_env(Var, 0, Env, UpdatedEnv).

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
    eval_commands(True, Env, Val); !.
eval_command(t_if_else(Cond, _, False), Env, Val) :-
    \+ eval_condition(Cond, Env),
    eval_commands(False, Env, Val); !.

eval_command(t_for(t_id(X), num(Start), num(End), Cmds), EnvIn, EnvOut) :-
    StartIndex is Start,
    EndIndex is End - 1,
    (   between(StartIndex, EndIndex, I),
        update_env(X, num(I), EnvIn, NewEnv),
        eval_commands(Cmds, NewEnv, _),
        fail;
    	EnvOut = EnvIn 
    ).

eval_command(t_func(t_id(FuncName), ArgExpressions), EnvIn, EnvOut) :-
    lookup(FuncName, EnvIn, (Params, Cmds, ClosureEnv)),
    eval_arg_expressions(ArgExpressions, EnvIn, ArgValues),
    assign_params_to_env(Params, ArgValues, ClosureEnv, NewEnv),
    eval_commands(Cmds, NewEnv, EnvOut).

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

eval_expression(t_div(Expr1, Expr2), Env, Val) :-
    eval_expression(Expr1, Env, Val1),
    eval_expression(Expr2, Env, Val2),
    (Val2 =:= 0 -> throw(division_by_zero); Val is Val1 / Val2).

eval_expression(t_id(Var), Env, Value) :-
    lookup(Var, Env, Value).

eval_expression(num(N), _, N).

eval_expression(t_string(Var), Env, Value) :-
    lookup(Var, Env, Value).

eval_expression(t_string(Str), _, Str).

eval_expression(t_index(t_id(L), t_id(I)), Env, Result) :-
    lookup(L, Env, List),
    lookup(I, Env, num(Index)),
    nth0(Index, List, Result).

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

eval_condition(t_not(Cond), Env) :-
    \+ eval_condition(Cond, Env).

eval_list([], _, []).
eval_list([H|T], Env, [HVal|TVal]) :-
    eval_expression(H, Env, HVal),
    eval_list(T, Env, TVal).

eval_arg_expressions([], _, []).
eval_arg_expressions([H|T], Env, [HVal|TVal]) :-
    eval_expression(H, Env, HVal),
    eval_arg_expressions(T, Env, TVal).

assign_params_to_env([], [], Env, Env).
assign_params_to_env([t_id(P)|PT], [V|VT], Env, UpdatedEnv) :-
    update_env(P, V, Env, TempEnv),
    assign_params_to_env(PT, VT, TempEnv, UpdatedEnv).

lookup(Var, [(Var, Val)|_], Val).
lookup(Var, [_|Rest], Val) :-
    lookup(Var, Rest, Val).

update_env(Var, NewVal, [], [(Var, NewVal)]).
update_env(Var, NewVal, [(Var, _)|Rest], [(Var, NewVal)|Rest]).
update_env(Var, NewVal, [(Var2, Val2)|Rest], [(Var2, Val2)|UpdatedRest]) :-
    Var \= Var2,
    update_env(Var, NewVal, Rest, UpdatedRest).
