function [subgraph,I] = sampleGraph(graph,seeds,steps)
% Sample subgraph by fast random walk

if nargin < 1
    % two overlapping cliques of size 5
    A = zeros(8,8);
    A(1:6,1:6) = 1;
    A(5:8,5:8) = 1;
    graph = A - diag(diag(A));
    graph = sparse(graph);
    % start from vertex 1
    seeds = 1;
    steps = 4;
end

n = length(graph);
degrees = sum(graph);
% graph = spdiags(ones(n,1),0,n,n) + graph; % light lazy, add selfloop for large graph
prob = zeros(1,n);
% prob(seeds) = 1/length(seeds);
prob(seeds) = degrees(seeds)/sum(degrees(seeds));

[I,num,finalprob] = RandomWalk_mex(graph,prob,seeds,steps);
I = I(1:num);

if length(I) > 3000
    [p,ind] = sort(finalprob(I),'descend');
    idx = ind(1:3000);
    I = I(idx);
    I = union(seeds,I,'stable');
end

subgraph = graph(I,I);

end
