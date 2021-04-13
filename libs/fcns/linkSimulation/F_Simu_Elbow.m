function plotLink = F_Simu_Elbow(axisHandles,position,orientation,opacity)
    shoulderProp = C_SimuProperties(100, 30, 40, [193 193 193]/255, opacity);
    plotLink = F_Cylinder(axisHandles,position,orientation(3,:),shoulderProp);
    
end

