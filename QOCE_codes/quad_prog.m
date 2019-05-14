function v = quad_prog(H,startPoints,alpha)
% find a sparse vector by quadratic programming
% H: Laplacian matrix
% startPoints: seed nodes
% alpha: a parameter to balance sparsity and quadratic form
   
n = length(H);
y = zeros(1,n);
y(startPoints) = 1/length(startPoints);
f = 0.5*alpha*ones(n,1);
lb = y; % yi >= 1/length(startPoints)
ub = ones(1,n);

v = quadprog(H,f,[],[],[],[],lb,[]); % default algorithm 'interior-point-convex'

end
