:- lib(ic).

qwh(N, Sol) :-
  NN is N*N,
  length(Matrix, NN),
  Matrix :: [1..N],
  q_constraint(N, Matrix),
  labeling(Matrix),
  Sol = Matrix.
  
select_column(N, ColId, Matrix, Col) :- 
  select_column(N, ColId, Matrix, Col, 0).

select_column(_, _, [], [], _).
select_column(N, ColId, [H|T], [H|CT], A) :-
  mod(A,N,ColId),
  AA is A + 1,
  select_column(N, ColId, T, CT, AA).
select_column(N, ColId, [_|T], CT, A) :-
  mod(A,N,Mod),
  Mod \= ColId,
  AA is A + 1,
  select_column(N, ColId, T, CT, AA).
  
  
select_row(N, RowId, Matrix, Row) :-  
  BoundL is RowId*N, 
  BoundH is (RowId+1)*N-1, 
  select_row(N, Matrix, Row, 0, BoundL, BoundH).

select_row(_, [], [], _, _, _).
select_row(_, _, [], A, _, BH) :- BH < A.

select_row(N, [H|T], [H|RT], A, BL, BH) :-
  A >= BL,
  A =< BH,
  AA is A + 1,
  select_row(N, T, RT, AA, BL, BH).
  
select_row(N, [_|T], RT, A, BL, BH) :-
  A < BL,
  AA is A + 1,
  select_row(N, T, RT, AA, BL, BH).
  

q_constraint(N, Matrix) :-
  q_constraint(N, Matrix, 0).
  
q_constraint(N, _, M) :- M >= N.
q_constraint(N, Matrix, A) :- 
  A < N,
  select_row(N, A, Matrix, Row),
  select_column(N, A, Matrix, Col),
  alldifferent(Row),
  alldifferent(Col),
  AA is A + 1,
  q_constraint(N, Matrix, AA).
  