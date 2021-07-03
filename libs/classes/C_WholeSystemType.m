
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

classdef C_WholeSystemType
    enumeration
        ForwardKinematics_1
        ForwardKinematics_2
        InversedKinematics_Straight
        InversedKinematics_Circular
    end
    methods
        function trueFalse = isForwardKinematics_1(this)
            trueFalse = C_WholeSystemType.ForwardKinematics_1 == this;
        end
        function trueFalse = isForwardKinematics_2(this)
            trueFalse = C_WholeSystemType.ForwardKinematics_2 == this;
        end
        function trueFalse = isInversedKinematics_Straight(this)
            trueFalse = C_WholeSystemType.InversedKinematics_Straight == this;
        end
        function trueFalse = isInversedKinematics_Circular(this)
            trueFalse = C_WholeSystemType.InversedKinematics_Circular == this;
        end
    end
    
end

