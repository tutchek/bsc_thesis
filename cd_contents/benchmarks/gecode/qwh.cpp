#include <gecode/int.hh>
#include <gecode/search.hh>
#include <gecode/gist.hh>
#include <vector>
#include <string>
#include <iostream>
#include <fstream>

using namespace Gecode;

class QWH : public Space {
protected: 
	IntVarArray m_q;
	int m_width;

public:
	QWH(int width, const std::vector<int>& preassignment) 
		: m_width(width), m_q(*this, width*width, 0, width-1)
	{
		for (int i = 0; i < m_width; i++)
		{
			IntVarArgs row(m_width);
			IntVarArgs column(m_width);

			for (int j = 0; j < m_width; j++)
			{
				if (preassignment[i*m_width + j] != -1)
				{
					rel(*this, m_q[i*m_width + j], IRT_EQ, preassignment[i*m_width + j]);
				}

				row[j] = m_q[i*m_width + j];
				column[j] = m_q[i + j*width];
			}

			distinct(*this, row);
			distinct(*this, column);
		}

		branch(*this, m_q, INT_VAR_SIZE_MIN, INT_VAL_MIN);
	}

	QWH(bool share, QWH& s) : Space(share, s) {
		m_q.update(*this, share, s.m_q);
		m_width = s.m_width;
	}

	virtual Space* copy(bool share)
	{
		return new QWH(share, *this);
	}

	void print(void) const {
		//std::cout << m_q << std::endl;
		
		for (int i = 0; i < m_width; i++)
		{
			for (int j = 0; j < m_width; j++)
			{
				std::cout << m_q[i*m_width + j] << " ";
			}
			std::cout << std::endl;
		}
	}

};

int main(int argc, char** argv)
{
	int width = 5;
	std::vector<int> v;

	if ( argc > 1 )
	{
		char* filename = argv[1];
		
		std::ifstream fin;
		fin.open(filename);

		std::string s;
		fin >> s;

		if (s != "order")
		{
			return 1;
		}
		fin >> width;
		
		for (int i = 0; i < width*width; i++)
		{
			int tmp;
			fin >> tmp;
			v.push_back(tmp);
		}


		fin.close();
	} else {
		for (int i = 0; i < width*width; i++)
		{
			v.push_back(-1);
		}
	}

	QWH* m = new QWH(width, v);
	
	DFS<QWH> e(m);
	delete m;

	while (QWH* s = e.next())
	{
		s->print();
		delete s;
		break;
	}
	
	return 0;
}
