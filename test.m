% syms a2 d2 theta2 a3 theta3 d4 alpha5 d5 theta5
% A_0_1 = F_Homogeneous_Transformation(a2,0,d2,theta2);
% A_1_2 = F_Homogeneous_Transformation(a3,0,0,theta3);
% A_2_3 = F_Homogeneous_Transformation(0,0,d4,0);
% A_0_3 = simplify(A_0_1*A_1_2*A_2_3);
% A_0_2 = simplify(A_0_1*A_1_2)


lengthX = 10;
lengthY = 20;
cornerRadius = 4;
cornerNoPoints = 10;
orientation = [-0.9318 -0.3629 0];

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

rotateAngle = atan2(orientation(2),orientation(1));
R = rotz(rad2deg(rotateAngle));
for i = 1:length(x)
    former = [x(i) y(i) z(i)]';
    after  = R*former;
    x(i)   = after(1);
    y(i)   = after(2);
    z(i)   = after(3);
end

x = x + 10;
y = y + 10;
z = z + 10;

[x1,y1,z1] = F_Shift_Along_Vector(x,y,z,[0 0 1],10);
x2 = [x; x1];
y2 = [y; y1];
z2 = [z; z1];

axis equal
grid on
hold on


fill3(x,y,z,'b');
fill3(x1,y1,z1,'b');
surf(x2,y2,z2);
