classdef C_WholeSystemType
    properties
        
    end
    enumeration
        ForwardKinematics_1
        ForwardKinematics_2
        InversedKinematics
    end
    methods
        function trueFalse = isForwardKinematics_1(this)
            trueFalse = C_WholeSystemType.ForwardKinematics_1 == this;
        end
        function trueFalse = isForwardKinematics_2(this)
            trueFalse = C_WholeSystemType.ForwardKinematics_2 == this;
        end
        function trueFalse = isInversedKinematics(this)
            trueFalse = C_WholeSystemType.InversedKinematics == this;
        end
    end
    
end

