:- lib(ic).

queens(N, Sol) :- 
  length(Queens, N),
  Queens :: [1..N],
  viewable_create(queens, Queens),
  alldifferent(Queens),
  diagonals(Queens),
  labeling(Queens),
  Sol = Queens.
  
create_list(0, []).
create_list(N, [_|T]) :- N > 0, NN is N - 1, create_list(NN, T).

diagonals([H|T]) :- diagonals([H|T], T).

diagonals([], _).
diagonals(_, []).
diagonals( [H1|T1], [H2|T2]) :- diagonals_mark(H1, [H2|T2], 1), diagonals(T1, T2).

diagonals_mark(_, [], _).
diagonals_mark(H, [H2|T2], A) :-
  H - H2 #\= A,
  H - H2 #\= -A,
  AA is A + 1,
  diagonals_mark(H, T2, AA).