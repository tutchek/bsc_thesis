functor
import
	FD
	Space
	Search
	System
	Application
	Property
define
	fun {SRQ}
	   proc {$ Sol}
	      fun {GetId I J}
		 (I-1)*5 + J
	      end
	
	      Before
	      After
	      SumBefore
	      SumAfter
	      C
	      Consonants
	      Vowels
	      SumConsonants
	      SumVowels
	   in
	      {FD.tuple questions 50 0#1 Sol}
	
	      {For 1 10 1
	       proc {$ I}
		  Ans
	       in
		  {FD.tuple answers 5 0#1 Ans}
		  {For 1 5 1
		   proc {$ J}
		      Ans.J = Sol.{GetId I J}
		   end}
		  {FD.sum Ans '=:' 1}
	       end}
	
	      % Question 1
	      Sol.{GetId 1 1} =: {FD.conj (Sol.{GetId 4 1} =: 1) (Sol.{GetId 3 1} + Sol.{GetId 2 1} + Sol.{GetId 1 1} =: 0)}
	      Sol.{GetId 1 2} =: {FD.conj (Sol.{GetId 3 1} =: 1) (Sol.{GetId 2 1} + Sol.{GetId 1 1} =: 0)}
	      Sol.{GetId 1 3} =: {FD.conj (Sol.{GetId 2 1} =: 1) (Sol.{GetId 1 1} =: 0)}
	      Sol.{GetId 1 4} =: (Sol.{GetId 1 1} =: 1)
	      Sol.{GetId 1 5} =: (Sol.{GetId 4 1} + Sol.{GetId 3 1} + Sol.{GetId 2 1} + Sol.{GetId 1 1} =: 0)
	
	      % Question 2
	      {For 1 5 1
	       proc {$ I}
		  Sol.{GetId 2 I} =: {FD.conj (Sol.{GetId (I+2) 1} =: Sol.{GetId (I+3) 1})
				      {FD.conj (Sol.{GetId (I+2) 2} =: Sol.{GetId (I+3) 2})
				       {FD.conj (Sol.{GetId (I+2) 3} =: Sol.{GetId (I+3) 3})
					{FD.conj (Sol.{GetId (I+2) 4} =: Sol.{GetId (I+3) 4}) (Sol.{GetId (I+2) 5} =: Sol.{GetId (I+3) 5})}}}}
	       end}
	
	      % Question 3
	      Sol.{GetId 3 1} =: (Sol.{GetId 4 1} =: 1)
	      Sol.{GetId 3 2} =: {FD.conj (Sol.{GetId 5 1} =: 1) (Sol.{GetId 4 1} =: 0)}
	      Sol.{GetId 3 3} =: {FD.conj (Sol.{GetId 6 1} =: 1)
				  {FD.conj (Sol.{GetId 5 1} =: 0) (Sol.{GetId 4 1} =: 0)}}
	      Sol.{GetId 3 4} =: {FD.conj (Sol.{GetId 7 1} =: 1)
				  {FD.conj (Sol.{GetId 6 1} =: 0)
				   {FD.conj (Sol.{GetId 5 1} =: 0) (Sol.{GetId 4 1} =: 0)}}}
	      Sol.{GetId 3 5} =: {FD.conj (Sol.{GetId 8 1} =: 1)
				  {FD.conj (Sol.{GetId 7 1} =: 0)
				   {FD.conj (Sol.{GetId 6 1} =: 0)
				    {FD.conj (Sol.{GetId 5 1} =: 0) (Sol.{GetId 4 1} =: 0)}}}}
	
	      % Question 4
	      Sol.{GetId 4 1} =: (Sol.{GetId 2 2} =: 1)
	      Sol.{GetId 4 2} =: {FD.conj (Sol.{GetId 4 2} =: 1) (Sol.{GetId 2 2} =: 0)}
	      Sol.{GetId 4 3} =: {FD.conj (Sol.{GetId 6 2} =: 1)
				  {FD.conj (Sol.{GetId 4 2} =: 0) (Sol.{GetId 2 2} =: 0)}}
	      Sol.{GetId 4 4} =: {FD.conj (Sol.{GetId 8 2} =: 1)
				  {FD.conj (Sol.{GetId 6 2} =: 0)
				   {FD.conj (Sol.{GetId 4 2} =: 0) (Sol.{GetId 2 2} =: 0)}}}
	      Sol.{GetId 4 5} =: {FD.conj (Sol.{GetId 10 2} =: 1)
				  {FD.conj (Sol.{GetId 8 2} =: 0)
				   {FD.conj (Sol.{GetId 6 2} =: 0)
				    {FD.conj (Sol.{GetId 4 2} =: 0) (Sol.{GetId 2 2} =: 0)}}}}
	
	      % Question 5
	      {FD.tuple questions 10 0#1 C}
	      {For 1 5 1
	       proc {$ I}
		  C.I = Sol.{GetId (2*I-1) 3}
	       end}
	      
	      {FD.sum C '=:' 1}
	
	      Sol.{GetId 5 1} =: ( Sol.{GetId 1 3} =: 1 )
	      Sol.{GetId 5 2} =: ( Sol.{GetId 3 3} =: 1 )
	      Sol.{GetId 5 3} =: ( Sol.{GetId 5 3} =: 1 )
	      Sol.{GetId 5 4} =: ( Sol.{GetId 7 3} =: 1 )
	      Sol.{GetId 5 5} =: ( Sol.{GetId 9 3} =: 1 )
	      
	
	      % Question 6
	      {FD.tuple questions 5 0#1 Before}
	      {For 1 5 1
	       proc {$ I}
		  Before.I = Sol.{GetId I 4}
	       end}
	      
	      {FD.decl SumBefore}
	      {FD.sum Before '=:' SumBefore}
	
	      {FD.tuple questions 4 0#1 After}
	      {For 1 4 1
	       proc {$ I}
		  After.I = Sol.{GetId (I+6) 4}
	       end}
	      
	      {FD.decl SumAfter}
	      {FD.sum After '=:' SumAfter}
	
	      Sol.{GetId 6 1} =: {FD.conj (SumBefore >: 0) (SumAfter =: 0)}
	      Sol.{GetId 6 2} =: {FD.conj (SumBefore =: 0) (SumAfter >: 0)}
	      Sol.{GetId 6 3} =: {FD.conj (SumBefore >: 0) (SumAfter >: 0)}
	      Sol.{GetId 6 4} =: {FD.conj (Sol.{GetId 6 4} =: 0) {FD.conj (SumBefore =: 0) (SumAfter =: 0)}}
	      Sol.{GetId 6 5} =: Sol.{GetId 6 4}
	
	      % Question 7
	      Sol.{GetId 7 1} =: {FD.conj (Sol.{GetId 5 5} =: 1)
				  {FD.conj (Sol.{GetId 6 5} =: 0)
				   {FD.conj (Sol.{GetId 7 5} =: 0)
				    {FD.conj (Sol.{GetId 8 5} =: 0)
				     {FD.conj (Sol.{GetId 9 5} =: 0) (Sol.{GetId 10 5} =: 0)}}}}}
	      Sol.{GetId 7 2} =: {FD.conj (Sol.{GetId 6 5} =: 1)
				  {FD.conj (Sol.{GetId 7 5} =: 0)
				   {FD.conj (Sol.{GetId 8 5} =: 0)
				    {FD.conj (Sol.{GetId 9 5} =: 0) (Sol.{GetId 10 5} =: 0)}}}}
	      Sol.{GetId 7 3} =: {FD.conj (Sol.{GetId 7 5} =: 1)
				  {FD.conj (Sol.{GetId 8 5} =: 0)
				   {FD.conj (Sol.{GetId 9 5} =: 0) (Sol.{GetId 10 5} =: 0)}}}
	      Sol.{GetId 7 4} =: {FD.conj (Sol.{GetId 8 5} =: 1)
				  {FD.conj (Sol.{GetId 9 5} =: 0) (Sol.{GetId 10 5} =: 0)}}
	      Sol.{GetId 7 5} =: {FD.conj (Sol.{GetId 9 5} =: 1) (Sol.{GetId 10 5} =: 0)}
	
	      % Question 8
	      {FD.tuple consonant 30 0#1 Consonants}
	      {FD.decl SumConsonants}
	      {For 1 10 1
	       proc {$ I}
		  Consonants.(3*(I-1) + 1) = Sol.{GetId I 2}
		  Consonants.(3*(I-1) +1 + 1) = Sol.{GetId I 3}
		  Consonants.(3*(I-1) +2 + 1) = Sol.{GetId I 4}
	       end}
	
	      {FD.sum Consonants '=:' SumConsonants}
	      {For 1 5 1
	       proc {$ I}
		  Sol.{GetId 8 I} =: (SumConsonants =: (7-I+1))
	       end}
	
	      % Question 9
	      {FD.tuple vowels 20 0#1 Vowels}
	      {FD.decl SumVowels}
	      {For 1 10 1
	       proc {$ I}
		  Vowels.(2*(I-1) + 1) = Sol.{GetId I 1}
		  Vowels.(2*(I-1) +1 + 1) = Sol.{GetId I 5}
	       end}
	
	      {FD.sum Vowels '=:' SumVowels}
	      {For 1 5 1
	       proc {$ I}
		  Sol.{GetId 9 I} =: (SumVowels =: (I-1))
	       end}
	      
	      
	      {FD.distribute ff Sol}
	   end
	end
	
	proc {PrintSolution Solutions}
	   {List.forAll Solutions
	    proc {$ Sol}
	       {For 1 50 5
						proc {$ I}
		   			{For 0 4 1
		    			proc {$ J}
		       			{System.print Sol.(I+J)}
		    			end}
		   				{System. ''}
						end}
	    end}
	   {System.show ''}
	   {System.show ''}
		end  
	
	in
		
	{Property.put 'print.width' 1000}
	{Property.put 'print.depth' 1000}
		
	{System.show {Search.base.all {SRQ}}}
	
	
	{Application.exit 0}
end