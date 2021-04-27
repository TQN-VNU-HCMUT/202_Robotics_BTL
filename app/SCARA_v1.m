
% Programmed by: Nguyen Thai Quang
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control

function varargout = SCARA_v1(varargin)
% SCARA_V1 MATLAB code for SCARA_v1.fig
%      SCARA_V1, by itself, creates a new SCARA_V1 or raises the existing
%      singleton*.
%
%      H = SCARA_V1 returns the handle to a new SCARA_V1 or the handle to
%      the existing singleton*.
%
%      SCARA_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCARA_V1.M with the given input arguments.
%
%      SCARA_V1('Property','Value',...) creates a new SCARA_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCARA_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCARA_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCARA_v1

% Last Modified by GUIDE v2.5 26-Apr-2021 23:37:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCARA_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @SCARA_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before SCARA_v1 is made visible.
function SCARA_v1_OpeningFcn(hObject, ~, handles, varargin)

% Create Links and link them together, respectively
a2 = 400;       d2 = 373.5;    theta2 = 180;
a3 = 250;                      theta3 = 0;
                d4 = 0;
alpha5 = 180;   d5 = -17;      theta5 = 0;

link(1) = C_Link('Revolute',  [0    0        0       0],      @F_Simu_Shoulder);
link(2) = C_Link('Revolute',  [a2   0        d2      theta2], @F_Simu_Elbow,   link(1));
link(3) = C_Link('Revolute',  [a3   0        0       theta3], @F_Simu_Wrist,   link(2));
link(4) = C_Link('Prismatic', [0    0        d4      0],      @F_Simu_Shaft,   link(3));
link(5) = C_Link('Revolute',  [0    alpha5   d5      theta5], @F_Simu_Gripper, link(4));

endEffectorHandles = [handles.endEffector_x, handles.endEffector_y,...
                      handles.endEffector_z, handles.endEffector_psi];
wholeSystem = C_WholeSystem(link,handles.axisWholeSystem,endEffectorHandles);

handles.wholeSystem = wholeSystem;
wholeSystem.initialize;

set(handles.slider_theta2,'Max',      359);
set(handles.slider_theta2,'Min',        0);
set(handles.slider_theta2,'Value', theta2);
set(handles.value_theta2, 'String',theta2);

set(handles.slider_theta3,'Max',      150);
set(handles.slider_theta3,'Min',     -150);
set(handles.slider_theta3,'Value', theta3);
set(handles.value_theta3, 'String',theta3);

set(handles.slider_d4,'Max',    0);
set(handles.slider_d4,'Min', -200);
set(handles.slider_d4,'Value', d4);
set(handles.value_d4, 'String',d4);

set(handles.slider_theta5,'Max',      359);
set(handles.slider_theta5,'Min',        0);
set(handles.slider_theta5,'Value', theta5);
set(handles.value_theta5, 'String',theta5);

set(handles.slider_opacity,'Max',     1);
set(handles.slider_opacity,'Min',     0);
set(handles.slider_opacity,'Value', 0.7);
set(handles.value_opacity, 'String',0.7);

set(handles.enable_axis1,'Value',false);
set(handles.enable_axis2,'Value',false);
set(handles.enable_axis3,'Value',false);
set(handles.enable_axis4,'Value',false);
set(handles.enable_axis5,'Value',false);

handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes SCARA_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SCARA_v1_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function axisWholeSystem_CreateFcn(~, ~, ~)
function axisQ_CreateFcn(~, ~, ~)
function axisV_CreateFcn(~, ~, ~)
function axisA_CreateFcn(~, ~, ~)
function popupmenu2_CreateFcn(~, ~, ~)

%-------------------------------------------------%
%-------------------------------------------------%

function slider_theta2_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function slider_theta2_Callback(hObject, ~, handles)
    sliderValue = get(hObject,'Value');
    set(handles.value_theta2,'String',sliderValue);
    handles.wholeSystem.onParamChanged(2,'theta',sliderValue);
function value_theta2_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function value_theta2_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
    outputValue = F_Limit_Variable(handles.slider_theta2, textBoxValue);
    set(handles.slider_theta2,'Value',outputValue);
    set(hObject,'String',outputValue);
    handles.wholeSystem.onParamChanged(2,'theta',outputValue);

%-------------------------------------------------%
%-------------------------------------------------%

