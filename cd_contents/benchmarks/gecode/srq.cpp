#include <gecode/int.hh>
#include <gecode/search.hh>
#include <gecode/minimodel.hh>
#include <iostream>

using namespace Gecode;

class SRQ : public Space {
protected: 
	BoolVarArray q;

public:
	inline int getId(int question, int answer) const {
		return question * 5 + answer;
	}
	
	SRQ() : q(*this, 50, 0, 1)
	{
		// Exactly one answer to any question
		for (int i = 0; i < 10; i++)
		{
			IntVarArray aux(*this, 5, 0, 1);

			for (int j = 0; j < 5; j++)
			{
				channel(*this, q[getId(i,j)], aux[j]);
			}

			linear(*this, aux, IRT_EQ, 1);
		}
		
		// Question 1
		for (int i = 0; i < 4; i++)
		{
			BoolVarArgs q1true(1);
			BoolVarArgs q1false(4-i-1);

			q1true[0] = q[getId(4-i-1, 0)];
			for (int j = 0; j < 4-i-1; j++)
			{
				q1false[j] = q[getId(4-j-1, 0)];
			}

			clause(*this, BOT_AND, q1true, q1false, q[getId(0, i)]);
		}
		
		BoolVarArgs q1e(4);
		for (int i = 0; i < 4; i++)
		{
			q1e[i] = q[ i*5 ];
		}
		rel(*this, BOT_AND, q1e, q[4]);

		// Question 2
		for (int i = 0; i < 5; i++)
		{
			BoolVarArray aux(*this, 5, 0, 1);
			for (int j = 0; j < 5; j ++)
			{
				post(*this, tt(eqv( aux[j] , 
						(q[ getId(i+2, j) ] && q[ getId(i+3, j) ])
						||
						(!q[ getId(i+2, j) ] && !q[ getId(i+3, j) ])
				)));
			}

			rel(*this, BOT_AND, aux, q[ getId(1, i) ]);
		}

		// Question 3
		for (int i = 0; i < 5; i++)
		{
			BoolVarArgs q3true(1);
			BoolVarArgs q3false(i);

			q3true[0] = q[getId(3+i, 0)];

			for (int j = 0; j < i; j++)
			{
				q3false[j] = q[getId(3+j, 0)];
			}

			clause(*this, BOT_AND, q3true, q3false, q[getId(2, i)]);
		}

		// Question 4
		for (int i = 0; i < 5; i++)
		{
			BoolVarArgs q4true(1);
			BoolVarArgs q4false(i);

			q4true[0] = q[getId(i*2+1, 1)];

			for (int j = 0; j < i; j++)
			{
				q4false[j] = q[getId(j*2+1, 1)];
			}

			clause(*this, BOT_AND, q4true, q4false, q[getId(3, i)]);
		}

		// Question 5
		for (int i = 0; i < 5; i++)
		{
			BoolVarArgs q5true(1);
			BoolVarArgs q5false(i);

			q5true[0] = q[getId(i*2, 2)];

			for (int j = 0; j < i; j++)
			{
				q5false[j] = q[getId(j*2, 2)];
			}

			clause(*this, BOT_AND, q5true, q5false, q[getId(4, i)]);
		}

		// Question 6
		IntVarArray dBefore(*this, 5, 0, 1),
					dAfter (*this, 4, 0, 1);

		for (int i = 0; i < 5; i++)
		{
			channel(*this, q[getId(i,3)], dBefore[i]);
		}

		for (int i = 0; i < 4; i++)
		{
			channel(*this, q[getId(i+6,3)], dAfter[i]);
		}

		IntVar dBeforeSum(*this, 0, 5),
			   dAfterSum (*this, 0, 4);
		
		linear(*this, dBefore, IRT_EQ, dBeforeSum);
		linear(*this, dAfter , IRT_EQ, dAfterSum );
		// 6A
		post(*this, tt(eqv((dBeforeSum > 0) && (dAfterSum == 0) , q[getId(5, 0)] )));
		// 6B
		post(*this, tt(eqv((dBeforeSum == 0) && (dAfterSum > 0) , q[getId(5, 1)] )));
		// 6C
		post(*this, tt(eqv((dBeforeSum > 0) && (dAfterSum > 0) , q[getId(5, 2)] )));
		// 6D
		post(*this, tt(eqv(!q[getId(5, 3)] && (dBeforeSum == 0) && (dAfterSum == 0) , q[getId(5, 3)] )));
		// 6E
		post(*this, tt(eqv(q[getId(5, 3)] && (dBeforeSum == 0) && (dAfterSum == 0), q[getId(5, 4)])));
		
		// Question 7
		for (int i = 0; i < 5; i++)
		{
			BoolVarArgs q7true(1);
			BoolVarArgs q7false(5-i);

			q7true[0] = q[getId(4+i, 4)];

			for (int j = 0; j < 5-i; j++)
			{
				q7false[j] = q[getId(4+i+j+1, 4)];
			}

			clause(*this, BOT_AND, q7true, q7false, q[getId(6, i)]);
		}

		// Question 8
		IntVarArray consonants(*this, 3*10, 0, 1);
		for (int i = 0; i < 10; i++)
		{
			for (int j = 0; j < 3; j++)
			{
				channel(*this, q[ getId(i,j+1) ], consonants[i*3 + j]);
			}
		}
		IntVar consonantsSum(*this, 0, 3*10);
		linear(*this, consonants, IRT_EQ, consonantsSum); 

		for (int i = 0; i < 5; i++)
		{
			post( *this, tt(eqv( consonantsSum == 7-i, q[ getId(7,i) ] )) );
		}

		// Question 9
		IntVarArray vowels(*this, 2*10, 0, 1);
		for (int i = 0; i < 10; i++)
		{
			channel(*this, q[ getId(i,0) ], vowels[i*2 + 0]);
			channel(*this, q[ getId(i,4) ], vowels[i*2 + 1]);
		}
		IntVar vowelsSum(*this, 0, 2*10);
		linear(*this, vowels, IRT_EQ, vowelsSum); 

		for (int i = 0; i < 5; i++)
		{
			post( *this, tt(eqv( vowelsSum == i, q[ getId(8,i) ] )) );
		}
		
		branch(*this, q, INT_VAR_SIZE_MIN, INT_VAL_MIN);
	}

	SRQ(bool share, SRQ& s) : Space(share, s) {
		q.update(*this, share, s.q);
	}

	virtual Space* copy(bool share)
	{
		return new SRQ(share, *this);
	}

	void print(void) const {
		std::cout << "------" << std::endl;
		for (int i = 0; i < 10; i++)
		{
			for (int j = 0; j < 5; j++)
			{
				std::cout << q[i*5 + j] << " ";
			}
			std::cout << std::endl;
		}
	}

};

int main(int argc, char** argv)
{
	SRQ* m = new SRQ();
	
	DFS<SRQ> e(m);
	delete m;

	while (SRQ* s = e.next())
	{
		s->print();
		delete s;
	}
	
	return 0;
}
