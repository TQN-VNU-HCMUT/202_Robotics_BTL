classdef C_SimuProperties
    properties
        customHeight   = 0.1;
        customRadius   = 6;
        customNoPoints = 40;
        customColor    = [193 193 193]/255;
        customOpacity  = 0.5;
    end
    
    methods
        function simuObj = C_SimuProperties(height, radius, noPoints, color, opacity)
            if nargin == 0
            elseif nargin == 5
                simuObj.customHeight   = height;
                simuObj.customRadius   = radius;
                simuObj.customNoPoints = noPoints;
                simuObj.customColor    = color;
                simuObj.customOpacity  = opacity;
            end
        end
    end
end

