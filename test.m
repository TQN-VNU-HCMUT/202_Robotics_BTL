syms a2 d2 theta2 a3 theta3 d4 alpha5 d5 theta5
A_0_1 = F_Homogeneous_Transformation(a2,0,d2,theta2);
A_1_2 = F_Homogeneous_Transformation(a3,0,0,theta3);
A_2_3 = F_Homogeneous_Transformation(0,0,d4,0);
A_0_3 = simplify(A_0_1*A_1_2*A_2_3);
A_0_2 = simplify(A_0_1*A_1_2)


