function prob = fast_rw(graph,seeds,steps)
% seeds expansion by fast random walk

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
graph = spdiags(ones(n,1),0,n,n) + graph; % light lazy, add selfloop for large graph
prob = zeros(n,1);
% prob(seeds) = 1/length(seeds);
prob(seeds) = degrees(seeds)/sum(degrees(seeds));
prob = sparse(prob);

for i = 1 : steps
    [set,vec] = rwvec_mex(graph,prob);
    sparse_vec = sparse(set,1,vec,n,1);
    prob = graph*sparse_vec;
end

end
