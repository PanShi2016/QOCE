function [detectCommunity,Cond] = Cond_localmin(graph,startPoints,d,k,alpha)
% use local minimal conductance to bound the community size

n = length(graph);
conductance = zeros(1,n);

% approximate local spectral subspace
p = zeros(1,n);
p(startPoints) = 1/length(startPoints);
V = Walk_Nrw(graph,p,d,k);

% get sparse vector by linear programming
v = pos1norm(V,startPoints);

% deal with null results
if length(v) == 0
    detectCommunity = [];
    Cond = [];
    return;
end

% compute conductance
[w,I] = sort(v,'descend');

for i = 1 : n
    conductance(i) = getConductance(graph,I(1:i));
end

% compute first local minimal conductance
[~,I2] = intersect(I,startPoints);
startId = max(I2);
index = GetLocalCond_mex(conductance,startId,alpha);
detectCommunity = I(1:index);
Cond = conductance(index);
