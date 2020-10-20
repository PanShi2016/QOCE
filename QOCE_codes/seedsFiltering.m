function seeds = seedsFiltering(cliques)
% sort and clean

% sort seeds by number of vertex
cliquesLen = zeros(length(cliques), 1);
for i = 1 : length(cliques)
    cliquesLen(i) = length(cliques{i});
end

[~, ind] = sort(cliquesLen, 'descend');
sortedCliques = cliques(ind);

% delete seeds which have at least 3 or 75% common nodes
i = 1;
while i <= length(sortedCliques)-1
    if  rem(i, 100) == 0
       fprintf("cleaned %d seeds\n", i);
    end
    
    seed = sortedCliques{i};
    
    j = i + 1;
    while j <= length(sortedCliques)
        if length(intersect(sortedCliques{j},seed))/length(sortedCliques{j}) >= 0.75
            sortedCliques(j) = [];
        else
            j = j + 1;
        end
    end
    i = i+1;
end

seeds = sortedCliques;
end