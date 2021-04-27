
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

classdef C_Link < dlnode
    properties
        type C_LinkType         = C_LinkType.Prismatic;
        a = 0;      alpha = 0;      d = 0;      theta = 0;
        opacity {mustBeNumeric} = 0.7;
        desired {mustBeNumeric} = 0;
        distance{mustBeNumeric} = 0;
        simuFunction          % Function to draw Simulation for specific Links
    end
    properties (Access = private)
        base        = struct('posi',[0 0 0 1]', 'orien',[1 0 0 1; 0 1 0 1; 0 0 1 1]');
        frame       = struct('posi',[0 0 0],    'orien',eye(3));
        DHMatrix    = eye(4);
        plotLink    = [];
        plotAxises  = struct('xyz',[], 'enabled',false);
    end
    
    methods
        %% Input Link Object Params
        function linkObj = C_Link(linkType,DHParam,simuFunction,previousLink)
            if nargin == 0
            elseif (nargin == 3) || (nargin == 4)
                linkObj.type         = linkType;
                linkObj.a            = DHParam(1);
                linkObj.alpha        = deg2rad(DHParam(2));
                linkObj.d            = DHParam(3);
                linkObj.theta        = deg2rad(DHParam(4));
                linkObj.simuFunction = simuFunction;
                
                % Insert this Link after the previous one to form a Linked List
                if nargin == 4
                    linkObj.insertAfter(previousLink);
                end
                
                % Calculate the 0Tn DHMatrix for this n-th Link
                if linkObj.isPrismatic
                    linkObj.desired = linkObj.d;
                elseif linkObj.isRevolute
                    linkObj.desired = linkObj.theta;
                end
                linkObj.calculateDHMatrix(false);
                linkObj.calculateEta(false);
            else
                error('Wrong number of input arguments.')
            end
        end
        
        %% Initialize
        function initialize(this, axisHandles)
            F_Simu_Ground(axisHandles,this.opacity);
            this.drawSimulation(axisHandles,true);
        end
        
        %% Re-calculate DHMatrixes on Params Changed
        function onParamChanged(this, axisHandles, paramName, paramValue, drawEnable)
            switch paramName
                case 'd'
                    if this.isPrismatic, this.desired = paramValue;
                    else,                error('This Link is not Prismatic.')
                    end
                case 'theta'
                    if this.isRevolute, this.desired = deg2rad(paramValue);
                    else,               error('This Link is not Revolute.')
                    end
                case 'opacity'
                    this.opacity = paramValue;
                    if isa(this.Next,'C_Link')
                        this.Next.onParamChanged(axisHandles,'opacity',paramValue,true);
                    end
                otherwise
                    error('Cannot clarify this param.')
            end
            if drawEnable
                this.draw(axisHandles,true);
            end
        end
        
        %% Axises display enable/disable
        function displayAxis(this, axisHandles, trueFalse)
            if trueFalse
                this.plotAxises.xyz     = F_Axises(axisHandles,this.frame.posi,this.frame.orien);
                this.plotAxises.enabled = true;
            else
                delete(this.plotAxises.xyz);
                this.plotAxises.enabled = false;
            end
        end
        
        %% Calculate desired value of variable param
        function setDesired(this, axisHandles, paramValue)
            this.desired = paramValue;
            if this.isPrismatic
                this.distance = this.desired - this.d;
            elseif this.isRevolute
                this.distance = this.desired - this.theta;
            end
            if abs(this.distance) > 0.0001
                if this.isPrismatic
                    tmp = this.d + this.distance;
                    this.onParamChanged(axisHandles,'d',tmp,true);
                elseif this.isRevolute
                    tmp = this.theta + this.distance;
                    this.onParamChanged(axisHandles,'theta',rad2deg(tmp),true);
                end
            end
        end
        
        %% Check if the Link is Prismatic or Revolute
        function trueFalse = isPrismatic(this)
            trueFalse = this.type.isPrismatic;
        end
        function trueFalse = isRevolute(this)
            trueFalse = this.type.isRevolute;
        end
        function trueFalse = isFixed(this)
            trueFalse = this.type.isFixed;
        end
        
        %% Get Properties (for debugging)
        function property = get(this, propertyName)
            switch propertyName
                case 'DHMatrix'
                    property = this.DHMatrix;
                case 'x'
                    property = round(this.frame.posi(1),2);
                case 'y'
                    property = round(this.frame.posi(2),2);
                case 'z'
                    property = round(this.frame.posi(3),2);
                case 'psi'
                    property = round(rad2deg(atan2(this.frame.orien(1,2),this.frame.orien(1,1))),2);
            end
        end
        
        %% Draw Simulation
        function draw(this, axisHandles, continueFlag)
            this.calculateDHMatrix(true);
            this.calculateEta(true);
            this.deleteSimulation(axisHandles,continueFlag);
            this.drawSimulation(axisHandles,continueFlag);
        end
    end
    
    methods (Access = private)
        %% Calculate DH Matrix recursively
        function calculateDHMatrix(this, continueFlag)
            if this.isPrismatic
                this.d     = this.desired;
            elseif this.isRevolute
                this.theta = this.desired;
            end
            tmpA     = this.a;
            tmpAlpha = this.alpha;
            tmpD     = this.d;
            tmpTheta = this.theta;
            
            subMatrix = [cos(tmpTheta)  -cos(tmpAlpha)*sin(tmpTheta)  sin(tmpAlpha)*sin(tmpTheta)  tmpA*cos(tmpTheta);...
                         sin(tmpTheta)  cos(tmpAlpha)*cos(tmpTheta)   -sin(tmpAlpha)*cos(tmpTheta) tmpA*sin(tmpTheta);...
                         0              sin(tmpAlpha)                 cos(tmpAlpha)                tmpD;...
                         0              0                             0                            1];
            
            % Multiple current Matrix with previous one to form a n-th DH Matrix         
            if isa(this.Prev, 'C_Link')
                this.DHMatrix = this.Prev.DHMatrix * subMatrix;
            else
                this.DHMatrix = subMatrix;
            end
            
            % Continue to calculate DH Matrix for following Links onParamChanged
            if continueFlag && isa(this.Next,'C_Link')
                this.Next.calculateDHMatrix(true);
            end
        end
        
        %% Calculate position and orientation vectors based on DH Matrix
        function calculateEta(this, continueFlag)
            % Calculate the position and orientation vectors of this Link
            tmpFrame        = this.DHMatrix * this.base.posi;
            this.frame.posi = tmpFrame(1:3)';
            
            tmpMatrix       = this.DHMatrix;
            tmpMatrix(:,4)  = [0 0 0 1]';
            for i = 1:3
                tmp = tmpMatrix * this.base.orien(:,i);
                this.frame.orien(i,:) = tmp(1:3)';
            end
            
            % Continue to calculate position& orientation for following Links
            if continueFlag && isa(this.Next,'C_Link')
                this.Next.calculateEta(true);
            end
        end
        
        %% Draw & delete simulation of Links
        function drawSimulation(this, axisHandles, continueFlag)
            this.plotLink = this.simuFunction(axisHandles,this.frame.posi,this.frame.orien,this.opacity);
            if this.plotAxises.enabled
                this.displayAxis(axisHandles,true);
            end
            if continueFlag && isa(this.Next,'C_Link')
                this.Next.drawSimulation(axisHandles,true);
            end
        end
        
        function deleteSimulation(this, axisHandles, continueFlag)
            delete(this.plotLink)
            if this.plotAxises.enabled
                delete(this.plotAxises.xyz);
            end
            if continueFlag && isa(this.Next,'C_Link')
                this.Next.deleteSimulation(axisHandles,true);
            end
        end
    end
end


