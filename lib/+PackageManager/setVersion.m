function [ v ] = setVersion(name, version)
    %SETVERSION Summary of this function goes here
    %   Detailed explanation goes here

    package = PackageManager.Package(name);
    package.setVersion(version);
    v = version;
end
