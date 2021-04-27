
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

function F_Simu_Ground(axisHandles,opacity)
    
    grid(axisHandles, 'on')
    hold(axisHandles, 'on')
    axis(axisHandles, 'tight')
    axis(axisHandles, 'equal')
    zlim(axisHandles, [-50 1000])
    view(axisHandles, [-163 25]);
    
    %% Plot the base ground
    baseProp = C_SimuProperties(50, 800, 0, 0, 10, [65 60 105]/255, opacity);
    F_Rounded_Box(axisHandles, [0 0 0], [1 0 0], [0 0 -1], baseProp);
end

