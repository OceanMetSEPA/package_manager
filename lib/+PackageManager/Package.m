classdef Package < handle
    
    properties
        name = '';
        rootPath = '';
        versions@PackageManager.Version.List;
    end
    
    methods (Static = true)
    end
    
    methods
        
        function P = Package(name)
            P.name = name;
        end
        
        function p = get.rootPath(P)
    
            if isempty(P.rootPath)
                p = '';

                packageResults = what(P.name);
                packagePaths = {packageResults.path};
                rootPaths = packagePaths(logical(cellfun(@(x) PackageManager.Utils.isRootDir(x), packagePaths)));
                versionPaths = packagePaths(logical(cellfun(@(x) PackageManager.Utils.isVersionDir(x), packagePaths)));

                for i = 1:length(versionPaths)
                    paths = strsplit(versionPaths{i}, '\');
                    rootPaths{end+1} = strjoin(paths(1:end-3), '\');
                end
                
                rootPaths = unique(rootPaths);
                
                if isempty(rootPaths)
                    disp(['No directories found with name ', P.name, ' containing versioned libraries.']);
                else
                    if length(rootPaths) > 1
                        disp(['Multiple directories found with name ', P.name, ' containing versioned libraries.']);
                        cellfun(@disp, rootPaths);
                    else
                        p = rootPaths{1};      
                    end
                end
                
                P.rootPath = p;
            else
                p = P.rootPath;
            end            
        end
        
        function v = get.versions(P)
             dirs = PackageManager.Utils.listDirectories(P.versionsPath);
             v = PackageManager.Version.List(dirs);
             v.package = P;
        end
        
        function p = versionsPath(P)
            p = [P.rootPath, '\versions'];
        end
        
        function p = versionPath(P, version)
             p = [P.versionsPath, '\', version];
        end
        
        function versionList = availableVersions(P)
            versionList = P.versions.names;
        end
        
        function version = currentVersion(P)

            version = NaN;

            availableVersions = P.availableVersions;
            versionsOnPath = [];

            for v = 1:length(availableVersions)

                versionPath = [P.versionsPath, '\', availableVersions{v}];

                if PackageManager.Utils.isOnPath(versionPath)
                    versionsOnPath(end+1) = v;
                end
            end

            if isempty(versionsOnPath)
                disp('No version on path. Use PackageManager.setVersion to specify which version to use.')
            elseif length(versionsOnPath) > 1
                disp('Multiple versions on path. Use PackageManager.setVersion to specify which version to use.')
            else
                version = availableVersions(versionsOnPath);
            end
        end
        
        function setVersion(P, requiredVersion)
            availableVersions = P.availableVersions;

            if ~any(cellfun(@(x) isequal(x, requiredVersion), availableVersions))
                disp('Specified version not available. Using latest version.');

                requiredVersion = num2str(max(cell2mat(cellfun(@(x) str2num(x), availableVersions, 'UniformOutput', 0))));
            end

            for v = 1:length(availableVersions)

                versionPath = P.versionPath(availableVersions{v});

                if isequal(availableVersions{v}, requiredVersion) 
                    if ~PackageManager.Utils.isOnPath(versionPath)
                        addpath(genpath(versionPath));
                    end
                else
                    if PackageManager.Utils.isOnPath(versionPath)
                        rmpath(genpath(versionPath));
                    end
                end
            end

        end
        
        function [ bool ] = removeVersion(P, version)
            bool = 0;
            packageVersionPath = P.versionPath(version)

            if exist(packageVersionPath, 'dir')
                bool = rmdir(packageVersionPath,'s');
            end
        end
        
        function setDev(P)
            P.setVersion('dev');
        end
        
    end
    
end

