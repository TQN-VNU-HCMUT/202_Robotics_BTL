classdef C_WholeSystem < handle
    properties
        mode       C_WholeSystemType = C_WholeSystemType.ForwardKinematics_1;
        linkVector C_Link
        axisHandles
        EETimer
        isRunning      = false
        simulationPath = struct('x',[],'y',[],'z',[],'plotPath',[]);
        EEHandles      = struct('x',[],'y',[],'z',[],'psi',[]);
        desired        = struct('x',[],'y',[],'z',[],'psi',[]);
        current        = struct('x',[],'y',[],'z',[],'psi',[]);
%         pathParam      = struct('qMax',[],'vMax',[],'aMax',[]);
    end
    
    methods
        function wholeSystemObj = C_WholeSystem(linkVector, axisHandles, endEffectorHandles)
            wholeSystemObj.linkVector    = linkVector;
            wholeSystemObj.axisHandles   = axisHandles;
            wholeSystemObj.EEHandles.x   = endEffectorHandles(1);
            wholeSystemObj.EEHandles.y   = endEffectorHandles(2);
            wholeSystemObj.EEHandles.z   = endEffectorHandles(3);
            wholeSystemObj.EEHandles.psi = endEffectorHandles(4);
            wholeSystemObj.EETimer       = wholeSystemObj.createEETimer;
            start(wholeSystemObj.EETimer);
        end
        
        %% Initialize our Robot from the first Link
        function initialize(this)
            this.linkVector(1).initialize(this.axisHandles);
        end
        
        %% Set mode for whole system
        function set(this, paramName, paramValue)
            switch paramName
                case 'mode'
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
        
        %% Delete path Simulation
        function deletePath(this)
            delete(this.simulationPath.plotPath);
            this.simulationPath.x = [];
            this.simulationPath.y = [];
            this.simulationPath.z = [];
        end
        
        %% Go to Destination
        function gotoDest(this)
            if this.isForwardKinematics_2
                this.linkVector(1).draw(this.axisHandles,true);
            elseif this.isInversedKinematics
                this.pathPlanning;
            end
        end
        
        %% Path Planning
        function pathPlanning(this)
            this.isRunning = true;
            currentX = this.current.x;
            currentY = this.current.y;
            desiredVector = [this.desired.x-currentX, this.desired.y-currentY];
            qMax = norm(desiredVector);
            aMax = 5;
            vMax = sqrt(qMax*aMax);
            
            t1      = vMax/aMax;
            tm      = (qMax - aMax*t1^2)/vMax;
            tmax    = 2*t1 + tm;
            t2      = tmax - t1;
            
            t       = 0:0.1:tmax;
            lengthT = length(t);
            a       = zeros(lengthT,1);
            v       = zeros(lengthT,1);
            q       = zeros(lengthT,1);
            for i = 1:1:lengthT
                if     (t(i) < t1), a(i) = aMax;  v(i) = aMax*t(i); q(i) = 0.5*aMax*t(i)^2;
                elseif (t(i) < t2), a(i) = 0;     v(i) = vMax;      q(i) = 0.5*aMax*t1^2 + vMax*(t(i)-t1);
                else,               a(i) = -aMax; v(i) = vMax - aMax*(t(i)-t2); q(i) = qMax - 0.5*aMax*(tmax-t(i))^2;
                end
            end
%             v = cumtrapz(t,a);
%             q = cumtrapz(t,v);
            
            qStd = q/qMax;
            for i = 1:1:length(q)
                desiredPos = qStd(i)*desiredVector + [currentX, currentY];
                this.inversedKinematics(desiredPos,'xy');
                pause(0.01)
            end
            this.inversedKinematics([0 0],'z');
            this.inversedKinematics([0 0],'psi');

            this.isRunning = false;
        end
        
        %% Inversed Kinematics
        function inversedKinematics(this, desiredXY, type)
            if strcmp(type,'xy')
                Pwx = desiredXY(1);
                Pwy = desiredXY(2);
                a2  = this.linkVector(2).a;
                a3  = this.linkVector(3).a;

                c3     = (Pwx^2 + Pwy^2 - a2^2 - a3^2)/(2*a2*a3);
                s3     = sqrt(1-c3^2);
                theta3 = atan2(s3,c3);

                s2     = ((a2+a3*c3)*Pwy - a3*s3*Pwx)/(Pwx^2 + Pwy^2);
                c2     = ((a2+a3*c3)*Pwx + a3*s3*Pwy)/(Pwx^2 + Pwy^2);
                theta2 = atan2(s2,c2);

                this.linkVector(2).onParamChanged(this.axisHandles,'theta',rad2deg(theta2),true);
                this.linkVector(3).onParamChanged(this.axisHandles,'theta',rad2deg(theta3),true);
                
            elseif strcmp(type,'z')
                d4 = this.desired.z - this.linkVector(2).d - this.linkVector(5).d;
                this.linkVector(4).setDesired(this.axisHandles,d4);
                
            elseif strcmp(type,'psi')
                theta5 = this.desired.psi;
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
    
    methods (Access = private)
        %% Create timer for Exporting End Effector values every period
        function t = createEETimer(this)
            t               = timer;
            t.StartFcn      = @this.EETimerStart;
            t.TimerFcn      = @this.exportEEPos;
            t.StopFcn       = @this.EETimerCleanup;
            t.Period        = 0.1;
            t.ExecutionMode = 'fixedSpacing';
        end
        function EETimerStart(~,~,~)
            disp('Timer started.')
        end
        function EETimerCleanup(~,~,~)
            disp('Timer deleted.')
        end
        
        %% Export End-effector position to GUI
        function exportEEPos(this,~,~)
            lengthLink = length(this.linkVector);
            this.current.x   = this.linkVector(lengthLink).get('x');
            this.current.y   = this.linkVector(lengthLink).get('y');
            this.current.z   = this.linkVector(lengthLink).get('z');
            this.current.psi = this.linkVector(lengthLink).get('psi');
            
            set(this.EEHandles.x,  'String', this.current.x);
            set(this.EEHandles.y,  'String', this.current.y);
            set(this.EEHandles.z,  'String', this.current.z);
            set(this.EEHandles.psi,'String', this.current.psi);
            
            if this.isInversedKinematics && this.isRunning
                this.simulationPath.x   = [this.simulationPath.x; this.current.x];
                this.simulationPath.y   = [this.simulationPath.y; this.current.y];
                this.simulationPath.z   = [this.simulationPath.z; this.current.z];
                
                delete(this.simulationPath.plotPath);
                this.simulationPath.plotPath = plot3(this.axisHandles, this.simulationPath.x,...
                                                    this.simulationPath.y, this.simulationPath.z,...
                                                    'Color',[0.9290 0.6940 0.1250],'LineWidth', 2);
            end
        end
    end
end

