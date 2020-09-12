function []=parallelQOCE(k0, alpha)
% parallel QOCE algorithm
parpool(20)

% superparameter
gap = 5;

tic

if nargin < 2
    k0 = 3;
    alpha = 0.2;
end

% data files
dataPath = '../../Data/Datasets/';
savePath = '../Results/';
dataNames = {'TerroristRel'};
% dataNames = {'Amazon', 'dblp'};
% dataNames = {'zachary','footballTSE','polbooks','polblogs','citeseer','cora','cornell','texas','washington','wisconsin','TerrorAttack','TerroristRel'};
% dataNames = {'LFR_s_0.1_2', 'LFR_s_0.1_3', 'LFR_s_0.1_4', 'LFR_s_0.1_5', 'LFR_s_0.1_6', 'LFR_s_0.1_7', 'LFR_s_0.1_8','LFR_s_0.5_2', 'LFR_s_0.5_3', 'LFR_s_0.5_4', 'LFR_s_0.5_5', 'LFR_s_0.5_6', 'LFR_s_0.5_7', 'LFR_s_0.5_8', 'LFR_b_0.1_2', 'LFR_b_0.1_3', 'LFR_b_0.1_4', 'LFR_b_0.1_5', 'LFR_b_0.1_6', 'LFR_b_0.1_7', 'LFR_b_0.1_8', 'LFR_b_0.5_2', 'LFR_b_0.5_3', 'LFR_b_0.5_4', 'LFR_b_0.5_5', 'LFR_b_0.5_6', 'LFR_b_0.5_7', 'LFR_b_0.5_8'};

resultsName = [savePath, 'Results_part'];
fid = fopen(resultsName, 'w');
fprintf(fid, "Dataset\tF1\tNMI\tConductance\tModularity\tCommNum\tCommSize\tTime\n");

for d = 1 : length(dataNames)
% for d = 1 : 1
    % start clock
    % tmark = tic;
    dataName = dataNames{d};
    % graphName = [dataPath, dataName];
    % truthName = [dataPath, dataName, '.txt'];
    graphName = [dataPath, dataName, '_LCC'];
    truthName = [dataPath, dataName, 'Conn3.txt'];
    seedsName = [savePath, dataName, '/seeds_4.txt'];
    % saveSeeds = [savePath, dataName, '/seeds_5.txt'];
    interName = [savePath, dataName, '/comms'];
    % tmpName = [savePath, dataName, '/global_conds'];
    
    % load graph
    graph = loadGraph(graphName);
    % load truth communities
    truthComm = loadCommunities(truthName);
    % load seeds
    seeds = loadCommunities(seedsName);
    seedsNum = zeros(length(seeds),1);
    for i = 1: length(seeds)
        seedsNum(i) = length(seeds{i});
    end

    sortedSeeds = sortSeeds(seeds, seedsNum);
    % sortedSeeds = seeds;

    % start clock
    tmark = tic;
    detectedComm = cell(1, length(sortedSeeds));
    Conductance = zeros(1, length(sortedSeeds));
    Modularity = zeros(1, length(sortedSeeds));
    detectedSize = zeros(1, length(sortedSeeds));
    tmpCond = cell(1, length(sortedSeeds));

    parfor i = 1: length(sortedSeeds)
        if rem(i, 1000) == 0
            fprintf("detected %d communities\n", i);
        end

        seed = sortedSeeds{i};

        % sample graph by fast random walk
        prob = fast_rw(graph, seed, k0);
        set = find(prob);
        set = union(seed, set, 'stable');
        sampleGraph = graph(set, set);
        [~,seedsId] = intersect(set, seed);

        % sample an bigger graph by fast random walk by k0+1 steps
        % prob_ = fast_rw(graph, seed, k0+1);
        % set_ = find(prob_);
        % set_ = union(seed, set_, 'stable');
        % sampleGraph_ = graph(set_, set_);

        % quadratic programming
        L = diag(sum(sampleGraph)) - sampleGraph;
        v = quad_prog(L, seedsId, alpha);
        if(isempty(v))
            continue;
        end

        % compute conductance and modularity
        [~, I] = sort(v, 'descend');
        % I = set(I);
        % [~, Ind] = sort(v,'descend');
        % seq = set(Ind);
        % I = ismember(seq, set_);
        % I(I==0) = [];

        % for k = 1:length(I)
        %     modularity(k) = getModularity(sampleGraph_, I(1:k));
        % end

        % conductance = zeros(1,length(I));
        % for k = 1 : length(I)
        %     conductance(k) = getConductance(sampleGraph_,I(1:k));
        % end
        % tmpCond{i} = conductance;

        % compute local optimal conductance
        conductance = zeros(1, length(I));
        for k = 1:gap
            % conductance(k) = getConductance(graph, I(1:k));
            conductance(k) = getConductance(sampleGraph, I(1:k));
        end

        ind = length(I) - gap;
        Cond = conductance(ind);
        for k = 1 : (length(I)-gap)
            % conductance(k+gap) = getConductance(graph, I(1:k+gap));
            conductance(k+gap) = getConductance(sampleGraph, I(1:k+gap));

            flag = true;
            for j = 1:gap
                if conductance(k) > conductance(k+j)
                    flag = false;
                    break;
                end
            end

            if flag
                ind = k;
                Cond = conductance(k);
                break;
            end
        end

        % tmpCond{i} = conductance;

        % sweep cut by global minimal conductance
        % [Cond,ind] = min(conductance);
        detectedCommunity = I(1:ind);
        % realDetectedCommunity = detectedCommunity;
        realDetectedCommunity = set(detectedCommunity);       
        detectedComm{i} = realDetectedCommunity';
        Modularity(i) = getModularity(graph, realDetectedCommunity);
        Conductance(i) = Cond;
        detectedSize(i) = length(detectedCommunity);
    end
    % clean communities
    % [finalComm, finalSize, finalCond] = cleanComms(detectedComm, detectedSize ,Conductance);

    % record clock
    time = toc(tmark);
    
    saveCommunities(interName, detectedComm);
    % compute Jaccard index and F1 score
    F1 = GetF1score(detectedComm, truthComm);
    NMI = GetCoverNMI(detectedComm, truthComm);
    fprintf(fid, "%s\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n", dataName, F1, NMI, mean(Conductance), sum(Modularity), length(detectedComm), mean(detectedSize), time);
    % saveCommunities(interName, detectedComm);
    % saveCommunities(tmpName, tmpCond);
%     dlmwrite(resultsName, [dataName, F1, mean(Conductance), length(detectedComm), mean(detectedSize), time], 'precision', '%.3f', '-append', 'roffset', 1, 'delimiter', '\t');
%     dlmwrite(saveName, [F1, mean(Conductance), mark, mean(detectedSize), sum(Alltime)], 'precision', '%.3f', '-append', 'roffset', 1, 'delimiter', '\t');
end

fclose(fid);
delete(gcp('nocreate'))
