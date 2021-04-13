function transformMatrix = F_Transform_Matrix(Rotation, Translation)
    phi   = Rotation(1);
    theta = Rotation(2);
    psi   = Rotation(3);
    
    Rz_phi   = [cos(phi)    -sin(phi)    0;          ...
                sin(phi)    cos(phi)     0;          ...
                0           0            1];
    Ry_theta = [cos(theta)  0            sin(theta); ...
                0           1            0;          ...
                -sin(theta) 0            cos(theta)];
    Rx_psi   = [1           0            0;          ...
                0           cos(psi)     -sin(psi);  ...
                0           sin(psi)     cos(psi)];
            
    Rxyz = Rz_phi*Ry_theta*Rx_psi;
    
    transformMatrix = [Rxyz; [0 0 0]];
    transformMatrix = [transformMatrix [Translation; 1]];
end

