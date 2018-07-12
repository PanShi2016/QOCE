#include <iostream>
#include "graph_loading.hpp"
#include "cliques.hpp"
#include "Clique_Finder.h"

using namespace std;

//global graph
SimpleIntGraph theGlobalGraph;

int main(int argc, char **argv){
	const char *filename = argv[1];
	int minimumCliqueSize = 4;

	if(argc == 3){
		minimumCliqueSize = atoi(argv[2]);
	}

	Clique_Finder cliqueFinder(filename, minimumCliqueSize);
	cerr << "Edges in loaded graph:\t" << theGlobalGraph.ecount() << endl;
	cerr << "Nodes in loaded graph:\t" << theGlobalGraph.vcount() << endl;

	for(vector<vector<V> >::const_iterator it = cliqueFinder.cliques.begin(); it != cliqueFinder.cliques.end(); ++it){
		for(vector<V>::const_iterator itt = (*it).begin(); itt != (*it).end(); ++itt){
			cout << *itt << " ";
		}
		cout << endl;
	}

	cerr << "Finished\n";

	return 0;
}
