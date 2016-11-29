function [ S ] = readLogFile( packageName, version )
    %READLOGFILE Summary of this function goes here
    %   Detailed explanation goes here

    package = PackageManager.Package(packageName);
    versionPath = package.versionPath(version);
    logFile = [versionPath, '\package_manager_install.log'];
    if exist(logFile, 'file') == 2
        S = struct;
        F = fopen(logFile, 'r');
        fline = fgetl(F);
        while ischar(fline)
            if strfind(fline, '=')
                fline = strsplit(fline, '=');
                name = fline{1};
                value = fline{2};
                name = strrep(name, '.', '_');
                S.(name) = value;
            end
            fline = fgetl(F);
        end
        fclose(F);
    else
        S = 0;
    end
end

