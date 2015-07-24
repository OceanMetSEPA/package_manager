function [ bool ] = isOnPath(p)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    bool = any(cellfun(@(x) isequal(x, p), strsplit(path, ';')));
end

