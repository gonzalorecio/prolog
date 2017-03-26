ult([],[]).
ult([X|L1],K):-
    write(X),
    long(L1,LONG),
    LONG = 0,
    K is X.
ult([_|L1],K):-
    ult(L1,K).

ult2([],[]).
ult2([X|L1],K):-
    concat([],L1,[]),
    K is X.
ult2([_|L1],K):-
    ult2(L1,K).


inv([],[]).
inv([X|L1],L2):-
    inv(L1,L3),
    concat(L3,[X],L2).
    