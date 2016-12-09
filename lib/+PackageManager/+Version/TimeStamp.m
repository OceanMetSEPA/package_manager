classdef TimeStamp < PackageManager.Version.Base
    
    properties
        datetime = 19700101000000;
    end
    
    methods
        function TS= TimeStamp(string)
            TS.string = string;
            
            TS.datetime = str2num(string);
        end
        
        function bool = compare(TS, otherVersion)
            bool = 1;
            
            if otherVersion.isString
                bool = -1;
            elseif otherVersion.isTimeStamp
                if TS.datetime < otherVersion.datetime
                    bool = -1;
                end
            end            
        end
        
    end
    
end

