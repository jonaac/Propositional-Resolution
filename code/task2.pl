:- style_check(-singleton).
/** Check if an element X exists in a list L */
member(X, []) :- fail.
member(X, [X | L]).
member(X, [Y | L]) :- member(X,L).
/** delete P from clause C */
delete_from_clause([X | L],X,L).
delete_from_clause([A|L],P,[A|D]) :- delete_from_clause(L,P,D).
/** concatentate two lists L1 and L2 into L */
merge([], L, L).
merge(L,[],L).
merge([A|L1], L2, [A|L]) :- merge(L1,L2,L),!.
/** Resolver: */
resolve(C1,C2,P,Res) :- member(P, C1),
						(Q is P*(-1)),
						member(Q, C2),
						delete_from_clause(C1,P,D1),
						delete_from_clause(C2,Q,D2),
						subtract(D1,D2,D),
						merge(D,D2,Res),!.
						
resolve(C1,C2,P,Res) :- member(P, C2),
						(Q is P*(-1)),
						member(Q, C1),
						delete_from_clause(C1,Q,D1),
						delete_from_clause(C2,P,D2),
						subtract(D1,D2,D),
						merge(D,D2,Res),!.