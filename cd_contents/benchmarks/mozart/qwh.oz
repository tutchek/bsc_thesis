declare
fun {QWH Size Data}
   NN = Size*Size
in
   proc {$ Sol}
      {FD.tuple quasigroup NN 1#Size Sol}

      %% Symetrie
      Sol.1 <: Sol.Size
      Sol.1 <: Sol.(Size * (Size - 1))
      
      {For 1 Size 1
       proc {$ I}
	  V
       in
	  {FD.tuple v Size 1#Size V}
	  {For 1 Size 1
	   proc {$ J}
	      V.J = Sol.((I - 1)*Size + J)
	   end}
	  {FD.distinct V}
       end}

      {For 1 Size 1
       proc {$ I}
	  V
       in
	  {FD.tuple v Size 1#Size V}
	  {For 1 Size 1
	   proc {$ J}
	      V.J = Sol.((J - 1)*Size + I)
	   end}
	  {FD.distinct V}
       end}
      
      
      {FD.distribute ff Sol}
   end
end

proc {WriteQWH Size Sol}
   {Show ''}
   {Show ''}
   {For 1 Size 1
    proc {$ I}
       {For 1 Size 1
	proc {$ J}
	   {Print Sol.((I-1)*Size + J)}
	end}
       {Show ''}
    end}
end

S = 5
in

{ForAll {SearchAll {QWH S nil}}
 proc {$ I}
    {WriteQWH S I}
 end}
{Browse 'Program Terminated'}