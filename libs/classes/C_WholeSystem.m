classdef C_WholeSystem < handle
    properties
        mode C_WholeSystemType = C_WholeSystemType.ForwardKinematics_1;
        linkVector C_Link
        axisHandles
        desired = struct('x',[],'y',[],'z',[],'psi',[]);
    end
    
    methods
        function wholeSystemObj = C_WholeSystem(linkVector, axisHandles)
            wholeSystemObj.linkVector  = linkVector;
            wholeSystemObj.axisHandles = axisHandles;
        end
        
        %% Initialize our Robot from the first Link
        function initialize(this)
            this.linkVector(1).initialize(this.axisHandles);
        end
        
        %% Set mode for whole system
        function set(this, paramName, paramValue)
            switch paramName
                case'mode'
                    this.mode = paramValue;
                case 'x'
                    this.desired.x = paramValue;
                case 'y'
                    this.desired.y = paramValue;
                case 'z'
                    this.desired.z = paramValue;
                case 'psi'
                    this.desired.psi = deg2rad(paramValue);
            end
        end
        
        %% Go to Destination
        function gotoDest(this)
            if this.isForwardKinematics_2
                this.linkVector(1).draw(this.axisHandles,true);
            elseif this.isInversedKinematics
                Pwx = this.desired.x;
                Pwy = this.desired.y;
                a2 = this.linkVector(2).a;
                a3 = this.linkVector(3).a;
                
                c3 = (Pwx^2 + Pwy^2 - a2^2 - a3^2)/(2*a2*a3);
                s3 = sqrt(1-c3^2);
                theta3 = atan2(s3,c3);
                
                s2 = ((a2+a3*c3)*Pwy - a3*s3*Pwx)/(Pwx^2 + Pwy^2);
                c2 = ((a2+a3*c3)*Pwx + a3*s3*Pwy)/(Pwx^2 + Pwy^2);
                theta2 = atan2(s2,c2);
                
                d4     = this.desired.z-this.linkVector(2).d-this.linkVector(5).d;
                theta5 = this.desired.psi;
                
                this.linkVector(2).setDesired(this.axisHandles,theta2);
                this.linkVector(3).setDesired(this.axisHandles,theta3);
                this.linkVector(4).setDesired(this.axisHandles,d4);
                this.linkVector(5).setDesired(this.axisHandles,theta5);
            end
        end
        
        %% Enable axis
        function displayAxis(this, linkNumber, trueFalse)
            this.linkVector(linkNumber).displayAxis(this.axisHandles,trueFalse);
        end
        
        %% Re-calculate DHMatrixes on Params Changed
        function onParamChanged(this,number,paramName,paramValue)
            this.linkVector(number).onParamChanged(this.axisHandles,paramName,paramValue,...
                this.isForwardKinematics_1);
        end
        
        %% Check for Operating Mode
        function trueFalse = isForwardKinematics_1(this)
            trueFalse = this.mode.isForwardKinematics_1;
        end
        function trueFalse = isForwardKinematics_2(this)
            trueFalse = this.mode.isForwardKinematics_2;
        end
        function trueFalse = isInversedKinematics(this)
            trueFalse = this.mode.isInversedKinematics;
        end
    end
    
end

