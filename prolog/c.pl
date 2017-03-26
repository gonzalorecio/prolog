
numNutrients(8).
product(milk,[2,4,6]).
product(meat,[1,8]).
product(apple,[3,1]).
product(beer,[5,7]).
product(fish,[1,3,5,7]).

union([],L,L).
union([X|L1],L2,U):-
    member(X,L2),!,
    union(L1,L2,U).
union([X|L1],L2,[X|U]):-
    union(L1,L2,U).


findProducts(_,Nutrients,Products,Products):-
	numNutrients(N),
	length(Nutrients,N).
findProducts(K,Nutrients,Products,TotalProducts):-
	length(Products,Len), Len < K,
	product(P,NutrsList),
	\+member(P,Products),
	union(Nutrients,NutrsList,TotalNutrients),
	findProducts(K,TotalNutrients,[P|Products],TotalProducts).

shopping(K,L):- 
	findProducts(K,[],[],L).
	
