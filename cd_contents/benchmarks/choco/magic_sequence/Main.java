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
        
        int n = 10;
        
        if (args.length > 0)
        {
	        try
	        {
	            n = Integer.parseInt(args[0]);
	        }
	        catch (Exception e)
	        {
	            n = 10;
	        }
        }
        
        IntegerVariable[] sequence = makeIntVarArray("seq", n, 0, n);

        m.addVariables(sequence);

        IntegerVariable[] aux_number = makeIntVarArray("aux_number", n*n, 0, 1);

        m.addVariables(aux_number);

        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < n; j++)
            {
                m.addConstraint( implies( eq(sequence[j], i) , eq(aux_number[j + i*n], 1) ) );
                m.addConstraint( implies( neq(sequence[j], i) , eq(aux_number[j + i*n], 0) ) );
            }
        }

        for (int i = 0; i < n; i++)
        {
            IntegerVariable[] tmp = new IntegerVariable[n];
            for (int j = 0; j < n; j++)
            {
                tmp[j] = aux_number[j + i*n];
            }

            m.addConstraint( eq( sum( tmp ), sequence[i] ) );
        }

        s.read(m);
        
        Boolean some = s.solve();

        if (some)
        {
            do {
                for (int i = 0; i < sequence.length; i++) {
                    int value = s.getVar(sequence[i]).getVal();
                    System.out.print(value+" ");
                }

                System.out.println();
                
            } while (s.nextSolution());
        }
    }

}
