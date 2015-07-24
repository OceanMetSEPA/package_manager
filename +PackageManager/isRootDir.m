function [ bool ] = isRootDir(p)
    %ISROOTDIR Summary of this function goes here
    %   Detailed explanation goes here
    
    directoryNames = PackageManager.listDirectories(p);
    
    bool = 0;
    if any(cellfun(@(x) PackageManager.isVersionDir(x), directoryNames))
        bool = 1;
    end
end

