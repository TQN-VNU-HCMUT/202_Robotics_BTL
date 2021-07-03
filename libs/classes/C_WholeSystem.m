
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

classdef C_WholeSystem < handle
    properties
        mode       C_WholeSystemType = C_WholeSystemType.ForwardKinematics_1;
        linkVector C_Link
        axisHandles
        EEHandles      = struct('x',[],'y',[],'z',[],'psi',[]);
        consoleHandles
        isRunning      = false
        simulationPath = struct('x',[],'y',[],'z',[],'formula',[],'plotPath',[]);
        desired        = struct('x',[],'y',[],'z',[],'psi',[],'aMax',20,'radius',700);
        current        = struct('x',[],'y',[],'z',[],'psi',[]);
        plotting       = struct('q',[],'v',[],'a',[],'time',[],'index',1);
    end
    properties (Access = private)
        EETimer
        trajectory     = struct('tab1',[],'tab2',[]);
    end
    
    methods
        function wholeSystemObj = C_WholeSystem(linkVector,axisHandles,endEffectorHandles,consoleHandles)
            wholeSystemObj.linkVector    = linkVector;
            
            wholeSystemObj.axisHandles   = axisHandles;
            
            wholeSystemObj.EEHandles.x   = endEffectorHandles(1);
            wholeSystemObj.EEHandles.y   = endEffectorHandles(2);
            wholeSystemObj.EEHandles.z   = endEffectorHandles(3);
            wholeSystemObj.EEHandles.psi = endEffectorHandles(4);
            wholeSystemObj.EETimer       = wholeSystemObj.createEETimer;
            start(wholeSystemObj.EETimer);
            
            wholeSystemObj.consoleHandles = consoleHandles;
        end
        
        %% Initialize Trajectory Tabs
        function initTrajectoryTabs(this, tab1Handle, tab2Handle)
            this.initTrajectTab1(tab1Handle);
            this.initTrajectTab2(tab2Handle);
        end
        
        %% Initialize Trajectory Tab1
        function initTrajectTab1(this, tabHandle)
            this.trajectory.tab1 = struct('axisQ',[],'axisV',[],'axisA',[],...
                                          'plotAxisQ',[],'plotAxisV',[],'plotAxisA',[]);
            
            this.trajectory.tab1.axisQ = subplot(3,1,1,'Parent', tabHandle);
            ylabel(this.trajectory.tab1.axisQ,'$q$','Interpreter','latex','FontSize',17);
            
            this.trajectory.tab1.axisV = subplot(3,1,2,'Parent', tabHandle);
            ylabel(this.trajectory.tab1.axisV,'$\dot{q}$','Interpreter','latex','FontSize',17);
            
            this.trajectory.tab1.axisA = subplot(3,1,3,'Parent', tabHandle);
            ylabel(this.trajectory.tab1.axisA,'$\ddot{q}$','Interpreter','latex','FontSize',17);
            xlabel(this.trajectory.tab1.axisA,"\it {Time (s)}",'FontSize',13);
        end
        
        %% Initialize Trajectory Tab2
        function initTrajectTab2(this, tabHandle)
            lengthLink = length(this.linkVector);
            for i = 2:lengthLink
                structField = '';
                nameField   = '';
                if this.linkVector(i).isPrismatic
                    structField = strcat(structField,'d');
                    nameField = strcat(nameField,join(['{d_',num2str(i),'}'],""));
                elseif this.linkVector(i).isRevolute
                    structField = strcat(structField,'theta');
                    nameField = strcat(nameField,join(['{\theta_',num2str(i),'}'],""));
                end
                structField = strcat(structField,num2str(i));
                this.trajectory.tab2.(structField) = struct('axisQ',[],'axisV',[],'axisA',[]);
                
                this.trajectory.tab2.(structField).axisQ = subplot(lengthLink-1,3,(i-2)*3+1,'Parent',tabHandle);
                this.linkVector(i).plotQVA.axisQ = this.trajectory.tab2.(structField).axisQ;
                hold(this.linkVector(i).plotQVA.axisQ,'on');
                grid(this.linkVector(i).plotQVA.axisQ,'on');
                ylabel(this.linkVector(i).plotQVA.axisQ,join(['$q_',nameField,'$'],""),'Interpreter','latex','FontSize',17);
                
                this.trajectory.tab2.(structField).axisV = subplot(lengthLink-1,3,(i-2)*3+2,'Parent',tabHandle);
                this.linkVector(i).plotQVA.axisV = this.trajectory.tab2.(structField).axisV;
                hold(this.linkVector(i).plotQVA.axisV,'on');
                grid(this.linkVector(i).plotQVA.axisV,'on');
                ylabel(this.linkVector(i).plotQVA.axisV,join(['$\dot{q_',nameField,'}$'],""),'Interpreter','latex','FontSize',17);
                
                this.trajectory.tab2.(structField).axisA = subplot(lengthLink-1,3,(i-2)*3+3,'Parent',tabHandle);
                this.linkVector(i).plotQVA.axisA = this.trajectory.tab2.(structField).axisA;
                hold(this.linkVector(i).plotQVA.axisA,'on');
                grid(this.linkVector(i).plotQVA.axisA,'on');
                ylabel(this.linkVector(i).plotQVA.axisA,join(['$\ddot{q_',nameField,'}$'],""),'Interpreter','latex','FontSize',17);
            end
        end
        
        %% Initialize our Robot from the first Link
        function initialize(this)
            this.linkVector(1).initialize(this.axisHandles);
        end
        
        %% Set mode for whole system
        function set(this, paramName, paramValue)
            switch paramName
                case 'mode',    this.mode           = paramValue;
                case 'x',       this.desired.x      = paramValue;
                case 'y',       this.desired.y      = paramValue;
                case 'z',       this.desired.z      = paramValue;
                case 'psi',     this.desired.psi    = deg2rad(paramValue);
                case 'aMax',    this.desired.aMax   = paramValue;
                case 'radius',  this.desired.radius = paramValue;
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
                disp("hihi")
            elseif this.isInversedKinematics_Straight || this.isInversedKinematics_Circular
                deletePathPlot(this);
                this.pathPlanning;
            end
        end
        
        %% Delete Path Planning Plot
        function deletePathPlot(this)
            this.plotting.q     = [];
            this.plotting.v     = [];
            this.plotting.a     = [];
            this.plotting.time  = [];
            this.plotting.index = 1;
            
            delete(this.trajectory.tab1.plotAxisQ);
            delete(this.trajectory.tab1.plotAxisV);
            delete(this.trajectory.tab1.plotAxisA);
            
            for i = 2:1:length(this.linkVector)
                this.linkVector(i).deletePathPlot;
            end
        end
        
        %% Path Planning
        function pathPlanning(this)
            this.isRunning = true;
            currentX = this.current.x;
            currentY = this.current.y;
            desiredVector = [this.desired.x-currentX, this.desired.y-currentY];
            normDesiredVector = norm(desiredVector);
            this.desired.radius
            
            if this.isInversedKinematics_Straight ...
                    || (this.isInversedKinematics_Circular && (this.desired.radius <= normDesiredVector/2))
                qMax = normDesiredVector;
                
                this.simulationPath.formula = @(stdVec) stdVec*desiredVector + [currentX, currentY];  
            else
                radius = this.desired.radius;
                middlePoint  = [this.desired.x+currentX, this.desired.y+currentY]/2;
                normalVector = [desiredVector(2), -desiredVector(1)]/normDesiredVector; % There're actually 2 cases
                circleCenter = middlePoint + sqrt(radius^2 - (normDesiredVector/2)^2)*normalVector;
                
                aVector   = [currentX-circleCenter(1), currentY-circleCenter(2)];
                bVector   = [this.desired.x-circleCenter(1), this.desired.y-circleCenter(2)];
                direction = sign(aVector(1)*bVector(2) - aVector(2)*bVector(1));
                
                theta   = direction*acos(dot(aVector,bVector)/(norm(aVector)*norm(bVector)));
                qMax    = radius*abs(theta);
                
                aVecAngle = atan2(aVector(2), aVector(1));
                this.simulationPath.formula = @(stdVec) [radius*cos(stdVec*theta+aVecAngle), radius*sin(stdVec*theta+aVecAngle)] + circleCenter;
            end
            
            aMax = this.desired.aMax;
            vMax = sqrt(qMax*aMax);

            t1      = vMax/aMax;
            tm      = (qMax - aMax*t1^2)/vMax;
            tmax    = 2*t1 + tm;
            t2      = tmax - t1;

            t       = 0:0.05:tmax;
            lengthT = length(t);
            a       = zeros(lengthT,1);
            v       = zeros(lengthT,1);
            q       = zeros(lengthT,1);
            for i = 1:1:lengthT
                if (t(i) < t1)
                    a(i) = aMax;
                    v(i) = aMax*t(i);
                    q(i) = 0.5*aMax*t(i)^2;
                elseif (t(i) < t2)
                    a(i) = 0;
                    v(i) = vMax;
                    q(i) = 0.5*aMax*t1^2 + vMax*(t(i)-t1);
                else
                    a(i) = -aMax;
                    v(i) = vMax - aMax*(t(i)-t2);
                    q(i) = qMax - 0.5*aMax*(tmax-t(i))^2;
                end
            end

            this.plotting.q    = q;
            this.plotting.v    = v;
            this.plotting.a    = a;
            this.plotting.time = t;

            qStd = q/qMax;
            for i = 1:length(q)
                if this.isRunning
                    desiredPos = this.simulationPath.formula(qStd(i));
                    this.inversedKinematics(desiredPos,'xy');
                    this.plotting.index = i;
                    pause(0.01)
                end
            end
            this.inversedKinematics([0 0],'psi');
            this.inversedKinematics([0 0],'z');
            
            this.isRunning = false;
            
            for i = 2:length(this.linkVector)
                this.linkVector(i).exportQVA(this.EETimer.Period);
            end
        end
        
        %% Inversed Kinematics
        function inversedKinematics(this, desired, type)
            try
                if strcmp(type,'xy')
                    Pwx = desired(1);
                    Pwy = desired(2);
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
            catch
                % Singularity detected therefore stop the system
                this.isRunning = false;
                msg = [datestr(now,'HH:MM:SS.FFF'), ': Singularity detected at (',...
                       num2str(Pwx), '; ', num2str(Pwy), ')'];
                disp(msg);
                
                currString = get(this.consoleHandles,'String');
                currString{end+1} = msg;
                set(this.consoleHandles,'String',currString);
                return
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
        function trueFalse = isInversedKinematics_Straight(this)
            trueFalse = this.mode.isInversedKinematics_Straight;
        end
        function trueFalse = isInversedKinematics_Circular(this)
            trueFalse = this.mode.isInversedKinematics_Circular;
        end
    end
    
    methods (Access = private)
        %% Create timer for Exporting End Effector values every period
        function t = createEETimer(this)
            t               = timer;
            t.StartFcn      = @this.EETimerStart;
            t.TimerFcn      = @this.timerTick;
            t.StopFcn       = @this.EETimerCleanup;
            t.Period        = 0.05;
            t.ExecutionMode = 'fixedSpacing';
        end
        function EETimerStart(~,~,~)
            disp('Timer started.')
        end
        function EETimerCleanup(~,~,~)
            disp('Timer deleted.')
        end
        
        %% Function to call every Interval
        function timerTick(this,~,~)
            lengthLink       = length(this.linkVector);
            this.current.x   = this.linkVector(lengthLink).get('x');
            this.current.y   = this.linkVector(lengthLink).get('y');
            this.current.z   = this.linkVector(lengthLink).get('z');
            this.current.psi = this.linkVector(lengthLink).get('psi');
            
            set(this.EEHandles.x,  'String', this.current.x);
            set(this.EEHandles.y,  'String', this.current.y);
            set(this.EEHandles.z,  'String', this.current.z);
            set(this.EEHandles.psi,'String', this.current.psi);
            
            if (this.isInversedKinematics_Straight || this.isInversedKinematics_Circular) && this.isRunning
