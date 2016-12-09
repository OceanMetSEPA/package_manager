classdef List < handle
    
    properties
        package@PackageManager.Package;
        list = {};
    end
    
    methods (Static = true)
    end
    
    methods
        
        function L = List(cellArray)
            for i = 1:numel(cellArray)
                version = PackageManager.Version.Base.create(cellArray{i});
                version.list = L;
                L.list{i} = version;
            end 
        end
        
        
        function [version, index] = earliest(L)
            index = 1;
            
            for i = 2:numel(L.list)
                if L.list{i}.isLessThan(L.list{index})
                    index = i
                end
            end
            
            version = L.list{index};
        end
        
        function [version, index] = latest(L)
            index = 1;
            
            for i = 2:numel(L.list)
                if L.list{i}.isGreaterThan(L.list{index})
                    index = i
                end
            end
            
            version = L.list{index};
        end
        
        function sort(L)
%             index = 1
%             for i = 2:numel(L.versions) 
        end
        
        function c = names(L)
            c = cellfun(@toString, L.list, 'unif', 0);
        end
        
    end
    
end

