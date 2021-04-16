function [X, Y, Z] = F_3D_Circle(center,normal,radius)
    theta  = 0:0.1:2*pi;
    
    v      = null(normal);
    points = repmat(center', 1, size(theta,2)) + radius*(v(:,1)*cos(theta) + v(:,2)*sin(theta));
    
    X      = points(1,:);
    Y      = points(2,:);
    Z      = points(3,:);
end