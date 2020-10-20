%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% newF represents the hard community membership matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = DNMFRun(filename, alpha, beta, gamma, k, IT, OT)
maxNumCompThreads(20);

% % load adjacent matrix
% A = csvread('dolphins-edgesMatrix.csv', 1, 1);
graph = load(filename);
graph_flip = [graph(:,2), graph(:,1)];
graph_combine = [graph; graph_flip];
A = sparse(graph_combine(:, 1), graph_combine(:, 2), 1);

% % initialize parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alpha = 0.5;
% beta = 0.1;
% gamma = 0.001;
% k = 5; %% number of communities to detect
% IT = 5; %% number of inner iterations
% OT = 50; %% number of outer iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = size(A, 1);
m = sum(sum(A));
threshold = m / ((n-1) * n);
threshold = sqrt(-log(1-threshold));

I = ones(n, 1);
H = eye(n) - I * I' / n;
tmpA = A' * A;
K = diag(tmpA) * I' + I * (diag(tmpA))' - 2 * tmpA;
K = exp(- 0.5 * K);
Khat = H * K * H;
S = H - (Khat + gamma * eye(n)) \ Khat;

i = 1;
para.alpha = alpha;
para.beta = beta;
para.maxiter = OT;
para.IT = IT;

for iter = 1:1
    U = rand(n, k);
%     F = ones(n, k);
    F = rand(n, k);
    Q = rand(k, k);
    Q = ProjTF(Q);
    [newF] = DNMF(A, U, F, Q, S, para);
    % modularity = computeQ(newF, A)
end

fid = fopen('DNMF.gen', 'wt');
[~, N] = size(newF);
for i = 1:N
    I = find(newF(:, i)>0);
    str = num2str(I');
    fprintf(fid, '%s\n', str);
end
fclose(fid);

