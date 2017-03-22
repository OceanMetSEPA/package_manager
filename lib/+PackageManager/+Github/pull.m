function [ output_args ] = pull(username, repository)
   
    originalDir = pwd;
    
    urlParts = { ...
        PackageManager.RemotePackage.Github.RootURL, ...
        username, ...
        repository, ...
    };

    developmentPath = [PackageManager.Install.rootPath, '\', repository, '\versions\dev'];
    
    if exist([developmentPath, '\', repository])
        cd([developmentPath, '\', repository]);
        git('pull origin master');
    else
        mkdir(developmentPath);
        cd(developmentPath);

        git('clone', [strjoin(urlParts, '/'), '.git']);
    end
    
    cd(originalDir);
end

