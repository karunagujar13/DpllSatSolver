
write_r([]).
write_r([A|B]) :-
   A>0,
   format('assignment ~w ~w ~n', [A,1]),
   write_r(B).
write_r([A|B]) :-
   C is abs(A),
   format('assignment ~w ~w ~n', [C,0]),
   write_r(B).


sat_with_print(S) :-
   dpll(S,G),
   write_r(G).

sat_with_print(_) :-
   write('UNSATISFIABLE'),nl.


simplifyHelper([], _, []).
simplifyHelper([Left|Right],PLiteral,UpdatedClauses) :-
   filter_pos([Left|Right],[Left|Right],PLiteral,RemovedClauses),
    %write('in simplifyHelper after filter_pos'),nl,write(RemovedClauses),nl,
   filter_neg(RemovedClauses,[],PLiteral,UpdatedClauses),!.

filter_pos([Left|Right],Clauses,PLiteral,RemovedClauses) :-
   %write('in filter_pos 1'),
   member(PLiteral,Left),!,
   subtract(Clauses,[Left],UpdatedClauses),
   filter_pos(Right,UpdatedClauses,PLiteral,RemovedClauses).
filter_pos([Left|Right],Clauses,PLiteral,RemovedClauses) :-
   %write('in filter_pos 2'),
   filter_pos(Right,Clauses,PLiteral,RemovedClauses).
filter_pos([],Clauses,PLiteral,Clauses).


filter_neg([Left|Right],Clauses,PLiteral,UpdatedClauses) :-
   %write('in filter_neg'),
   NLiteral is PLiteral * -1,
   %write('in filter_neg '),write('   '),write(Left),write('   '),write(Right),nl,
   subtract(Left,[NLiteral],RemovedLit),
   append(Clauses,[RemovedLit],UpdatedCl),
   RemovedLit \== [],
   filter_neg(Right,UpdatedCl,PLiteral,UpdatedClauses).
filter_neg([],Clauses,PLiteral,Clauses).% 
%:- write('in filter_neg 2'),write('   '),write(PLiteral), write('   '), write(Clauses).


dpll([[Left|_]|Right], [Left|Out]):-
   %write('in dpll a1'),write('   '),write(Left),write('   '),write(Right),nl,
   simplifyHelper(Right, Left, Midout),
   %write('in dpll a2'),write('   '),write(Midout),nl,
   dpll(Midout, Out).
dpll([[Left|Mid]|Right], [Neg|Out]):-
   %write('in dpll b1'),write('   '),write(Left),write('   '),write(Mid),write('   '),write(Right),nl,
   Mid \== [],
   Neg is -Left,
   simplifyHelper(Right, Neg, Midout),
   %write('in dpll b2'),write('   '),write(Mid),write('   '),write(Midout),nl,
   dpll([Mid|Midout], Out).

dpll([], []).
