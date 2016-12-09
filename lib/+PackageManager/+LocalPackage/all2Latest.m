function [ output_args ] = all2Latest()
    list = PackageManager.LocalPackage.list;

    for e = 1:length(list)
        package = PackageManager.Package(list{e});
        package.setVersion(package.versions.latest.string);
    end

end

