function V = Walk_Nrw(graph,p,k,steps)
% Approximate local spectral subspace by subspace iteration
% p is initial probability vector 
% k is the dimension of the subspace
% steps is the number of iteration steps
% return the k vectors in columns

if nargin < 1
    % two overlapping cliques of size 5
    A = zeros(8,8);
    A(1:6,1:6) = 1;
    A(5:8,5:8) = 1;
    graph = A - diag(diag(A));
    graph = sparse(graph);
    % start from vertex 1
    p = [1 0 0 0 0 0 0 0];
    k = 2; % dimension of the subspace    
    steps = 4;
end

n = length(graph);
% graph = sparse(eye(n) + graph); % light lazy, add selfloop
graph = spdiags(ones(n,1),0,n,n) + graph; % light lazy, add selfloop for large graph
graph = NormalizedGraph(graph); 
V = zeros(steps+1,n);
V(1,:) = p;

for i = 1 : steps
    V(i+1,:) = V(i,:)*graph'; 
end

V = V(steps-k+2:end,:);
V = orth(V');
end
