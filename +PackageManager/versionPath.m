function [ p ] = versionPath(package, version)
    %VERSIONPATH Summary of this function goes here
    %   Detailed explanation goes here
    
    packageRootPath = PackageManager.rootPath(package);
    p = [packageRootPath, '\v', version];
end

