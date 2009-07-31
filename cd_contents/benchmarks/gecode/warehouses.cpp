#include <gecode/int.hh>
#include <gecode/search.hh>
#include <gecode/minimodel.hh>

#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace Gecode;

class Warehouses : public MinimizeSpace {
protected: 
	IntVar TotalCost;
	IntVar NumberOpen;
	
	IntVarArray Open;
	IntVarArray Supplier;


	IntVarArray Cost;
	IntVar SumCost;

	int numberOfWarehouses;
	int numberOfStores;

public:
	Warehouses(
		int nbWarehouses,
		int nbStores,
		const std::vector<int>& supplyCost, 
		const std::vector<int>& warehouseCapacity
		) 
	: 
		numberOfWarehouses(nbWarehouses),
		numberOfStores(nbStores),
		Supplier(*this, nbStores, 0, nbWarehouses-1),
		TotalCost(*this, 0, Gecode::Int::Limits::max),
		Open(*this, nbWarehouses, 0, 1),
		NumberOpen(*this, 0, nbWarehouses),
		Cost(*this, nbStores, 0, Gecode::Int::Limits::max),
		SumCost(*this, 0, Gecode::Int::Limits::max)
	{
		
		for (int i = 0; i < numberOfWarehouses; i++)
		{
			IntVarArray aux_supplied(*this, numberOfStores, 0, 1);

			for (int j = 0; j < numberOfStores; j++)
			{
				post(*this, tt( imp( Supplier[j] == i, aux_supplied[j] == 1) ));
				post(*this, tt( imp( Supplier[j] != i, aux_supplied[j] == 0) ));

				post(*this, tt( imp( Supplier[j] == i, Cost[j] == supplyCost[i + j * numberOfWarehouses]) ));
			}

			IntVar aux_sum(*this, 0, numberOfStores);
			
			linear(*this, aux_supplied, IRT_EQ, aux_sum);

			post(*this, tt( imp( aux_sum > 0, Open[i] == 1 ) ));
			post(*this, tt( imp( aux_sum == 0, Open[i] == 0 ) ));

			rel( *this, aux_sum, IRT_LQ, warehouseCapacity[i] );
		}
		
		linear(*this, Open, IRT_EQ, NumberOpen);

		linear(*this, Cost, IRT_EQ, SumCost);

		IntArgs costArgs(2);
		costArgs[0] = 1;
		costArgs[1] = 50;

		IntVarArgs costVariables(2);
		costVariables[0] = SumCost;
		costVariables[1] = NumberOpen;

		linear(*this, costArgs, costVariables, IRT_EQ, TotalCost);
		
		branch(*this, Supplier, INT_VAR_SIZE_MIN, INT_VAL_MIN);
		branch(*this, Open, INT_VAR_SIZE_MIN, INT_VAL_MIN);
	}

	virtual IntVar cost() const {
		return TotalCost;
	}

	Warehouses(bool share, Warehouses& s) : MinimizeSpace(share, s) {
		Supplier.update(*this, share, s.Supplier);
		TotalCost.update(*this, share, s.TotalCost);
		Open.update(*this, share, s.Open);
		NumberOpen.update(*this, share, s.NumberOpen);
		Cost.update(*this, share, s.Cost);
		SumCost.update(*this, share, s.SumCost);

		numberOfWarehouses = s.numberOfWarehouses;
		numberOfStores = s.numberOfStores;
	}

	virtual Space* copy(bool share)
	{
		return new Warehouses(share, *this);
	}

	void print(void) const {
		std::cout << "Cost: " << TotalCost << std::endl;
		std::cout << "Suppliers:" << Supplier << std::endl;
		std::cout << "Open:" << Open << std::endl;
	}

};

int main(int argc, char** argv)
{
	std::vector<int> supplyCost;
	std::vector<int> warehouseCapacity;

	std::ifstream fin;
	fin.open("warehouses.param");

	while (!fin.fail())
	{
		std::string s;
		fin >> s;

		if ( s == "cappacities" ) {
			int i;
			while (!fin.fail())
			{
				fin >> i;

				if (i != -1)
				{
					warehouseCapacity.push_back(i);
				} else {
					break;
				}
			}
		} else if ( s == "cost" ) {
			int i;
			while (!fin.fail())
			{
				fin >> i;

				if (i != -1)
				{
					supplyCost.push_back(i);
				} else {
					break;
				}
			}
		}
	}



	fin.close();


 	Warehouses* w = new Warehouses( warehouseCapacity.size(), supplyCost.size()/warehouseCapacity.size(), supplyCost, warehouseCapacity);
	
	BAB<Warehouses> e(w);
	delete w;

	Warehouses* last = 0;
	while (Warehouses* s = e.next())
	{
		if (last != 0)
		{ 
			delete last; 
		}

		last = s;
	}

	if (last)
	{
		last->print();
		delete last;
	}
	
	return 0;
}
