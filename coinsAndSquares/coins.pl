:- use_module(library(clpfd)).

ejemplo(0,   26, [1,2,5,10] ).  % Solution: [1,0,1,2]
ejemplo(1,  361, [1,2,5,13,17,35,157]).

main:- 
    ejemplo(1,Amount,Coins),
    nl, write('Paying amount '), write(Amount), write(' using the minimal number of coins of values '), write(Coins), nl,nl,
    length(Coins,N), 
    length(Vars,N), % get list of N prolog vars    
    
    define_domines(Vars,Coins,Amount),
    
    expr(Vars,Coins,E),
    write(E), nl,
    
    define_constraint(E,Amount),
    
    expr1(Vars,E1),
    write(E1),
    
    labeling([min(E1)],Vars),
    
    nl, write(Vars), nl,nl, halt.

define_domines([],_,_).
define_domines([X|Vars],[Y|Coins],Amount):-
    Max is Amount // Y,
    X in 0..Max,
    write('Moneda: '), write(Y), nl, write('  Max: '), write(Max), nl,
    define_domines(Vars,Coins,Amount).

define_constraint(E,Amount):- E #= Amount.

expr([X],[Y],(X*Y)).
expr([X|Vars],[Y|Coins],E):-
    expr(Vars,Coins,E1),
    E = (X*Y) + E1.
    
expr1([X],X).
expr1([X|Vars],E):- expr1(Vars,E1), E = X+E1.