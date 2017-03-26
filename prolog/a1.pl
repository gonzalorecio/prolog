/*unPaso(C5,C8 , C5f,C8f):-
    llenar(C5):-
	C5<5,
	C5f is 5,
	C8f is C8.
    llenar(C8):-
	C8 < 8,
	C8f is 8,
	C5f is C5.
    vertertodo(C5,C8):-
	C8<=3,
	C8 is C8+C5,
	C5 is 0.
    vertertodo(C8,C5):-
	
    verter(C5,C8):-
	C8>3,
	AUX is 8-C8,
	C8 is 8,
	C5 is C5-AUX.
    verter(C8,C5):-
	AUX is 5-C5,
	C8 is 
    vaciar(C5):-
	C5 is 0.
    vaciar(C8):-
	C8 is 0.*/
	
/* llenar 5 [_,C8][5,C8]
   verter 5 sobre 8 y cabe  unPaso([C5,C8][0,S]):- S is C5+C8, S=<8.
   verter 5 sobre 8 y sobra  unPaso([C5,C8][R,8]):- s is C5+C8, S>8, R is S-8
  


llenar5([C5,C8] , [C5f,C8f]):-
	C5 < 5,
	C5f is 5,
	C8f is C8.
llenar8(C5,C8 , C5f,C8f):-
	C8 < 8,
	C8f is 8,
	C5f is C5.
vertertodo5a8(C5,C8 , C5f,C8f):-
	AUX is (C8 + C5),
	AUX <= 8,
	C8f is C8+C5,
	C5f is 0.
vertertodo8a5(C5,C8 , C5f,C8f):-
	C5 + C8 <= 5,
	C5f is C5+C8,
	C8f is 0.
verter5a8(C5,C8 , C5f,C8f):-
	LIBRE is 8-C8,
	C8f is 8,
	C5f is C5-LIBRE.
verter8a5(C5,C8 , C5f,C8f):-
	LIBRE is 5-C5,
	C5f is 5,
	C8f is C8-LIBRE. 
vaciar5(C5,C8 , C5f,C8f):-
	C5f is 0.
	C8f is C8.
vaciar8(C5,C8 , C5f,C8f):-
	C5f is C5,
	C8f is 0.
	
unPaso([C5,C8] , [C5f,C8f]):-
      llenar5(C5,C8 , C5f,C8f),
      llenar8(C5,C8 , C5f,C8f),
      vertertodo5a8(C5,C8 , C5f,C8f),
      vertertodo8a5(C5,C8 , C5f,C8f),
      verter5a8(C5,C8 , C5f,C8f),
      verter8a5(C5,C8 , C5f,C8f),
      vaciar5(C5,C8 , C5f,C8f),
      vaciar8(C5,C8 , C5f,C8f).*/

      
nat(0).
nat(N):-
    nat(N1),
    N is N1+1.
      
unPaso([_,C8],[5,C8]).		%Llenar C5 
unPaso([C5,_],[C5,8]).		%Llenar C8
unPaso([C5,C8],[0,C8f]):-	%Verter todo C5 a C8
    (C8 + C5) =< 8,
    C8f is C8+C5.
unPaso([C5,C8],[C5f,0]):-	%Verter todo C8 a C5
    (C5 + C8) =< 5,
    C5f is C5+C8.
unPaso([C5,C8],[C5f,C8f]):-	%Verter C5 a C8
    (C5 + C8) > 8,
    LIBRE is 8-C8,
    C8f is 8,
    C5f is C5-LIBRE.
unPaso([C5,C8],[C5f,C8f]):-	%Verter C8 a C5
    (C5 + C8) > 5,
    LIBRE is 5-C5,
    C5f is 5,
    C8f is C8-LIBRE.  
unPaso([_,C8],[0,C8]).		%Vaciar C5
unPaso([C5,_],[C5,0]).		%Vaciar C8


camino( E,E, C,C ).
camino( EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
    unPaso( EstadoActual, EstSiguiente ),
    \+member(EstSiguiente,CaminoHastaAhora),
    camino( EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal ).


solucionOptima:-
    nat(N), 				% Buscamos solucion de "coste" 0; si no, de 1, etc.
    camino([0,0],[0,4], [[0,0]],C), 	%En "hacer aguas": -un estado es [cubo5,cubo8], y
    length(C,N), 			% el coste es la longitud de C.
    reverse(C,C2),			%invertimos el orden para ver mejor el resultado
    write(C2).
