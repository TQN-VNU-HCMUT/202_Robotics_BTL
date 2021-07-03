
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

function F_Handle_Functions(handles, type, robotLink)
    functionType = C_FunctionType(type);
    
    %% Handle Functions Type & Call Appropriate ones
    if functionType.isRobotPlot
        F_Robot_Plot(handles, robotLink);
        disp("hihi")
    else
    end


end

