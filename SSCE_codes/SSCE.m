function [] = SSCE(steps,s,d,alpha)
% test dataset for SSCE algorithm

% steps is the steps of random walk for sampling
% s is steps of random walk or iteration for subspace
% d is dimension of the subspace;
% alpha: a parameter control local minimal conductance;

steps = 4;
s = 4;
d = 2;
alpha = 1.9;

graphName = '../example/Citeseer/graph.pairs';

truthName = '../example/Citeseer/community.txt'; 

seedsName = '../example/Citeseer/seeds.txt';

saveName = '../example/Citeseer/results.txt'; 

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

sampletime = [];
samplesize = [];
detectedComm = {};
Conductance = [];
detectedSize = [];
mark = 0;

t = clock;
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

    % sample graph
    sampledGraph = [];
    sampledSeed = [];
    tic;
    [sampledGraph,I] = sampleGraph(graph, seeds, steps);
    sampletime = [sampletime,toc];
    samplesize = [samplesize,length(I)];
    [~,ind] = intersect(I,seeds);
    sampledSeed = ind;

    % detect community
    [detectedCommunity,Cond]  = Cond_localmin(sampledGraph, sampledSeed, d, s, alpha);
    
    if isempty(detectedCommunity)
        continue;
    end

    Conductance = [Conductance,Cond];   
    detectedSize = [detectedSize,length(detectedCommunity)];
    realDetectedCommunity = I(detectedCommunity);
    detectedComm = [detectedComm,realDetectedCommunity];

    if (n4 < 1)
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

Alltime = etime(clock,t);

% compute Jaccard index and F1 score
[truthF1,detectedF1,F1] = GetF1score(detectedComm,truthComm);
NMI = GetCoverNMI(detectedComm,truthComm);

dlmwrite(saveName,'F1, NMI, Sampletime, Samplesize, Conductance, CommNum, CommSize, Alltime','delimiter','');
dlmwrite(saveName,[F1,NMI,mean(sampletime),mean(samplesize),mean(Conductance),mark,mean(detectedSize),Alltime],'precision','%.3f','-append','roffset',1,'delimiter','\t');
