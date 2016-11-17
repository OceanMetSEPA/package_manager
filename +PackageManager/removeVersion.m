function [ bool ] = removeVersion(name, version)
    %REMOVEVERSION Summary of this function goes here
    %   Detailed explanation goes here
    
    bool = 0;
    packageVersionPath = PackageManager.versionPath(name, version)
    
    if exist(packageVersionPath, 'dir')
        bool = rmdir(packageVersionPath,'s');
    end
end

