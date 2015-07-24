function [ versionList ] = availableVersions(package)
    %VERSIONS Summary of this function goes here
    %   Detailed explanation goes here
    
    versionList = {};
    
    directoryNames = PackageManager.listDirectories(PackageManager.rootPath(package));
            
    for i = 1:length(directoryNames)
        [b, v] = PackageManager.isVersionDir(directoryNames{i});
        if ~isempty(b)
            versionList{end+1} = v;
        end
    end
end

