declare
fun {MagicSequence Size}
   proc {$ Sol}
      {FD.tuple magic Size 0#(Size-1) Sol}

      {For 1 Size 1
       proc {$ I}
	  V
       in
	  {FD.tuple v Size 0#1 V}
	  {For 1 Size 1
	   proc {$ J}
	      V.J = Sol.J =: I-1
	   end}
	  
	  {FD.reified.card Sol.I V Sol.I 1}
       end}

      {FD.distribute ff Sol}
   end
end

in

{ExploreOne {MagicSequence 20}}
