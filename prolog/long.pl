long([],0).
long([_|L],N):-
    long(L,N1),
    N is N1+1.