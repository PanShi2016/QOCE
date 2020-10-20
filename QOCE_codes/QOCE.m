function detectedComms = QOCE(graph, cliques, nthread, t0, mu, alpha, w)
% Most procedures of QOCE, except for maximal clique enumeration.
parpool(nthread)

% start clock
tmark = tic;

seeds = seedsFiltering(cliques);
detectedComms = cell(1, length(seeds));

parfor i = 1: length(seeds)
    seed = seeds{i};

    % Sampling: sample graph by fast random walk
    prob = fast_rw(graph, seed, t0);
    set = find(prob > mu);
    set = union(seed, set, 'stable');
    sampleGraph = graph(set, set);
    [~,seedsId] = intersect(set, seed);

    % Extraction: quadratic programming
    L = diag(sum(sampleGraph)) - sampleGraph;
    v = quad_prog(L, seedsId, alpha);
    if(isempty(v))
        continue;
    end

    % Post-processing: computing local optimal conductance
    [~, I] = sort(v, 'descend');
    conductance = zeros(1, length(I));
    for k = 1:w
        conductance(k) = getConductance(sampleGraph, I(1:k));
    end

    ind = length(I) - w;
    Cond = conductance(ind);
    for k = 1 : (length(I)-w)
        conductance(k+w) = getConductance(sampleGraph, I(1:k+w));

        flag = true;
        for j = 1:w
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

    detectedCommunity = I(1:ind);
    realDetectedCommunity = set(detectedCommunity);       
    detectedComms{i} = realDetectedCommunity';
end

% record clock
time = toc(tmark);
fprintf("Time of QOCE (without maximal clqiue enumeration): %.2fs\n", time);

delete(gcp('nocreate'))
