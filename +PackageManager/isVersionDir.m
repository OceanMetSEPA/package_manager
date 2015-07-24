function [bool, version] = isVersionDir(pathOrName)
    % ISVERSIONDIR Summary of this function goes here
    % Detailed explanation goes here
    
    bool    = 0;
    version = NaN;
    
    % pass the argument through fileparts. This way either the directory
    % name or the full path can be used.
    [~, dirName, ~] = fileparts(pathOrName); 
    
    [b, t] = regexp(dirName, '^v(\d+.?\d?)$', 'match', 'tokens');

    if ~isempty(b)
        bool    = 1;
        version = t{1}{1};
    end
end

