
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

function plotLink = F_Simu_Shoulder(axisHandles,position,orientation,opacity)
    shoulderProp = C_SimuProperties(305, 15, 75, 75, 10, [40 82 122]/255, opacity);
    plotLink = F_Rounded_Box(axisHandles,position,orientation(1,:),orientation(3,:),shoulderProp);
    
end

