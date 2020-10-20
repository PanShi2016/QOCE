function [] = getResults()
% get results for baseline algorithms

dataPath = '../../example/Karate/';

algorithms = {'BigClam','DEMON','NISE','DNMF'};

dataPathandName = [dataPath,'graph.pairs'];
truthPathandName = [dataPath,'community.txt'];

graph = loadGraph(dataPathandName);
truthComm = loadCommunities(truthPathandName);
Alltime = importdata([dataPath,'Total_Time.txt']);

dlmwrite([dataPath,'baseline_results.txt'],'Algorithms, F1, Conductance, CommNum, CommSize, Alltime','delimiter','');

for i = 1 : length(algorithms)
    detectedPathandName = [dataPath,algorithms{i},'.gen'];
    detectedComm = loadCommunities(detectedPathandName);
    F1 = GetF1score(detectedComm,truthComm);
    time = Alltime.data(i);
    AllCond = [];
    AllSize = [];
    for j = 1 : length(detectedComm)
        Cond = getConductance(graph,detectedComm{j});
        Cond = full(Cond);
        Size = length(detectedComm{j});
        AllCond = [AllCond,full(Cond)];
        AllSize = [AllSize,Size];
    end
    dlmwrite([dataPath,'baseline_results.txt'],[algorithms{i},'   ',num2str(F1,'%.3f'),'   ',num2str(mean(AllCond),'%.3f'),'   ',num2str(j),'   ',num2str(mean(AllSize),'%.3f'),'   ',num2str(time,'%.3f')],'-append','delimiter','');
end

end
