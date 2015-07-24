function setVersion(package, requiredVersion)
    %VERSION Summary of this function goes here
    %   Detailed explanation goes here
  
    availableVersions = PackageManager.availableVersions(package);

    if ~any(cellfun(@(x) isequal(x, requiredVersion), availableVersions))
        disp('Specified version not available. Using latest version.');
        
        requiredVersion = num2str(max(cellfun(@(x) str2num(x), availableVersions)));
    end
    
    for v = 1:length(availableVersions)
        
        versionPath = [PackageManager.rootPath(package), '\v', availableVersions{v}];

        if isequal(availableVersions{v}, requiredVersion) 
            if ~PackageManager.isOnPath(versionPath)
                addpath(genpath(versionPath));
            end
        else
            if PackageManager.isOnPath(versionPath)
                rmpath(genpath(versionPath));
            end
        end
    end
    
end