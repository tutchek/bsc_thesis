#include <gecode/int.hh>
#include <gecode/search.hh>
#include <gecode/minimodel.hh>
#include <iostream>

using namespace Gecode;

class Queens : public Space {
protected: 
	IntVarArray q;

public:
	Queens(int length) : q(*this, length, 1, length)
	{
		distinct(*this, q);

		for (int i = 0; i < length; i++)
		{
			for (int j = i+1; j < length; j++)
			{
				post(*this, (q[i]-q[j]) != (i-j));
				post(*this, (q[i]-q[j]) != (j-i));
			}
		}

		post(*this, q[0] < q[length-1]);
		
		branch(*this, q, INT_VAR_SIZE_MIN, INT_VAL_MIN);
	}

	Queens(bool share, Queens& s) : Space(share, s) {
		q.update(*this, share, s.q);
	}

	virtual Space* copy(bool share)
	{
		return new Queens(share, *this);
	}

	void print(void) const {
		std::cout << q << std::endl;
	}

};

int main(int argc, char** argv)
{
	int length = 8;
	if ( argc > 1 )
	{
		length = atoi(argv[1]);
	}

	Queens* q = new Queens(length);	

	DFS<Queens> e(q);
	delete q;

	while (Queens* s = e.next())
	{
		s->print();
		delete s;
	}
	
	return 0;
}