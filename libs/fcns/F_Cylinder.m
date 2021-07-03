
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

function plotLink = F_Cylinder(axisHandles, position, orientation, properties)

    if ~isa(properties, 'C_SimuProperties')
        error('Calling function F_Cylinder with wrong properties.');
    end
    
    height   = properties.customHeight;
    radius   = properties.customRadius;
    noPoints = properties.customNoPoints;
    color    = properties.customColor;
    opacity  = properties.customOpacity;
    
    [X1,Y1,Z1] = F_3D_Circle(position,orientation,radius);
    [X2,Y2,Z2] = F_Shift_Along_Vector(X1,Y1,Z1,orientation,height);
    [X3,Y3,Z3] = cylinder2([radius,radius],position,orientation,noPoints,height);
    
    if nargout == 0
        fill3(axisHandles,X1,Y1,Z1,color,'FaceAlpha',opacity);
        fill3(axisHandles,X2,Y2,Z2,color,'FaceAlpha',opacity);
        surf(axisHandles,X3,Y3,Z3,'FaceColor',color,'EdgeColor','none','FaceAlpha',opacity);
    else
        plotLink1 = surf(axisHandles,X3,Y3,Z3,'FaceColor',color,'EdgeColor','none','FaceAlpha',opacity);
        plotLink2 = fill3(axisHandles,X1,Y1,Z1,color,'FaceAlpha',opacity);
        plotLink3 = fill3(axisHandles,X2,Y2,Z2,color,'FaceAlpha',opacity);
        plotLink = [plotLink1; plotLink2; plotLink3];
    end
end

