function [ output_args ] = clone(username, repository)
   
    originalDir = pwd;
    
    urlParts = { ...
        PackageManager.RemotePackage.Github.RootURL, ...
        username, ...
        repository, ...
    };

    developmentPath = [PackageManager.Install.rootPath, '\', repository, '\versions\dev'];
    mkdir(developmentPath)
    cd(developmentPath)
    
    git('clone', [strjoin(urlParts, '/'), '.git']);
    
    cd(originalDir)
end

