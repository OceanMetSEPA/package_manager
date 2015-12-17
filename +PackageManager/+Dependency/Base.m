classdef Base < dynamicprops
        
    properties
        name = '';
        source = '';
        installation = struct('tag', '', 'path', '');
    end
    
    methods (Static = true)
        
        function subklass = toSubclass(base)
            switch base.source
                case 'github'
                    subklassName = 'Github';
                case 'fileExchange'
                    subklassName = 'FileExchange';
                case 'network'
                    subklassName = 'Network';
            end
             
            subklass = PackageManager.Dependency.(subklassName);
            propertyNames = properties(base);
                        
            for pn = 1:length(propertyNames)
                propertyName = propertyNames{pn};
                
                if ~isprop(subklass, propertyName)
                    addprop(subklass, propertyName);
                end
                
                subklass.(propertyName) = base.(propertyName);
            end
        end
        
    end
    
    methods
        
        function addProperty(B, keys, value)            
            if ischar(keys)
                keyString = strtrim(keys);
                [keys, ~] = strsplit(keyString, '.');
            else
                keyString = strjoin(keys, '.');
            end

            if ischar(keys)
               topLevelProperty = keys
            else
               topLevelProperty = keys{1};
            end

            if ~isprop(B, topLevelProperty)
               addprop(B, topLevelProperty);
            end

            if length(keys) > 1
               if isempty(B.(topLevelProperty))
                   B.(topLevelProperty) = struct;
               end

               cmd = sprintf('B.%s = value', keyString);
               evalc(cmd); 
            else
               B.(topLevelProperty) = value;
            end;
        end
        
        function ip = installPath(B, varargin)
            
            if ~isempty(B.installation.path)
                ip = B.installation.path;
            else
                rootPath = PackageManager.Install.rootPath;
            
                for i = 1:2:length(varargin)
                  switch varargin{i}
                    case 'rootPath'
                      rootPath = varargin{i+1};
                  end
                end
                
                ip = [rootPath, '\', B.name, '\versions\'];

                if ~isempty(B.installation.tag)
                    ip = [ip, B.installation.tag];
                else
                    subclassVersionProperty = eval([class(B) '.SubclassVersionProperty']);
                    
                    if ~isempty(subclassVersionProperty) && ~isempty(B.(subclassVersionProperty))
                        ip = [ip, B.(subclassVersionProperty)];
                    else
                        ip = [ip, B.timestamp];
                    end
                end
                
                ip = [ip, '\', B.name];
                
                B.installation.path = ip;
            end
        end
        
        function clearInstallPath(B)
            B.installation.path = '';
        end
        
        function makeInstallDir(B)
            if exist(B.installPath, 'dir')
                delete(B.installPath)
            end
            
            mkdir(B.installPath)
        end
        
        function bool = isZipArchive(B)
            [~, ~, ext] = fileparts(B.downloadPath);
            bool = isequal(ext, '.zip');
        end
        
        function ts = timestamp(B)
            ts = datestr(now, 'yyyymmddHHMMSS');
        end
        
        function install(B, varargin)
            if nargin > 0 
                B.clearInstallPath;
                B.installPath(varargin{:});
            end
            
            B.makeInstallDir;
            B.download;
            
            if B.isZipArchive
                unzip(B.downloadPath, B.installPath);
                delete(B.downloadPath);  
            end
            
            addpath(genpath(B.installPath));
            % make aduit file
        end
        
              
    end
    
end

