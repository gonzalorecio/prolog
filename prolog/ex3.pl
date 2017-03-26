
pescalar(L1,L2,P):-
    long(L1,K1),
    long(L2,K2),
    LONG1 is K1,
    LONG2 is K2,
    LONG1=LONG2,
    pesc(L1,L2,P):-
	

long([],0).
long([X|L],N):-
    long(L,N1),
    N is N1+1.
    
    
