:- use_module(library(clpfd)).

srq(Sol) :-
  length(Srq, 50),
  domain(Srq, 0, 1),
  fdbg_assign_name(Srq, srq),
  each_question_answer(Srq),
  
  questions12345(Srq),
  questions678910(Srq),
  
  labeling([], Srq),
  Sol = Srq.

each_question_answer(Srq) :-
  each_question_answer(Srq, 0).
  
each_question_answer(_, 10).
each_question_answer(Srq, A) :-
  A < 10,
  AA is A + 1,
  select_row(5, A, Srq, Row),
  sum(Row, #=, 1),
  !,
  each_question_answer(Srq, AA).

questions12345([A1,B1,C1,D1,E1,
           A2,B2,C2,D2,E2,
           A3,B3,C3,D3,E3,
           A4,B4,C4,D4,E4,
           A5,B5,C5,D5,E5,
           A6,B6,C6,D6,E6,
           A7,B7,C7,D7,E7,
           A8,B8,C8,D8,E8,
           A9,B9,C9,D9,E9,
           A10,B10,C10,D10,E10]) :-
           
           % Q1
           (A1 #= 1) #<=> ((A4 #= 1) #/\ (A1 #= 0) #/\ (A2 #= 0) #/\ (A3 #= 0)),
           (B1 #= 1) #<=> ((A3 #= 1) #/\ (A1 #= 0) #/\ (A2 #= 0)),
           (C1 #= 1) #<=> ((A2 #= 1) #/\ (A1 #= 0)),
           (D1 #= 1) #<=> ((A1 #= 1)),
           (E1 #= 1) #<=> ((A4 #= 0) #/\ (A1 #= 0) #/\ (A2 #= 0) #/\ (A3 #= 0)),
           
           % Q2
           (A2 #= 1) #<=> ((A3 #= A4) #/\ (B3 #= B4) #/\ (C3 #= C4) #/\ (D3 #= D4) #/\ (E3 #= E4)),
           (B2 #= 1) #<=> ((A4 #= A5) #/\ (B4 #= B5) #/\ (C4 #= C5) #/\ (D4 #= D5) #/\ (E4 #= E5)),
           (C2 #= 1) #<=> ((A5 #= A6) #/\ (B5 #= B6) #/\ (C5 #= C6) #/\ (D5 #= D6) #/\ (E5 #= E6)),
           (D2 #= 1) #<=> ((A6 #= A7) #/\ (B6 #= B7) #/\ (C6 #= C7) #/\ (D6 #= D7) #/\ (E6 #= E7)),
           (E2 #= 1) #<=> ((A7 #= A8) #/\ (B7 #= B8) #/\ (C7 #= C8) #/\ (D7 #= D8) #/\ (E7 #= E8)),
           
           % Q3
           (A3 #= 1) #<=> (A4 #= 1),
           (B3 #= 1) #<=> ((A4 #= 0) #/\ (A5 #= 1)),
           (C3 #= 1) #<=> ((A4 #= 0) #/\ (A5 #= 0) #/\ (A6 #= 1)),
           (D3 #= 1) #<=> ((A4 #= 0) #/\ (A5 #= 0) #/\ (A6 #= 0) #/\ (A7 #= 1)),
           (E3 #= 1) #<=> ((A4 #= 0) #/\ (A5 #= 0) #/\ (A6 #= 0) #/\ (A7 #= 0) #/\ (A8 #= 1)),
           
           % Q4
           (A4 #= 1) #<=> (B2 #= 1),
           (B4 #= 1) #<=> ((B2 #= 0) #/\ (B4 #= 1)),
           (C4 #= 1) #<=> ((B2 #= 0) #/\ (B4 #= 0) #/\ (B6 #= 1)),
           (D4 #= 1) #<=> ((B2 #= 0) #/\ (B4 #= 0) #/\ (B6 #= 0) #/\ (B8 #= 1)),
           (E4 #= 1) #<=> ((B2 #= 0) #/\ (B4 #= 0) #/\ (B6 #= 0) #/\ (B8 #= 0) #/\ (B10 #= 1)),
           
           % Q5
           (A5 #= 1) #<=> (C1 #= 1),
           (B5 #= 1) #<=> (C3 #= 1),
           (C5 #= 1) #<=> (C5 #= 1),
           (D5 #= 1) #<=> (C7 #= 1),
           (E5 #= 1) #<=> (C9 #= 1).
           
           % Q6
questions678910([A1,B1,C1,D1,E1,
           A2,B2,C2,D2,E2,
           A3,B3,C3,D3,E3,
           A4,B4,C4,D4,E4,
           A5,B5,C5,D5,E5,
           A6,B6,C6,D6,E6,
           A7,B7,C7,D7,E7,
           A8,B8,C8,D8,E8,
           A9,B9,C9,D9,E9,
           A10,B10,C10,D10,E10]) :-
           
           sum([D1,D2,D3,D4,D5], #=, Before),
           sum([D7,D8,D9,D10], #=, After),
           (A6 #= 1) #<=> ((Before #> 0) #/\ (After #= 0)),
           (B6 #= 1) #<=> ((Before #= 0) #/\ (After #> 0)),
           (C6 #= 1) #<=> ((Before #> 0) #/\ (After #> 0)),
           (D6 #= 1) #<=> ((Before #= 0) #/\ (After #= 0) #/\ (D6 #= 0)),
           (E6 #= 1) #<=> (D6 #= 1),
           
           % Q7
           (A7 #= 1) #<=> ((E5 #= 1) #/\ (E6 #= 0) #/\ (E7 #= 0) #/\ (E8 #= 0) #/\ (E9 #= 0) #/\ (E10 #= 0)),
           (B7 #= 1) #<=> ((E6 #= 1) #/\ (E7 #= 0) #/\ (E8 #= 0) #/\ (E9 #= 0) #/\ (E10 #= 0)),
           (C7 #= 1) #<=> ((E7 #= 1) #/\ (E8 #= 0) #/\ (E9 #= 0) #/\ (E10 #= 0)),
           (D7 #= 1) #<=> ((E8 #= 1) #/\ (E9 #= 0) #/\ (E10 #= 0)),
           (E7 #= 1) #<=> ((E9 #= 1) #/\ (E10 #= 0)),
           
           % Q8
           sum([B1, C1, D1, B2, C2, D2, B3, C3, D3, B4, C4, D4, B5, C5, D5, B6, C6, D6, B7, C7, D7, B8, C8, D8, B9, C9, D9, B10, C10, D10], #=, Consonants),
           (A8 #= 1) #<=> (Consonants #= 7),
           (B8 #= 1) #<=> (Consonants #= 6),
           (C8 #= 1) #<=> (Consonants #= 5),
           (D8 #= 1) #<=> (Consonants #= 4),
           (E8 #= 1) #<=> (Consonants #= 3),
           
           % Q9
           sum([A1, E1, A2, E2, A3, E3, A4, E4, A5, E5, A6, E6, A7, E7, A8, E8, A9, E9, A10, E10], #=, Vowels),
           (A9 #= 1) #<=> (Vowels #= 0),
           (B9 #= 1) #<=> (Vowels #= 1),
           (C9 #= 1) #<=> (Vowels #= 2),
           (D9 #= 1) #<=> (Vowels #= 3),
           (E9 #= 1) #<=> (Vowels #= 4).

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
  
print_srq(Srq) :-
  print_srq(Srq, 0).

print_srq(_, 10).  
print_srq(Srq, A) :-
  A < 10,
  select_row(5, A, Srq, Row), 
  write(A),
  write(Row), 
  write('\n'),
  AA is A + 1,
  !,
  print_srq(Srq, AA).