function [ version ] = currentVersion(package)
    %CURRENTVERSION Summary of this function goes here
    %   Detailed explanation goes here
    
    version = NaN;
    
    availableVersions = PackageManager.availableVersions(package);
    versionsOnPath = [];
    
    for v = 1:length(availableVersions)
        
        versionPath = [PackageManager.rootPath(package), '\v', availableVersions{v}];
        
        if PackageManager.isOnPath(versionPath)
            versionsOnPath(end+1) = v;
        end
    end
    
    if isempty(versionsOnPath)
        disp('No version on path. Use PackageManager.setVersion to specify which version to use.')
    elseif length(versionsOnPath) > 1
        disp('Multiple versions on path. Use PackageManager.setVersion to specify which version to use.')
    else
        version = availableVersions(versionsOnPath);
    end
end

