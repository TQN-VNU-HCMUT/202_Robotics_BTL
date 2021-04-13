function F_Simu_Ground(axisHandles,opacity)
    
    grid(axisHandles, 'on')
    hold(axisHandles, 'on')
    axis(axisHandles, 'tight')
    axis(axisHandles, 'equal')
    zlim(axisHandles, [-50 1000])
    view(axisHandles, [-163 25]);
    
    %% Plot the base ground
    baseProp = C_SimuProperties(50, 800, 40, [193 193 193]/255, opacity);
    F_Cylinder(axisHandles, [0 0 0], [0 0 -1], baseProp);
    
end

