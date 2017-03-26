concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).

jumpOver([F,C],[Ff,Cf],CONF,CONFf, Movimiento):-
    member([JumpX,JumpY],[[2,0],[-2,-2],[-2,0],[0,2],[0,-2],[2,2]]),
    F+JumpY > 0, F+JumpY=<5, C+JumpX > 0, C+JumpX =< F+JumpY,
    CMid is C+(JumpX//2), FMid is F+(JumpY//2),
    member([FMid,CMid],CONF),
    delete(CONF,[F,C],CONF1),
    delete(CONF1,[FMid,CMid],CONF2),
    concat([[Ff,Cf]],CONF2,CONFf),
    Ff is F+JumpY, Cf is C+JumpX,
    Movimiento = [[F,C],[FMid,CMid]].
    
move(CONF,C,C):- length(CONF,1),!.
move(CONF, CaminoHastaAhora, CaminoTotal):-
    member(B,CONF),
    jumpOver(B,_, CONF,CONFf, Movimiento),
    move(CONFf,[Movimiento|CaminoHastaAhora],CaminoTotal).
 
writePath([]):- write(' ------------------- \n'),!.
writePath([Step|C]):-
  member(B1,Step), member(B2,Step), B1 \== B2,
  write(B1), write(' jumps over '), write(B2), write('\n'), 
  writePath(C).
 
solve(BALLS):-
  move(BALLS,[],Camino),
  reverse(Camino,CaminoOrdenado),
  writePath(CaminoOrdenado).

% solve([[4,1],[4,2],[5,2],[5,3]]).
