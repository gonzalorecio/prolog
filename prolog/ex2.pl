prod([K],K).
prod([X|L],P):-
  prod(L,P1),
  P is X*P1.