function plotLink = F_Rounded_Box(axisHandles, position, orientationX, orientationZ, properties)
    if ~isa(properties, 'C_SimuProperties')
        error('Calling function F_Cylinder with wrong properties.');
    end
    
    height         = properties.customHeight;
    lengthX        = properties.customLengthX;
    lengthY        = properties.customLengthY;
    cornerRadius   = properties.customRadius;
    cornerNoPoints = properties.customNoPoints;
    color          = properties.customColor;
    opacity        = properties.customOpacity;
    
    %%
    x = zeros(1,cornerNoPoints*4);
    y = zeros(1,cornerNoPoints*4);
    for i = 1:1:4
        limit = i*pi/2;
        for j = (limit-pi/2):(pi/2/cornerNoPoints):limit
           x(round(j/(pi/2/cornerNoPoints)+1,1)) = cos(j)*cornerRadius + lengthX*sign(cos(j));
           y(round(j/(pi/2/cornerNoPoints)+1,1)) = sin(j)*cornerRadius + lengthY*sign(sin(j));
        end
    end
    x = [x, x(1)];
    y = [y, y(1)];
    z = 0*x;
    
    rotateAngle = atan2(orientationX(2),orientationX(1));
    R = rotz(rad2deg(rotateAngle));
    for i = 1:length(x)
        former = [x(i) y(i) z(i)]';
        after  = R*former;
        x(i)   = after(1);
        y(i)   = after(2);
        z(i)   = after(3);
    end
    
    x = x + position(1);
    y = y + position(2);
    z = z + position(3); 

    [x1,y1,z1] = F_Shift_Along_Vector(x,y,z,orientationZ,height);
    x2 = [x; x1];
    y2 = [y; y1];
    z2 = [z; z1];

    if nargout == 0
        fill3(axisHandles,x,y,z,color,'FaceAlpha',opacity);
        fill3(axisHandles,x1,y1,z1,color,'FaceAlpha',opacity);
        surf(axisHandles,x2,y2,z2,'FaceColor',color,'EdgeColor','none','FaceAlpha',opacity);
    else
        plotLink1 = surf(axisHandles,x2,y2,z2,'FaceColor',color,'EdgeColor','none','FaceAlpha',opacity);
        plotLink2 = fill3(axisHandles,x,y,z,color,'FaceAlpha',opacity);
        plotLink3 = fill3(axisHandles,x1,y1,z1,color,'FaceAlpha',opacity);
        plotLink = [plotLink1; plotLink2; plotLink3];
    end
end

