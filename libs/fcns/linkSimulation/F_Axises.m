
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

function axisPlot = F_Axises(axisHandles, position, orientation)
    axisColor = [0.6350     0.0780      0.1840;...  % Color for X axis
                 0.4660     0.6740      0.1880;...  % Color for Y axis
                 0          0.4470      0.7410];    % Color for Z axis
    axisPlot = [];         
    for i = 1:3
        [tmpX,tmpY,tmpZ] = cylinder2([7,7],position,orientation(i,:),10,75);
        tmpAxisPlot = surf(axisHandles,tmpX,tmpY,tmpZ,'FaceColor',axisColor(i,:),'EdgeColor','none');
        axisPlot = [axisPlot; tmpAxisPlot];
    end
    
end

