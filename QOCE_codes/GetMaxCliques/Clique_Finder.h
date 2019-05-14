#ifndef CLIQUE_FINDER_H_
#define CLIQUE_FINDER_H_
#include <iostream>
#include <time.h>
#include "graph_loading.hpp"
#include "cliques.hpp"

using namespace std;

extern SimpleIntGraph theGlobalGraph;

class Clique_Finder{
public:
	vector<vector<V> > cliques;
	
	void operator()(const vector<V> & clique);
	Clique_Finder(const char * filename, int minimumCliqueSize);
	//virtual ~Clique_Finder();

private:
	void initialiseCliques(const char * filename, int minimumCliqueSize);
};

#endif //CLIQUE_FINDER_H_
