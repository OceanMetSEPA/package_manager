classdef List < handle
    %DEPENDENCYLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filePath = '';
        dependencies = {};
    end
    
    methods
        
        function L = List(filePath)
            if exist('filePath', 'var')
                L.fromFile(filePath);
            end           
        end
        
        function fromFile(L, filePath)
            file = textread(filePath,'%s','delimiter','\n');
            
            delimitingRows = find(cellfun(@(x) isempty(strtrim(x)), file));
            adjacentRows = find(diff(delimitingRows) == 1);
            delimitingRows(adjacentRows+1) = [];
            
            if delimitingRows(1) == 1
                delimitingRows(1) = [];
            end
            
            if delimitingRows(end) ~= size(file,1)
                delimitingRows(end+1) = size(file,1)+1;
            end
            
            dependencyCount = size(delimitingRows,1);
            
            startRowIndex = 1;
                        
            for d = 1:dependencyCount
                rows = file(startRowIndex:delimitingRows(d)-1);
                
                base = PackageManager.Dependency.Base;
                
                for r = 1:size(rows,1)
                    if  regexp(rows{r}, '^#') | regexp(rows{r}, '^\s+$') | isempty(rows{r})
                        continue;
                    end

                    if  regexp(rows{r}, '.*=.*')
                       [strs, ~] = strsplit(rows{r}, '=');
                       
                       base.addProperty(strtrim(strs{1}), strtrim(strs{2}));
                    end  
                end
                
                dependency = PackageManager.Dependency.Base.toSubclass(base);
                
                L.dependencies{d} = dependency;
                startRowIndex = delimitingRows(d)+1;
            end

            L.filePath = filePath;
        end
        
        function s = size(DL)
            s = size(DL.dependencies,2);
        end
        
        function installAll(DL, varargin)
            for d = 1:DL.size
                DL.dependencies{d}.install(varargin{:});
            end
        end
            
    end
    
end

