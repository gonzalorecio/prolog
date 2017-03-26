intersec([],L,[]):-!.
intersec([X|L1],L2,I):-
    member(X,L2),
    intersec(L1,L2,I1),
    concat([X],I1,I).
intersec([X|L1],L2,I):-
    intersec(L1,L2,I).
    
    
unio([],L,L).
unio([X|L1],L2,U):-
    member(X,L2),!,
    unio(L1,L2,U).
unio([X|L1],L2,[X|U]):-
    unio(L1,L2,U).
    