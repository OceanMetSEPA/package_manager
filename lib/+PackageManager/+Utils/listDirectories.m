function [ list ] = listDirectories(p)

    dirContents  = dir(p);
    directoriesOnly = dirContents([dirContents.isdir] & ...
        cellfun(@(x) ~isequal(x,'.'), {dirContents.name}) & ...
        cellfun(@(x) ~isequal(x,'..'), {dirContents.name}));
    
    list = {directoriesOnly.name};
end

