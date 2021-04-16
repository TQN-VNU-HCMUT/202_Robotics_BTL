
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

function plotLink = F_Simu_Elbow(axisHandles,position,orientation,opacity)
    shoulderProp = C_SimuProperties(61.5, 15, 200, 62, 40, [143 79 79]/255, opacity);
    [shiftedPosX, shiftedPosY, shiftedPosZ] = F_Shift_Along_Vector(position(1),position(2),position(3),-orientation(1,:),200);
    shiftedPos = [shiftedPosX, shiftedPosY, shiftedPosZ];
    plotLink = F_Rounded_Box(axisHandles,shiftedPos,orientation(1,:),-orientation(3,:),shoulderProp);
    
end

