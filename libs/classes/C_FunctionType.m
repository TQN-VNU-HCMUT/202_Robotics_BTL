
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

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

