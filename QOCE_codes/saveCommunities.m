function comm = saveCommunities(filename, comms)
% comms: a cell, each element is a vector of the vertexId in one community
% fileformat: each row is a community

fid = fopen(filename,'w');

for i = 1:length(comms)
    comm = comms{i};
    fprintf(fid, '%d ', comm(:));
    fprintf(fid, '\n');
end

fclose(fid);

end
