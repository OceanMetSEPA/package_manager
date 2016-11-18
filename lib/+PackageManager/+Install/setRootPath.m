function [ bool ] = setRootPath(rootPath)
    setenv(PackageManager.Constants.InstallRootEnvVar, rootPath);
    
    if ~exist(rootPath)
        mkdir(rootPath)
    end
end

