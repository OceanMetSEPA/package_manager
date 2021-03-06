classdef FileExchange < PackageManager.RemotePackage.Base
        
    properties (Constant = true)
        RootURL = 'https://uk.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions';
        SubclassVersionProperty = 'version';
    end
    
    properties
        id      = '';
        version = '';
    end
    
    methods
        
        function s = sourceURL(FE)
            % Example
            %
            %   https://uk.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/31272/versions/10/download/zip
            %

            urlParts = { ...
                PackageManager.RemotePackage.FileExchange.RootURL, ...
                FE.id, ...
                'versions', ...
                FE.version, ...
                'download/zip' ...
            };
        
            s = strjoin(urlParts, '/');
        end
        
        function dp = downloadPath(B)
            dp = [B.installPath, '\', B.name, '.zip'];
        end
        
        function download(B)
            if ~exist(B.installPath, 'dir')
                B.makeInstallDir;
            end
            B.sourceURL
            urlwrite(B.sourceURL, B.downloadPath);
        end
        
    end
    
end

