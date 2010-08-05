functor
import
	FD
	Space
	Search
	System
	Application
	Property
define
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
	
	Args
	
	in
	
	{Property.put 'print.width' 1000}
	{Property.put 'print.depth' 1000}
	
	{Application.getArgs record(mode:anywhere count(1:single type:int default:8) all(1:single type:bool default:false)) Args}
	
	if Args.all == true then
		{System.show {Search.base.all {Queens Args.count}}}
	else
		{System.show {Search.base.one {Queens Args.count}}}
	end
	
	{Application.exit 0}
end
