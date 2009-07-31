declare
fun {Queens N}
   proc {$ Sol}
      {FD.tuple queens N 1#N Sol}
      {FD.distinct Sol}

      {For 1 N 1
       proc {$ I}
	  {For (I+1) N 1
	   proc {$ J}
	      Sol.I - Sol.J \=: I - J
	      Sol.J - Sol.I \=: I - J
	   end}
       end}
      
      {FD.distribute ff Sol}
   end
end

in

{ExploreAll {Queens 8}}
{Browse 'Reached end'}