:- use_module(library(clpfd)).

all_queens(N, Out) :-
  bagof(Sol, queens(N, Sol), Out).

queens(N, Sol) :- 
  length(Queens, N),
  domain(Queens, 1, N),
  all_different(Queens),
  diagonals(Queens),
  labeling([], Queens),
  Sol = Queens.
  
diagonals([H|T]) :- diagonals([H|T], T).

diagonals([], _).
diagonals(_, []).
diagonals( [H1|T1], [H2|T2]) :- diagonals_mark(H1, [H2|T2], 1), diagonals(T1, T2).

diagonals_mark(_, [], _).
diagonals_mark(H, [H2|T2], A) :-
  H - H2 #\= A,
  H - H2 #\= -1 * A,
  AA is A + 1,
  diagonals_mark(H, T2, AA).