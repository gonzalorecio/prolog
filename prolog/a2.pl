%Para un tablero de ajedrez NxN, en P pasos.

%todos los tipos de salto que puede hacer el caballo
unPaso([F,C],[Ff,Cf],N):-
    A1 is F+1,
    A2 is C+2,
    A1 < N,
    A2 < N,
    Ff is F+1,
    Cf is C+2.
unPaso([F,C],[Ff,Cf],N):-
    (F-1) >= 0,
    (C+2) < N,
    Ff is F-1,
    Cf is C+2.
unPaso([F,C],[Ff,Cf],N):-
    (F+1) < N,
    (C-2) >= 0,
    Ff is F+1,
    Cf is C-2.
unPaso([F,C],[Ff,Cf],_):-
    (F-1) >= 0,
    (C-2) >= 0,
    Ff is F-1,
    Cf is C-2.
unPaso([F,C],[Ff,Cf],N):-
    (F+2) < N,
    (C+1) < N,
    Ff is F+2,
    Cf is C+1.
unPaso([F,C],[Ff,Cf],N):-
    (F+2) < N,
    (C-1) >= 0,
    Ff is F+2,
    Cf is C-1.
unPaso([F,C],[Ff,Cf],N):-
    (F-2) >= 0,
    (C+1) < N,
    Ff is F-2,
    Cf is C+1.
unPaso([F,C],[Ff,Cf],_):-
    (F-2) >= 0,
    (C-1) >= 0,
    Ff is F-2,
    Cf is C-1.
    

camino( E,E, C,C ,_,_).
camino( EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ,P,N):-
    length(CaminoHastaAhora,Size), Size<P,
    unPaso( EstadoActual, EstSiguiente ,N),
    \+member(EstSiguiente,CaminoHastaAhora),
    camino( EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal, P,N).
    

solucionOptimaCaballo(PosI,PosF, N,P):-  	% PosI: posicion inicial[fila,col] PosF: posicion final N:tamaño tablero, P: pasos
    PASOS is P+1,
    camino(PosI,PosF,[PosI],C, PASOS,N), 	% En "hacer aguas": -un estado es [cubo5,cubo8], y
						% -el coste es la longitud de C.
    length(C,PASOS),
    reverse(C,C2),
    write(C2).
