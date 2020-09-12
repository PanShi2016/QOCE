function sortedSeeds = sortSeeds(seeds, seedsNum)
% sort and clean

% sort seeds by number of vertex
[~, ind] = sort(seedsNum, 'descend');
sortedSeeds = seeds(ind);

% delete seeds which have at least 3 or 75% common nodes
i = 1;
while i <= length(sortedSeeds)-1
    if  rem(i, 100) == 0
       fprintf("cleaned %d seeds\n", i);
    end
    
    seed = sortedSeeds{i};
    
    j = i + 1;
    while j <= length(sortedSeeds)
        if length(intersect(sortedSeeds{j},seed))/length(sortedSeeds{j}) >= 0.75
            sortedSeeds(j) = [];
        else
            j = j + 1;
        end
    end
    i = i+1;
end
