function [ bool ] = setRootPath(rootPath)
    setenv(PackageManager.Constants.InstallRootEnvVar, rootPath);
end

