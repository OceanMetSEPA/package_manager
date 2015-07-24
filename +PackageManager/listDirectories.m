function [ list ] = listDirectories(p)
    %LISTDIRECTORIES Summary of this function goes here
    %   Detailed explanation goes here

    dirContents  = dir(p);
    directoriesOnly = dirContents([dirContents.isdir] & ...
        cellfun(@(x) ~isequal(x,'.'), {dirContents.name}) & ...
        cellfun(@(x) ~isequal(x,'..'), {dirContents.name}));
    
    list = {directoriesOnly.name};
end

