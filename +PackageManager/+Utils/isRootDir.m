function [ bool ] = isRootDir(p)

    directoryNames = PackageManager.Utils.listDirectories(p);

    bool = 0;
    if any(cellfun(@(x) isequal(x, 'versions'), directoryNames))
        bool = 1;
    end
end
