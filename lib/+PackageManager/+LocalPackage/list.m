function l = list()

    l = [];
    
    if exist(PackageManager.Install.rootPath, 'dir')
        contents    = dir(PackageManager.Install.rootPath);
        directories = cell2mat({contents.isdir});
        dirNames    = {contents(directories).name};
        
        isDotDir = @(str) isequal(str,'.')|isequal(str,'..');
        
        ignoreDirs  = cellfun(@(x) isDotDir(x),dirNames);
        
        l = dirNames(~ignoreDirs);
    else
        warning(['PackageManager install path - ', PackageManager.Install.rootPath,' - does not exist'])
    end
end

