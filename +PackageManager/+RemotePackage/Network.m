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
            dp = N.path;
        end
        
        function download(N)
            if ~exist(N.installPath, 'dir')
                N.makeInstallDir;
            end
            
            if exist(N.path, 'file')
                [~, fileName, ext] = fileparts(N.path);
                copyfile(N.path, [N.installPath, '\', fileName, ext], 'f');
            else
                copyfile(N.path, N.installPath, 'f');
            end            
        end
        

%                    
% 
% 
% 
%                     
    end
    
end

