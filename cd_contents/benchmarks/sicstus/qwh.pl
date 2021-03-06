:- use_module(library(clpfd)).

qwh(N, Assignment, Sol) :-
  NN is N*N,
  length(Matrix, NN),
  domain(Matrix, 1, N),
  q_constraint(N, Matrix),
  assign_constraint(Matrix, Assignment),
  labeling([], Matrix),
  Sol = Matrix.

write_solution(N, Sol) :-
  NN is N - 1, write_solution(N, NN, Sol, 0).

assign_constraint([], []).
assign_constraint([_|T], [-1|TT]) 
	:- !, assign_constraint(T, TT).

assign_constraint([H|T], [HH|TT]) :- 
	H #= HH,
	!,
	assign_constraint(T, TT).

write_solution(_, _, [], _).
write_solution(N, NN, [H|T], A) :-
  M is A mod N,
  write(H),
  (M = NN, write('\n') ; M \= NN, write(' ')),
  AA is A + 1,
  write_solution(N, NN, T, AA).
  
select_column(N, ColId, Matrix, Col) :- 
  select_column(N, ColId, Matrix, Col, 0).

select_column(_, _, [], [], _).
select_column(N, ColId, [H|T], [H|CT], A) :-
  ColId is A mod N,
  AA is A + 1,
  select_column(N, ColId, T, CT, AA).
select_column(N, ColId, [_|T], CT, A) :-
  Mod is A mod N,
  Mod \= ColId,
  AA is A + 1,
  select_column(N, ColId, T, CT, AA).
  
  
select_row(N, RowId, Matrix, Row) :-  
  BoundL is RowId*N, 
  BoundH is (RowId+1)*N-1, 
  select_row(N, Matrix, Row, 0, BoundL, BoundH).

select_row(_, [], [], _, _, _) :- !.
select_row(_, _, [], A, _, BH) :- BH < A, !.

select_row(N, [H|T], [H|RT], A, BL, BH) :-
  A >= BL,
  A =< BH,
  AA is A + 1,
  !,
  select_row(N, T, RT, AA, BL, BH).
  
select_row(N, [_|T], RT, A, BL, BH) :-
  A < BL,
  AA is A + 1,
  !,
  select_row(N, T, RT, AA, BL, BH).
  

q_constraint(N, Matrix) :-
  q_constraint(N, Matrix, 0).
  
q_constraint(N, _, M) :- M >= N, !.
q_constraint(N, Matrix, A) :- 
  A < N,
  select_row(N, A, Matrix, Row),
  select_column(N, A, Matrix, Col),
  all_different(Row),
  all_different(Col),
  AA is A + 1,
  !,
  q_constraint(N, Matrix, AA).
  