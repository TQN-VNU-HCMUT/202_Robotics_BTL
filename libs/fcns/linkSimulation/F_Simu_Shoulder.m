
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

function plotLink = F_Simu_Shoulder(axisHandles,position,orientation,opacity)
    shoulderProp = C_SimuProperties(305, 130, 40, [193 193 193]/255, opacity);
    plotLink = F_Cylinder(axisHandles,position,orientation(3,:),shoulderProp);
    
end

