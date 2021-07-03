
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

function A_iMinus1_i = F_Homogeneous_Transformation(a, alpha, d, theta)
    A_iMinus1_i = [cos(theta) -cos(alpha)*sin(theta) sin(alpha)*sin(theta)  a*cos(theta);...
                   sin(theta) cos(alpha)*cos(theta)  -sin(alpha)*cos(theta) a*sin(theta);...
                   0          sin(alpha)             cos(alpha)             d;...
                   0          0                      0                      1];
    A_iMinus1_i = simplify(A_iMinus1_i);
end