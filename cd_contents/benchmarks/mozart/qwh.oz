functor
import
	FD
	Space
	Search
	System
	Application
	Property
	Open
define
	fun {QWH Size Data}
	   NN = Size*Size
	in
	   proc {$ Sol}
	      {FD.tuple quasigroup NN 0#(Size-1) Sol}
	
	      %% Symetrie
	      Sol.1 <: Sol.Size
	      Sol.1 <: Sol.(Size * (Size - 1))
	      
	      {For 1 Size 1
	       proc {$ I}
		  V
	       in
		  {FD.tuple v Size 0#(Size-1) V}
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
		  {FD.tuple v Size 0#(Size-1) V}
		  {For 1 Size 1
		   proc {$ J}
		      V.J = Sol.((J - 1)*Size + I)
		   end}
		  {FD.distinct V}
	       end}
	
	      {For 1 NN 1
	       proc {$ I}
		  if Data.I == ~1 then
		     Sol.I =: Sol.I
		  else
		     Sol.I =: Data.I
		  end
	       end}
	      
	      
	      
	      {FD.distribute ff Sol}
	   end
	end
	
	proc {WriteQWH Size Solutions}
	   {ForAll Solutions
	    proc {$ Sol}
	       {For 1 Size 1
		proc {$ I}
		   {For 1 Size 1
		    proc {$ J}
		       {System.print Sol.((I-1)*Size + J)}
		    end}
		   {System.show ''}
		end}
	       {System.show ''}
	    end}
	end
	
	proc {LoadAssignment Filename Length Assignment}
	   
	   proc {GetAssignment Tokens N Assignment}
	      Filtered
	   in
	      Filtered = {List.filter Tokens fun {$ I}
					     if I == nil then
						false
					     else
						true
					     end
					  end}
	   
	      N = {String.toInt {List.nth Filtered 2}}
	
	      Assignment = {Tuple.make assignment (N*N)}
	
	      {For 1 N*N 1
	       proc {$ I}
		  Assignment.I = {String.toInt {List.nth Filtered 2+I}}
	       end}
	   end
	
	   F Data Tokens
	in
	   F = {New Open.file init(name:Filename)  }
	   Data = {F read(size:all list:$)}
	   {String.tokens Data 32 Tokens}
	   {GetAssignment Tokens Length Assignment}
	end
	
	Length Assignment Args
	in
	
	
	{Property.put 'print.width' 1000}
	{Property.put 'print.depth' 1000}
	
	{Application.getArgs record(mode:anywhere filename(1:single type:string)) Args}
	
	{LoadAssignment Args.filename Length Assignment}
	
	   
	{WriteQWH Length {Search.base.one {QWH Length Assignment}}}
	
	
	{Application.exit 0}
end