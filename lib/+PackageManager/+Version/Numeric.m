classdef Numeric < PackageManager.Version.Base
    
    properties
        major = 0;
        minor = [];
        bump  = [];
    end
    
    methods
        
        function N = Numeric(string)
            N.string = string;
            [a,b] = regexp(string, '^(\d+)\.?(\d+)?\.?(\d+)?$', 'match', 'tokens'); 
            numbers = cellfun(@str2num,b{1},'UniformOutput', 0);
            array = [numbers{1:3}];
            if numel(array) == 1
                N.major = array;
            elseif numel(array) > 1
                N.major = array(1);
                
                if ~isempty(array(2))
                    N.minor = array(2);
                    
                    if numel(array) > 2
                        N.bump  = array(3); 
                    end
                end
            end
            
            N.cleanUp;
        end
        
        function cleanUp(N)
            if ~isnumeric(N.major)
                N.major = 0;
            end
            if ~isnumeric(N.minor)
                N.minor = 0;
            end
            if ~isnumeric(N.bump)
                N.bump = 0;
            end
        end
                        
        function v = values(N)
            v = [N.major N.minor N.bump];
        end
        
        function bool = compare(N, otherVersion)
            bool = 1;
            
            if otherVersion.isNumeric
                if N.major < otherVersion.major
                    bool = -1;
                elseif N.major == otherVersion.major
                    if N.minor < otherVersion.minor
                        bool = -1;
                    elseif N.minor == otherVersion.minor
                        if N.bump < otherVersion.bump
                            bool = -1;
                        elseif N.bump == otherVersion.bump
                            bool = 0;
                        end
                    end
                end
            end            
        end
        
    end
    
end

