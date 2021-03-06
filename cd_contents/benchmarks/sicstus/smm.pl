:-lib(ic).
:-lib(viewable).
sendmore(Digits) :-
Digits = [S,E,N,D,M,O,R,Y],
Digits :: [0..9],
viewable_create(equation,
[]([](0, S, E, N, D),
[](0, M, O, R, E),
[](M, O, N, E, Y)),
array([flexible,fixed], numeric_bounds),
[["send", "more", "money"],
["ten thousands", "thousands",
"hundreds", "tens", "units"]]),
Carries = [C1,C2,C3,C4],
Carries :: [0..1],
alldifferent(Digits),
S #\= 0,
M #\= 0,
C1 #= M,
C2 + S + M #= O + 10*C1,
C3 + E + O #= N + 10*C2,
C4 + N + R #= E + 10*C3,
D + E #= Y + 10*C4,
labeling(Carries),
labeling(Digits),
viewable_expand(equation, 1, [C1, C2, C3, C4, 0], "carries").