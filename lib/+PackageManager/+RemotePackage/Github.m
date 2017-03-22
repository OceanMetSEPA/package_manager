classdef Github < PackageManager.RemotePackage.Base
        
    properties (Constant = true)
        RootURL = 'https://github.com';
        DefaultArchiveName = 'master';
        SubclassVersionProperty = 'tag';
    end
    
    properties
        username   = '';
        repository = '';
        branch     = '';
        tag        = '';
        SHA        = ''
    end
    
    methods (Static = true)
        
        
    end
    
    methods
        
        function an = archiveName(G)
            an = PackageManager.RemotePackage.Github.DefaultArchiveName;

            if isprop(G, 'branch') && ~isempty(G.branch)
                an = G.branch;
            end

            if  isprop(G, 'tag') && ~isempty(G.tag)
                an = G.tag;
            end

            if  isprop(G, 'SHA') && ~isempty(G.SHA)
                an = G.SHA;
            end

            an = [an, '.zip'];
        end
        
        function r = get.repository(G)
            if isempty(G.repository)
                G.repository = G.name;
            end
            
            r = G.repository;
        end
        
        function s = sourceURL(G)
            urlParts = { ...
                PackageManager.RemotePackage.Github.RootURL, ...
                G.username, ...
                G.repository, ...
                'archive', ...
                G.archiveName ...
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
            
            urlwrite(B.sourceURL, B.downloadPath);
        end
        
        function pull(B)
            PackageManager.Github.pull(B.username, B.repository);            
        end
    end
    
end

