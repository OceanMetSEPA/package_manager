function [ p ] = rootPath(packageName)
    %PATH Summary of this function goes here
    %   Detailed explanation goes here
    
    p = '';
    
    packageResults = what(packageName);
    packagePaths = {packageResults.path};
    rootPaths = packagePaths(logical(cellfun(@(x) PackageManager.isRootDir(x), packagePaths)));
    
    if isempty(rootPaths)
        disp(['No directories found with name ', packageName, ' containing versioned libraries.']);
    elseif length(rootPaths) > 1
        disp(['Multiple directories found with name ', packageName, ' containing versioned libraries.']);
        cellfun(@disp, rootPaths);
    else
        p = rootPaths{1};      
    end
end

