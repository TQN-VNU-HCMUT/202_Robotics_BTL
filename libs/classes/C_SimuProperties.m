classdef C_SimuProperties
    properties
        customHeight   = 0.1;
        customRadius   = 4;
        customLengthX  = 5;
        customLengthY  = 10;
        customNoPoints = 10;
        customColor    = [193 193 193]/255;
        customOpacity  = 0.5;
    end
    
    methods
        function simuObj = C_SimuProperties(height, radius, lengthX, lengthY, noPoints, color, opacity)
            if nargin == 0
            elseif nargin == 7
                simuObj.customHeight   = height;
                simuObj.customRadius   = radius;
                simuObj.customLengthX  = lengthX;
                simuObj.customLengthY  = lengthY;
                simuObj.customNoPoints = noPoints;
                simuObj.customColor    = color;
                simuObj.customOpacity  = opacity;
            end
        end
    end
end