%                 for i = 2:lengthLink
%                     this.linkVector(i).exportSliderValue;
%                 end
                this.exportEEPos;
            end
        end
        
        function pathOut = saveSimuPath(~, path, currentPoint)
            pathOut = [];
            tmpLength = length(path);
            if (tmpLength == 0)
                pathOut = [path; currentPoint];
            elseif (currentPoint ~= path(tmpLength))
                pathOut = [path; currentPoint];
            end
        end
        
        %% Export End-effector position to GUI
        function exportEEPos(this)
            this.simulationPath.x = [this.simulationPath.x; this.current.x];
            this.simulationPath.y = [this.simulationPath.y; this.current.y];
            this.simulationPath.z = [this.simulationPath.z; this.current.z];
            
            delete(this.simulationPath.plotPath);
            this.simulationPath.plotPath = plot3(this.axisHandles,     this.simulationPath.x,...
                                                this.simulationPath.y, this.simulationPath.z,...
                                                'Color',[0.9290 0.6940 0.1250],'LineWidth', 2);
            if this.plotting.index >= 2
                tmpIndex = this.plotting.index;
                this.trajectory.tab1.plotAxisQ = plot(this.trajectory.tab1.axisQ, this.plotting.time(1:tmpIndex), this.plotting.q(1:tmpIndex), 'Color',[0 0.4470 0.7410],'LineWidth',1.5);
                this.trajectory.tab1.plotAxisV = plot(this.trajectory.tab1.axisV, this.plotting.time(1:tmpIndex), this.plotting.v(1:tmpIndex), 'Color',[0 0.4470 0.7410],'LineWidth',1.5);
                this.trajectory.tab1.plotAxisA = plot(this.trajectory.tab1.axisA, this.plotting.time(1:tmpIndex), this.plotting.a(1:tmpIndex), 'Color',[0 0.4470 0.7410],'LineWidth',1.5);
                
                for i = 2:1:length(this.linkVector)
                    this.linkVector(i).saveQ;
                end
            end
        end
    end
end

