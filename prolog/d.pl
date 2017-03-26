
cities([1,2,3,4,5]).
road(1,2, 10).  % road between cities 1 and 2 of 10km
road(1,4, 20).
road(2,3, 25).
road(3,4, 12).
road(1,5, 5).
road(5,3, 2).
road(2,4, 1).

numCities(N):-
	cities(C),
	length(C,N).

allDifferent([]).
allDifferent([E|L]):-
	\+member(E,L),
	allDifferent(L).


findMainRoads(K,Kms, Cities,Cities):-
	Kms =< K,length(Cities,Len), numCities(Len),allDifferent(Cities).

findMainRoads(K,Kms, [C|Cities],TotalCities):-
	length(Cities,Len), numCities(N), Len < N,
	road(C,C2, Kilometers),
	Aux is  Kms+Kilometers,	Aux =< K,
	Cities2 = [C|Cities],allDifferent(Cities2),
	findMainRoads(K,Aux, [C2|Cities2], TotalCities).

findMainRoads(K,Kms, [C|Cities],TotalCities):-
	length(Cities,Len), numCities(N), Len < N,
	road(C2,C, Kilometers),
	Aux is  Kms+Kilometers,	Aux =< K,
	Cities2 = [C|Cities],allDifferent(Cities2),
	findMainRoads(K,Aux, [C2|Cities2], TotalCities).


mainroads(K,M):-
	cities(Cities),
	member(City,Cities),
	findMainRoads(K,0, [City],Path),
	reverse(Path,M).