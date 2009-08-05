:- lib(ic).

ms(N, Sol) :-
  length(Seq, N),
  Seq :: [0..N],
  seq_constraints(Seq),
  labeling(Seq),
  Sol = Seq,
  write_sol(Sol).
  
seq_constraints(Seq) :-
  seq_constraints(Seq, Seq, 0).

seq_constraints([], _, _).
seq_constraints([H|T], Seq, A) :-
  create_sum(Seq, A, Sum),
  H #= sum(Sum),
  AA is A+1,
  seq_constraints(T, Seq, AA).

create_sum([], _, []).
create_sum([H|T], Val, [X|T2]) :-
  X :: [0..1],
  H #= Val => X #= 1,
  H #\= Val => X #= 0,
  create_sum(T, Val, T2).

write_sol([]) :- writeln(' ').  
write_sol([H|T]) :-
  write(H),
  write(' '),
  write_sol(T).