function slider_theta3_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function slider_theta3_Callback(hObject, ~, handles)
    sliderValue = get(hObject,'Value');
    set(handles.value_theta3,'String',sliderValue);
    handles.wholeSystem.onParamChanged(3,'theta',sliderValue);
function value_theta3_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function value_theta3_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
    outputValue = F_Limit_Variable(handles.slider_theta3, textBoxValue);
    set(handles.slider_theta3,'Value',outputValue);
    set(hObject,'String',outputValue);
    handles.wholeSystem.onParamChanged(3,'theta',outputValue);

%-------------------------------------------------%
%-------------------------------------------------%

function slider_d4_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function slider_d4_Callback(hObject, ~, handles)
    sliderValue = get(hObject,'Value');
    set(handles.value_d4,'String',sliderValue);
    handles.wholeSystem.onParamChanged(4,'d',sliderValue);
function value_d4_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function value_d4_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
    outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    set(handles.slider_d4,'Value',outputValue);
    set(hObject,'String',outputValue);
    handles.wholeSystem.onParamChanged(4,'d',outputValue);

%-------------------------------------------------%
%-------------------------------------------------%

function slider_theta5_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function slider_theta5_Callback(hObject, ~, handles)
    sliderValue = get(hObject,'Value');
    set(handles.value_theta5,'String',sliderValue);
    handles.wholeSystem.onParamChanged(5,'theta',sliderValue);
function value_theta5_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function value_theta5_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
    outputValue = F_Limit_Variable(handles.slider_theta5,textBoxValue);
    set(handles.slider_theta5,'Value',outputValue);
    set(hObject,'String',outputValue);
    handles.wholeSystem.onParamChanged(5,'theta',outputValue);

%-------------------------------------------------%
%-------------------------------------------------%     

function slider_opacity_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function slider_opacity_Callback(hObject, ~, handles)
    sliderValue = get(hObject,'Value');
    set(handles.value_opacity,'String',sliderValue);
    handles.wholeSystem.onParamChanged(1,'opacity',sliderValue);
function value_opacity_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function value_opacity_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
    outputValue = F_Limit_Variable(handles.slider_opacity, textBoxValue);
    set(handles.slider_opacity,'Value',outputValue);
    set(hObject,'String',outputValue);
    handles.wholeSystem.onParamChanged(1,'opacity',outputValue); 

%-------------------------------------------------%
%-------------------------------------------------%

function enable_axis1_Callback(hObject, ~, handles)
    handles.wholeSystem.displayAxis(1,get(hObject,'Value'));
function enable_axis2_Callback(hObject, ~, handles)
    handles.wholeSystem.displayAxis(2,get(hObject,'Value'));
function enable_axis3_Callback(hObject, ~, handles)
    handles.wholeSystem.displayAxis(3,get(hObject,'Value'));
function enable_axis4_Callback(hObject, ~, handles)
    handles.wholeSystem.displayAxis(4,get(hObject,'Value'));
function enable_axis5_Callback(hObject, ~, handles)
    handles.wholeSystem.displayAxis(5,get(hObject,'Value'));

%-------------------------------------------------%
%-------------------------------------------------%

function button_gotoDest_Callback(~, ~, handles)
    handles.wholeSystem.gotoDest;


function wholeSystemMode_Callback(hObject, ~, handles)
    contents   = cellstr(get(hObject,'String'));
    systemMode = contents{get(hObject,'Value')};
    handles.wholeSystem.set('mode',systemMode);
    
    if strcmp(systemMode,'ForwardKinematics_1')
        set(handles.button_gotoDest,'Visible','off');
        set(handles.inversed_panel,'Visible','off');
    elseif strcmp(systemMode,'ForwardKinematics_2')
        set(handles.button_gotoDest,'Visible','on');
        set(handles.inversed_panel,'Visible','off');
    elseif strcmp(systemMode,'InversedKinematics')
        set(handles.button_gotoDest,'Visible','on');
        set(handles.inversed_panel,'Visible','on');
    end
    
function inversed_panel_CreateFcn(~, ~, ~)



function desired_x_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.wholeSystem.set('x',textBoxValue);
function desired_x_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function desired_y_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.wholeSystem.set('y',textBoxValue);

function desired_y_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function desired_z_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.wholeSystem.set('z',textBoxValue);

function desired_z_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function desired_psi_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.wholeSystem.set('psi',textBoxValue);

function desired_psi_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function button_deletePath_Callback(~, ~, handles)
    handles.wholeSystem.deletePath;


