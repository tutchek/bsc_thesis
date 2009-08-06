package benchmarks;

import java.io.*;
import java.util.Vector;

import static choco.Choco.*;

import choco.cp.model.CPModel;
import choco.kernel.model.Model;
import choco.kernel.model.variables.integer.IntegerVariable;
import choco.kernel.model.variables.set.SetVariable;
import choco.kernel.model.constraints.Constraint;
import choco.kernel.solver.Solver;
import choco.cp.solver.CPSolver;

public class Main {
	public static void main(String[] args) throws IOException {
		Model m = new CPModel();
        Solver s = new CPSolver();
        
        Vector assignment = new Vector();
        Vector actual_list = null;
        int n = 10;
        
        Reader r = new BufferedReader(new FileReader(args[0]));
        StreamTokenizer stok = new StreamTokenizer(r);
        stok.parseNumbers();
        
        stok.nextToken();
        while (stok.ttype != StreamTokenizer.TT_EOF) {
          if (stok.ttype == StreamTokenizer.TT_NUMBER)
          {
        	  if (actual_list != null)
        	  {
        		  actual_list.add( (int)stok.nval );
        	  } else {
        		  n = (int)stok.nval;
        		  actual_list = assignment;
        	  }
          }
          stok.nextToken();
        }
        
        IntegerVariable[][] quasigroup = new IntegerVariable[n][];
        for (int i = 0; i < n; i++)
        {
        	quasigroup[i] = makeIntVarArray("quasigroup_"+i, n, 0, n-1);
        	
        	m.addVariables(quasigroup[i]);
        	m.addConstraint( allDifferent(quasigroup[i]) );
        }
        
        for (int i = 0; i < n; i++)
        {
        	IntegerVariable[] col = new IntegerVariable[n];
        	for (int j = 0; j < n; j++)
        	{
        		col[j] = quasigroup[j][i];
        	}
        	
        	m.addConstraint( allDifferent(col) );
        }
        
        for (int i = 0; i < n; i++)
        {
        	for (int j = 0; j < n; j++)
        	{
        		int val = ((Integer)assignment.get(i*n + j)).intValue();
        		if (val != -1)
        		{
        			m.addConstraint( eq( quasigroup[i][j], val ) );
        		}
        	}
        }
        
        
        
		s.read(m);
        
        Boolean some = s.solve();

        if (some)
        {
            do {
            	for (int i = 0; i < quasigroup.length; i++) {
                	
                	for (int j = 0; j < quasigroup[i].length; j++)
                    {
	                	int value = s.getVar(quasigroup[i][j]).getVal();
	                    System.out.print(value+" ");
                    }
                    System.out.println();
                }

                System.out.println();
                
            } while (false && s.nextSolution());
        }
	}

}
