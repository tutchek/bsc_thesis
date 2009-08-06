package benchmarks;

import java.io.*;

import static choco.Choco.*;

import choco.cp.model.CPModel;
import choco.kernel.model.Model;
import choco.kernel.model.variables.integer.IntegerVariable;
import choco.kernel.model.variables.set.SetVariable;
import choco.kernel.model.constraints.Constraint;
import choco.kernel.solver.Solver;
import choco.cp.solver.CPSolver;

import java.util.*;

public class Main {

	public static void main(String[] args) throws IOException {
		Model m     = new CPModel();
        Solver s    = new CPSolver();
        
        
        Reader r = new BufferedReader(new FileReader("warehouses.param"));
        
        Vector cappacities = new Vector();
        Vector cost = new Vector();
        int cost_build_warehouse = 0;
        
        Vector actual_list = null;
        
        StreamTokenizer stok = new StreamTokenizer(r);
        stok.parseNumbers();
        
        stok.nextToken();
        while (stok.ttype != StreamTokenizer.TT_EOF) {
          if (stok.ttype == StreamTokenizer.TT_NUMBER)
          {
        	  if (actual_list != null)
        	  {
        		  if (stok.nval != -1)
        		  {
        			  actual_list.add( (int)stok.nval );
        		  }
        	  }
          }
          else
          {
        	if (stok.sval.equals( "cost" ))
            {
            	actual_list = cost;
            } 
        	else if (stok.sval.equals( "cappacities" ))
            {
            	actual_list = cappacities;
            }
        	else if (stok.sval.equals( "warehousecost" ))
            {
        		do
        		{
        			stok.nextToken();
        		} while (stok.ttype != StreamTokenizer.TT_NUMBER);
        		cost_build_warehouse = (int) stok.nval;
            }
          }
          stok.nextToken();
        }

        int count_warehouses = cappacities.size();
        int count_stores = cost.size()/cappacities.size();
        
        int[] capacity = new int[count_warehouses]; 
        
        for (int i = 0; i < count_warehouses; ++i)
        {
        	capacity[i] = ((Integer) cappacities.get(i)).intValue();
        }
        
        int[] supply_cost = new int[count_stores*count_warehouses];
        for (int i = 0; i < count_stores*count_warehouses; ++i)
        {
        	supply_cost[i] = ((Integer)cost.get(i)).intValue();
        }

        IntegerVariable[] open = makeIntVarArray("open", count_warehouses, 0, 1);
        m.addVariables(open);

        IntegerVariable[] suplier = makeIntVarArray("suplier", count_stores, 0, count_warehouses-1);
        m.addVariables("cp:decision", suplier);

        IntegerVariable[] suplies = makeIntVarArray("suplies", count_warehouses*count_stores, 0, 1);
        m.addVariables( suplies );


        for (int i = 0; i < count_warehouses; i++)
        {

            IntegerVariable[] tmp = new IntegerVariable[count_stores];
            for (int j = 0; j < count_stores; j++)
            {
                m.addConstraint( implies( eq( suplier[j], i ) , eq(suplies[j*count_warehouses + i], 1)));
                m.addConstraint( implies( neq( suplier[j], i ) , eq(suplies[j*count_warehouses + i], 0)));
                
                tmp[j] = suplies[j*count_warehouses + i];
            }

            m.addConstraint( leq( sum(tmp) , capacity[i]) );

            m.addConstraint( implies( gt(sum(tmp), 0) , eq(open[i], 1)) );
            m.addConstraint( implies( eq(sum(tmp), 0) , eq(open[i], 0)) );
        }

        IntegerVariable objective = makeIntVar("objective", 0, 1000000);

        m.addVariable( objective );

        m.addConstraint( eq( objective,
                    plus(
                        mult(sum(open), cost_build_warehouse),
                        scalar(suplies, supply_cost)
                      )
                ) );

        s.read(m);

        s.minimize( s.getVar(objective), false );

        if (s.isFeasible())
        {
            s.solve();
            do {
                for (int i = 0; i < suplier.length; i++) {
                    int value = s.getVar(suplier[i]).getVal();
                    System.out.print((value+1)+" ");
                }

                System.out.println();
                int value = s.getVar(objective).getVal();
                System.out.println("Cost: $" + value);
            } while (s.nextSolution());
        }
	}

}
