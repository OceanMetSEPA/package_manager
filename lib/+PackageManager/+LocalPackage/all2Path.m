function [ output_args ] = all2Path
    list = PackageManager.LocalPackage.list;

    addpath(PackageManager.Install.rootPath);

    for e = 1:length(list)
        addpath([PackageManager.Install.rootPath, '\', list{e}]);
    end
end

