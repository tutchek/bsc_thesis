package benchmarks;

import static choco.Choco.*;

import choco.cp.model.CPModel;
import choco.kernel.model.Model;
import choco.kernel.model.variables.integer.IntegerVariable;
import choco.kernel.model.variables.set.SetVariable;
import choco.kernel.model.constraints.Constraint;
import choco.kernel.solver.Solver;
import choco.cp.solver.CPSolver; 

public class Main {
	public static void main(String[] args) {
		Model m = new CPModel();
        Solver s = new CPSolver();
        
        Boolean all = false;
        
        int n = 8;
        if (args.length > 0)
        {
	        try
	        {
	            n = Integer.parseInt(args[0]);
	        }
	        catch (Exception e)
	        {
	            n = 8;
	        }
        }
        
        if (args.length > 1)
        {
        	if (args[1].trim().equals("all"))
        	{
        		all = true;
        	}
        }

        IntegerVariable[] queens = choco.Choco.makeIntVarArray("queens", n, 1, n);

        m.addVariables(queens);
        m.addConstraint( allDifferent(queens) );

        for (int i = 0; i < n; i++)
        {
            for (int j = i+1; j < n; j++)
            {
                m.addConstraint(
                            distanceNEQ(queens[i], queens[j], Math.abs(i- j))
                          );
            }
        }

        m.addConstraint( leq(queens[0], queens[n-1]) );

        s.read(m);
        Boolean some = s.solve();

        if (some)
        {
            do {
                for (int i = 0; i < queens.length; i++) {
                    int value = s.getVar(queens[i]).getVal();
                    System.out.print(value+" ");
                }

                System.out.println();
            } while (all && s.nextSolution());
        }
	}

}
