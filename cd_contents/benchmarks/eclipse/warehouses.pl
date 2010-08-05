:- lib(ic).

warehouses_capacity([1,4,2,1,3]).
warehouses_opencost(50).
warehouses_supplycost([ 
			[36, 42, 22, 44, 52],
		  	[ 49, 47, 134, 135, 121 ],
		  	[ 121, 158, 117, 156, 115 ],
		  	[ 8, 91, 120, 113, 101 ],
		  	[ 77, 156, 98, 135, 11 ],
		  	[ 71, 39, 50, 110, 98 ],
		  	[ 6, 12, 120, 98, 93 ],
		  	[ 20, 120, 25, 72, 156 ],
		  	[ 151, 60, 104, 139, 77 ],
		  	[ 79, 107, 91, 117, 154]
		]).

warehouses(OC, SC, WC, Sol, TotalCost) :-
  length(WC, WLength),
  length(SC, SLength),
  length(Supplier, SLength),
  length(Cost, SLength),
  length(Open, WLength),
  TotalCost :: [0..inf],
  Supplier :: [0..WLength-1],
  NumberOpen :: [0..WLength],
  Cost :: [0..inf],
  CostSum :: [0..inf],
  NumberOpen :: [0..WLength],
  Open :: [0..1],
  TotalCost #= CostSum + NumberOpen * OC,
  CostSum #= sum(Cost),
  NumberOpen #= sum(Open),
  set_supplier(Supplier, Cost, SC),
  set_open(Open, Supplier, WC),
  branch_and_bound:minimize(labeling(Supplier), TotalCost),
  Sol = Supplier.

set_open(Open, Supplier, WC) :-
  set_open(Open, Supplier, WC, 0).
  
set_open([], _, _, _).
set_open([H|T], Supplier, [HWC|TWC], A) :-
  create_open(Supplier, Aux, A),
  (sum(Aux) #> 0) => (H #= 1),
  (sum(Aux) #= 0) => (H #= 0),
  HWC #>= sum(Aux),
  AA is A+1,
  set_open(T, Supplier, TWC, AA).

create_open([], [], _).
create_open([H|T], [HA|TA], A) :-
  HA :: [0..1],
  (H #= A) => (HA #= 1), 
  (HA #= 1) => (H #= A),
  AA is A+1,
  create_open(T, TA, A).

set_supplier([], _, _).
set_supplier([HS|TS], [HC|TC], [HSC|TSC]) :-
   set_supplier2(HS, HSC, HC, 0),
   set_supplier(TS, TC, TSC).
   
set_supplier2(_, [], _, _).
set_supplier2(S, [H|T], C, A) :-
  (S #= A) => (C #= H),
  AA is A + 1,
  set_supplier2(S, T, C, AA).