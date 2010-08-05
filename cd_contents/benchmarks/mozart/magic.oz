functor
import
	FD
	Space
	Search
	System
	Application
	Property
define
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
	
	Args
	
	in
	{Property.put 'print.width' 1000}
	{Property.put 'print.depth' 1000}
	{Application.getArgs record(mode:anywhere length(1:single type:int default:5)) Args}
	
	{System.show {Search.base.one {MagicSequence Args.length}}}
	
	{Application.exit 0}
end
