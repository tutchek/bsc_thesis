/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package locatingwarehouses;

import static choco.Choco.*;

import choco.cp.model.CPModel;
import choco.kernel.model.Model;
import choco.kernel.model.variables.integer.IntegerVariable;
import choco.kernel.model.variables.set.SetVariable;
import choco.kernel.model.constraints.Constraint;
import choco.kernel.solver.Solver;
import choco.cp.solver.CPSolver;
import choco.kernel.model.variables.real.RealVariable;
import choco.kernel.solver.variables.real.RealVar;

/**
 *
 * @author Tutchek
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Model m     = new CPModel();
        Solver s    = new CPSolver();

        int count_warehouses = 5;
        int count_stores = 10;


        int cost_build_warehouse = 50;

        int[] capacity = new int[]{ 1, 4, 2, 1, 3 };

        /*
        int[] supply_cost = new int[]{
            20, 24, 11, 25, 30,
            28, 27, 82, 83, 74,
            74, 97, 71, 96, 70,
            2, 55, 73, 69, 61,
            46, 96, 59, 83, 4,
            42, 22, 29, 67, 59,
            1, 5, 73, 59, 56,
            10, 73, 13, 43, 96,
            93, 35, 63, 85, 46,
            47, 65, 55, 71, 95
        };
        */

        int[] supply_cost = new int[]{
            36, 42, 22, 44, 52,
            49, 47, 134, 135, 121,
            121, 158, 117, 156, 115,
            8, 91, 120, 113, 101,
            77, 156, 98, 135, 11,
            71, 39, 50, 110, 98,
            6, 12, 120, 98, 93,
            20, 120, 25, 72, 156,
            151, 60, 104, 139, 77,
            79, 107, 91, 117, 154};

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

        //Visu v = Visu.createVisu(
        //v.addPanel(new VarChocoPanel("Grid", vars, GRID, null));

        if (s.isFeasible())
        {
            s.solve();
            do {
                System.out.println("Solution: ");

                for (int i = 0; i < suplies.length; i++) {
                    if ( i%count_warehouses == 0)
                    {
                        System.out.println();
                    }
                    int value = s.getVar(suplies[i]).getVal();
                    System.out.print(value+" ");

                }
                
                System.out.println();
                System.out.println();

                for (int i = 0; i < open.length; i++) {
                    int value = s.getVar(open[i]).getVal();
                    System.out.print( (value == 1 ? "ANO" : "NE" )+" ");
                }

                System.out.println();
                System.out.println();

                for (int i = 0; i < suplier.length; i++) {
                    int value = s.getVar(suplier[i]).getVal();
                    System.out.print((value+1)+" ");
                }

                System.out.println();
                int value = s.getVar(objective).getVal();
                System.out.print("Cost: $" + value);

                System.out.println();
                System.out.println();

                //System.out.print("X");
            } while (s.nextSolution());
        } else  {
            System.out.print("!");
        }
        System.out.println(".");
    }

}
