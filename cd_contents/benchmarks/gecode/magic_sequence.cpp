#include <gecode/int.hh>
#include <gecode/search.hh>
#include <gecode/gist.hh>

using namespace Gecode;

class MagicSequence : public Space {
protected: 
	IntVarArray m;

public:
	MagicSequence(int length) : m(*this, length, 0, length)
	{
		count(*this, m, m);
		
		branch(*this, m, INT_VAR_SIZE_MIN, INT_VAL_MIN);
	}

	MagicSequence(bool share, MagicSequence& s) : Space(share, s) {
		m.update(*this, share, s.m);
	}

	virtual Space* copy(bool share)
	{
		return new MagicSequence(share, *this);
	}

	void print(void) const {
		std::cout << m << std::endl;
	}

};

int main(int argc, char** argv)
{
	int length = 5;
	if ( argc > 1 )
	{
		length = atoi(argv[1]);
	}

	MagicSequence* m = new MagicSequence(length);
	
	DFS<MagicSequence> e(m);
	delete m;

	while (MagicSequence* s = e.next())
	{
		s->print();
		delete s;
	}
	
	return 0;
}
