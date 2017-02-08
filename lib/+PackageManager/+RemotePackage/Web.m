classdef Web < PackageManager.RemotePackage.Base
        
    properties (Constant = true)
        SubclassVersionProperty = '';
    end
    
    properties
        url = '';
    end
    
    methods
        
        function dp = downloadPath(B)
            dp = [B.installPath, '\', B.name, '.zip'];
        end
        
        function download(B)
            if ~exist(B.installPath, 'dir')
                B.makeInstallDir;
            end
            
            urlwrite(B.url, B.downloadPath);
        end
        
    end
    
end

