classdef C_FunctionType
    enumeration
        RobotPlot
    end
    methods
        function trueFalse = isRobotPlot(obj)
            trueFalse = C_FunctionType.RobotPlot == obj;
        end
    end
    
end

