classdef String < PackageManager.Version.Base
    
    properties
    end
    
    methods
        
        function S = String(string)
            S.string = string;
        end
        
        function bool = compare(S, otherVersion)
            bool = 1;
            
            if otherVersion.isNumeric
                bool = -1;
            else
                if isequal(S.string, otherVersion.string)
                    bool = 0;
                else
                    strings = sort({S.string, otherVersion.string});
                
                    if isequal(S.string, strings{1})
                        bool = -1;
                    end
                end                
            end            
        end
        
    end
    
end

