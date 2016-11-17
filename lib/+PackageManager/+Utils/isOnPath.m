function [ bool ] = isOnPath(p)    
    bool = any(cellfun(@(x) isequal(x, p), strsplit(path, ';')));
end

