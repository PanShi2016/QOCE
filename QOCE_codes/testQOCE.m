function [] = testQOCE()
% test QOCE

nthread = 1;
t0 = 3;
mu = 0;
alpha = 0.2;
w = 5;

graph_file = "../example/Karate/graph.pairs";
clique_file = "../example/Karate/seeds.txt";
groundtruth_file = "../example/Karate/community.txt";
save_file = "../example/Karate/QOCE.gen";

graph = loadGraph(graph_file);
cliques = loadCommunities(clique_file);
groundtruth = loadCommunities(groundtruth_file);

detectedCommunities = QOCE(graph, cliques, nthread, t0, mu, alpha, w);
saveCommunities(save_file, detectedCommunities);

f1 = GetF1score(detectedCommunities, groundtruth);
fprintf("F1-score of QOCE: %.3f\n", f1);

end
