classdef Network < PackageManager.RemotePackage.Base
    % Do we HAVE to copy it over? 
    % What about just ensuring it is on path?
    % What about conflicts?
        
    properties (Constant = true)
        SubclassVersionProperty = '';
    end
    
    properties
        path = '';
    end
    
    methods
        
        function dp = downloadPath(N)
            dp = [N.installPath, '.zip'];
        end
        
        function download(N)
            if ~exist(N.installPath, 'dir')
                N.makeInstallDir;
            end
            
            [~, ~, ext] = fileparts(N.path);
            isZip = isequal(ext, '.zip');
            
            if isZip
                copyfile(N.path, N.downloadPath);
            else
                zip(N.downloadPath, N.path);                
            end        
        end
        
    end
    
end

