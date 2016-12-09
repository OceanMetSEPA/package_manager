classdef Base < handle
    
    properties
        list@PackageManager.Version.List;
        installLog = {};
        string = '';
    end
    
    methods (Static = true)
        
        function sc = create(string)
            % test for numeric version number
           [a,b] = regexp(string, '^(\d+)\.?(\d+)?\.?(\d+)?$', 'match', 'tokens'); 
           % test for timestamp
           [c,d] = regexp(string, '^(\d\d\d\d\d\d\d\d\d\d\d\d\d\d)$', 'match', 'tokens');
           
           if ~isempty(c)
               sc = PackageManager.Version.TimeStamp(string);
           elseif ~isempty(a)
               sc = PackageManager.Version.Numeric(string);
           else
               sc = PackageManager.Version.String(string);
           end
        end

    end
    
    methods
        
        function l = get.installLog(B)
            l = PackageManager.Utils.readLogFile(B.list.package.name, B.string);
        end
        
        function bool = isNumeric(B)
            bool = 0;
            if isequal(class(B), 'PackageManager.Version.Numeric')
                bool = 1;
            end
        end
        
        function bool = isString(B)
            bool = 0;
            if isequal(class(B), 'PackageManager.Version.String')
                bool = 1;
            end
        end
        
        function bool = isTimeStamp(B)
            bool = 0;
            if isequal(class(B), 'PackageManager.Version.TimeStamp')
                bool = 1;
            end
        end
        
        function bool = isGreaterThan(B,otherVersion)
            bool = 0;
            
            if B.compare(otherVersion) == 1
                bool = 1;
            end
        end
        
        function bool = isLessThan(B,otherVersion)
            bool = 0;
            
            if B.compare(otherVersion) == -1
                bool = 1;
            end
        end
        
        function bool = isEqualTo(B,otherVersion)
            bool = 0;
            
            if B.compare(otherVersion) == 0
                bool = 1;
            end
        end
        
        function s = toString(B)
            s = B.string;
        end
        
    end
    
end

