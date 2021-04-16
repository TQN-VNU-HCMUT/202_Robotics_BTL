
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

function plotLink = F_Simu_Shaft(axisHandles,position,orientation,opacity)
    shoulderProp = C_SimuProperties(473, 20, 0, 0, 40, [242 180 180]/255, opacity);
    [shiftedPosX, shiftedPosY, shiftedPosZ] = F_Shift_Along_Vector(position(1),position(2),position(3),-orientation(3,:),17);
    shiftedPos = [shiftedPosX, shiftedPosY, shiftedPosZ];
    plotLink = F_Rounded_Box(axisHandles,shiftedPos,orientation(1,:),orientation(3,:),shoulderProp);
    
end
