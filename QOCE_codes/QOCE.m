function [] = QOCE(k0,alpha)
% test dataset for QOCE algorithm

% k0 is the steps of random walk for sampling
% alpha: a parameter controls quadratic optimization

k0 = 3;
alpha = 0.2;

graphName = '../example/Karate/graph.pairs';

truthName = '../example/Karate/community.txt'; 

seedsName = '../example/Karate/seeds.txt';

saveName = '../example/Karate/results.txt'; 

% load graph
graph = loadGraph(graphName);

% load truth communities
truthComm = loadCommunities(truthName);

% load seeds
c4 = loadCommunities(seedsName);
n4 = length(c4);

seedsNum = zeros(n4,1);

for i = 1: n4
    seedsNum(i) = length(c4{i});
end

detectedComm = {};
Conductance = [];
detectedSize = [];
Alltime = [];
mark = 0;

while n4 > 0
    % if mark = 1, then it is the first time for seed set expansion
    mark = mark + 1;

    % choose maximal seed to expand
    max_seedsNum = max(seedsNum);
    max_seedsNum_i = find(seedsNum == max_seedsNum, 1, 'first');
    seeds = c4{max_seedsNum_i};

    seedsNum(max_seedsNum_i) = [];
    c4(max_seedsNum_i) = [];
    n4 = n4 - 1;

    tmark = tic;
    % sample graph by fast random walk
    prob = fast_rw(graph,seeds,k0);
    [newprob,I] = sort(prob,'descend');
    nodeId = find(newprob);
    set = I(nodeId);
    set = union(seeds,set,'stable');

    sampleGraph = graph(set,set);
    [~,seedsId] = intersect(set,seeds);
    
    % quadratic programming
    L = diag(sum(sampleGraph)) - sampleGraph;
    v = quad_prog(L,seedsId,alpha);

    if(isempty(v))
        continue;
    end
    
    % compute conductance
    [~,I] = sort(v,'descend');
    conductance = zeros(1,length(I));
    for k = 1 : length(I)
        conductance(k) = getConductance(sampleGraph,I(1:k));
    end
    
    % sweep cut by global minimal conductance
    [Cond,ind] = min(conductance);
    detectedCommunity = I(1:ind);
    realDetectedCommunity = set(detectedCommunity);
    Alltime = [Alltime,toc(tmark)];
    detectedComm = [detectedComm,realDetectedCommunity'];

    Conductance = [Conductance,Cond];   
    detectedSize = [detectedSize,length(detectedCommunity)];

    if(n4 < 1)
        break;
    end

    % delete seeds which have at least 3 or 75% common nodes
    index = [];

    for j = 1 : n4
        if length(intersect(c4{j},seeds)) >= 3  % or length(intersect(c4{l},seeds))/length(seeds) >= 0.75
            index = [index,j];
        end
    end

    seedsNum(index) = [];
    c4(index) = [];
    n4 = n4 - length(index);
end

% compute Jaccard index and F1 score
F1 = GetF1score(detectedComm,truthComm);

dlmwrite(saveName,'F1, Conductance, CommNum, CommSize, Alltime','delimiter','');
dlmwrite(saveName,[F1,mean(Conductance),mark,mean(detectedSize),sum(Alltime)],'precision','%.3f','-append','roffset',1,'delimiter','\t');
