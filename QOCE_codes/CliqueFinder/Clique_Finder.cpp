#include "Clique_Finder.h"

#define REPORTING_OUTPUT_FREQUENCY 1000

time_t t0 = clock();

Clique_Finder::Clique_Finder(const char * filename, int minimumCluqueSize){
	this->initialiseCliques(filename, minimumCluqueSize);
}

int numberOfCliquesProcessed = 0;
void Clique_Finder::operator()(const vector<V> &clique){
	vector<V> temp;

	for(vector<V>::const_iterator cliqueVertexIterator = clique.begin(); cliqueVertexIterator != clique.end(); ++cliqueVertexIterator){
		temp.push_back(*cliqueVertexIterator);
	}

	this->cliques.push_back(temp);
	++ numberOfCliquesProcessed;
	if(numberOfCliquesProcessed % REPORTING_OUTPUT_FREQUENCY == 0){
		fprintf(stderr, "%.2fs: ", (double)(clock() - t0)/CLOCKS_PER_SEC);
		cerr << "Processed: " << numberOfCliquesProcessed << " cliques..." << endl;
	}
}

void Clique_Finder::initialiseCliques(const char *filename, int minimumCluqueSize){
	graph_loading::loadSimpleIntGraphFromFile(theGlobalGraph, filename);
	cliques::findCliquesOriginalVertexNames(theGlobalGraph, *this, minimumCluqueSize);
	cerr << "Loaded : " << this->cliques.size() << " cliques." << endl;
}
