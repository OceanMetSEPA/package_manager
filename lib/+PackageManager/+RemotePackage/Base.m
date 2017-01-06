classdef Base < dynamicprops
        
    properties
        name = '';
        source = '';
        installation = struct('tag', '', 'path', '');
        zipCheckSum = '';
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
             
            subklass = PackageManager.RemotePackage.(subklassName);
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

                if isempty(B.installation.tag)
                    
                    subclassVersionProperty = eval([class(B) '.SubclassVersionProperty']);
                    
                    if ~isempty(subclassVersionProperty) && ~isempty(B.(subclassVersionProperty))
                        B.installation.tag = B.(subclassVersionProperty);
                    else
                        B.installation.tag = B.timestamp;
                    end
                end
                                
                B.installation.path = [ip, B.installation.tag];
            end
        end
        
        function clearInstallPath(B)
            B.installation.path = '';
        end
        
        function makeInstallDir(B)
            if ~exist(B.installPath, 'dir')
                mkdir(B.installPath);
            end
        end
        
        function bool = isZipArchive(B)
            [~, ~, ext] = fileparts(B.downloadPath);
            bool = isequal(ext, '.zip');
        end
        
        function ts = timestamp(B)
            ts = datestr(now, 'yyyymmddHHMMSS');
        end
        
        function install(B, varargin)
            recurse       = 0;
            switchVersion = 1;
            checkCheckSum = 1;
            
            for i = 1:2:length(varargin)
              switch varargin{i}
                case 'recurse'
                  recurse = varargin{i+1};
                case 'switchVersion'
                  switchVersion = varargin{i+1};
                case 'checkCheckSum'
                  checkCheckSum = varargin{i+1};
              end
            end
            
            if nargin > 0 
                B.clearInstallPath;
                B.installPath(varargin{:});
            end
            B.makeInstallDir;
            B.download;
            
            % Get the checksum hash for the downloaded zip file.
            try
                B.zipCheckSum = DataHash(B.downloadPath, struct('Input', 'file', 'Method', 'MD5', 'Format', 'hex'));
            catch err
                if ~isequal(err.identifier, 'MATLAB:UndefinedFunction')
                    disp(err)
                    rethrow(err)
                end
                B.zipCheckSum = 'NotAvailable';
            end
            
            % If checkCheckSum is set, then see if the newly downloaded
            % version is the same as any previously downloaded versions of
            % the package, by checking their zipCheckSum properties.
            GotIdentical = 0;
            if checkCheckSum
                Package = PackageManager.Package(B.name);
                availableVersions = Package.availableVersions;
                if numel(availableVersions)
                    % Make the current version the first to be tested, and then
                    % more recent ones after that.
                    [~, Ci] = ismember(Package.currentVersion, availableVersions);
                    Order = unique([Ci, fliplr(1:numel(availableVersions))], 'stable');
                    availableVersions = availableVersions(Order);
                end
                % Now go through each of the availableVersions and see if
                % the zipCheckSum is identical.
                for aVi = 1:numel(availableVersions)
                    aV = availableVersions{aVi};
                    vDetails = PackageManager.Utils.readLogFile(B.name, aV);
                    if ~isequal(vDetails, 0)
                        if isfield(vDetails, 'zipCheckSum') & isequal(B.zipCheckSum, vDetails.zipCheckSum)
                            % An equal checkSum, so an identical zip file
                            % has previously been downloaded.
                            GotIdentical = 1;
                            IdenticalVersion = aV;
                            break
                        end
                    end
                end
            end     
            
            if B.isZipArchive
                if ~GotIdentical
                    fprintf('Unzipping files for package ''%s''.\n', B.name)
                    unzip(B.downloadPath, B.installPath);
                else
                    fprintf('An identical copy of requested package ''%s'' has already been installed.\n', B.name)
                end
                delete(B.downloadPath);
            end
            
            if recurse
                dependencies = 0;
                
                % check for dependency file in install location
                dependencyFileName = [B.installPath, '\dependencies'];
                
                if exist(dependencyFileName, 'file')
                    dependencies = 1;
                else
                    % if it is a github install then there will always be
                    % an additional directory layer, look in there
                    installContents = dir(B.installPath);
                    
                    % only if there is a single directory only (no other
                    % dirs or files)
                    % the 3rd entry omits the '.'  and '..' entries
                    if length(installContents) == 3 && installContents(3).isdir
                        dependencyFileName = [B.installPath, '\', installContents(3).name, '\dependencies'];
                        
                        if exist(dependencyFileName, 'file')
                            dependencies = 1;
                        end
                    end
                end
                
                if dependencies
                    dependencyList = PackageManager.RemotePackage.List(dependencyFileName);
                    dependencyList.installAll('recurse',1);
                end
            end
            if GotIdentical
                % Delete the install path, if it's empty.
                if numel(dir(B.installPath)) <= 2
                    % It will contain "." and ".." even if it's empty.
                    rmdir(B.installPath)
                end
                
                if switchVersion
                    installedPackage = PackageManager.Package(B.name);
                    installedPackage.setVersion(IdenticalVersion);
                end
            else
                % Add package parent folder to path to ensure discoverable
                % when setting and switching versions
                addpath([PackageManager.Install.rootPath, '\', B.name]);
            
                B.writeInstallInfoToFile(B.installPath);
            
                if switchVersion
                    installedPackage = PackageManager.Package(B.name);
                    installedPackage.setVersion(B.installation.tag);
                end
            end
        end
        
        function s = toString(B)
            
            function writePropertyStructToCell(propertyVector, value)
                
                if ischar(propertyVector)
                    propertyVector = {propertyVector};
                end
                
                if ischar(value)
                    value = strrep(value, '\', '\\');
                end
                
                if isequal(class(value), 'struct')
                    fn = fieldnames(value);
                    
                    for n = 1:length(fn)
                       propertyVector(end+1) = fn(n);                       
                       nextValue = strjoin( ...
                           cellfun(@(x) sprintf('(''%s'')', x), propertyVector, 'UniformOutput', 0), ...
                           '.');
                       
                       writePropertyStructToCell(propertyVector, eval(sprintf('B.%s', nextValue)));
                       propertyVector(end) = [];
                    end
                else
                    lineString = [strjoin(propertyVector, '.'), '=', strtrim(value)];
                    strings{i} = [lineString, '\n'];
                end
            end
            
            m = metaclass(B);
            allProperties = properties(B);
            
            strings = [];            
            
            for i = 1:length(allProperties)
                writePropertyStructToCell(allProperties{i}, B.(allProperties{i}));
            end
            
            s = strjoin(strings, '');
        end
        
        function sizeInBytes = toFile(B, filePath, varargin)
            
            header = '';
            
            for i = 1:2:length(varargin)
              switch varargin{i}
                case 'header'
                  header = varargin{i+1};
              end
            end
            
            str = B.toString;
            
            fid = fopen(filePath, 'w');
            
            if ~isempty(header)
                for r = 1:size(header,1)
                    fprintf(fid, '# %s \n', header{r});
                end
            end
            
            fprintf(fid, '\n');
            fprintf(fid, str);
          
            fclose(fid);
            
            fileInfo    = dir(filePath);
            sizeInBytes = fileInfo.bytes;
        end
        
        function sizeInBytes = writeInstallInfoToFile(B, installPath)
            filePath = [installPath, '\package_manager_install.log'];
            
            header = {};
            header{1} = ['Package installed on ', datestr(now)];
            
            sizeInBytes = B.toFile(filePath, 'header', header);
        end
        
              
    end
    
end

