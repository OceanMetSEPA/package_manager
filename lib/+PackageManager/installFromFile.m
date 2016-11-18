function installFromFile(filePath, varargin)
    packageList = PackageManager.RemotePackage.List(filePath);
    packageList.installAll(varargin{:});
end

