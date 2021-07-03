
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

function varargout = SCARA_v1(varargin)
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
    % Create a C_WarningDialog object
    warningDialog = C_WarningDialog(handles.panel_dialog, handles.text_dialog_detail);
    handles.warningDialog = warningDialog;

    % Create Links and link them together, respectively
    a2 = 400;       d2 = 373.5;    theta2 = 180;
    a3 = 250;                      theta3 = 0;
                    d4 = 0;
    alpha5 = 180;   d5 = -17;      theta5 = 0;

    link(1) = C_Link('Revolute',  [0    0        0    0],      @F_Simu_Shoulder);
    link(2) = C_Link('Revolute',  [a2   0        d2   theta2], @F_Simu_Elbow,   handles.slider_theta2, handles.value_theta2, link(1));
    link(3) = C_Link('Revolute',  [a3   0        0    theta3], @F_Simu_Wrist,   handles.slider_theta3, handles.value_theta3, link(2));
    link(4) = C_Link('Prismatic', [0    0        d4   0],      @F_Simu_Shaft,   handles.slider_d4,     handles.value_d4,     link(3));
    link(5) = C_Link('Revolute',  [0    alpha5   d5   theta5], @F_Simu_Gripper, handles.slider_theta5, handles.value_theta5, link(4));

    endEffectorHandles = [handles.endEffector_x, handles.endEffector_y,...
                          handles.endEffector_z, handles.endEffector_psi];

    wholeSystem = C_WholeSystem(link, handles.axisWholeSystem, endEffectorHandles, handles.consoleWindow);
    wholeSystem.initTrajectoryTabs(handles.TabA01, handles.TabA02);

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

    % Initialise tabs
    handles.trajectoryTabManager = TabManager(hObject);

    % Set-up a selection changed function on the create tab groups
    trajectoryTabGroups = handles.trajectoryTabManager.TabGroups;
    for tgi=1:length(trajectoryTabGroups)
    %     set(trajectoryTabGroups(tgi),'SelectionChangedFcn',@tabChangedCB)
    end

    handles.desired = struct('x',[],'y',[],'z',[],'psi',[],'aMax',[],'radius',[]);

    handles.output = hObject;
    guidata(hObject, handles);

% UIWAIT makes SCARA_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = SCARA_v1_OutputFcn(~, ~, handles)
    varargout{1} = handles.output;

function axisWholeSystem_CreateFcn(~, ~, ~)
function TabA01_CreateFcn(~, ~, ~)
function popupmenu2_CreateFcn(~, ~, ~)
function inversed_panel_CreateFcn(~, ~, ~)

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
    if isnan(textBoxValue)
        handles.warningDialog.appear(C_WarningDialogCode.WrongInput);
    else
        outputValue = F_Limit_Variable(handles.slider_theta2, textBoxValue);
        set(handles.slider_theta2,'Value',outputValue);
        set(hObject,'String',outputValue);
        handles.wholeSystem.onParamChanged(2,'theta',outputValue);
    end

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
    if isnan(textBoxValue)
        handles.warningDialog.appear(C_WarningDialogCode.WrongInput);
    else
        outputValue = F_Limit_Variable(handles.slider_theta3, textBoxValue);
        set(handles.slider_theta3,'Value',outputValue);
        set(hObject,'String',outputValue);
        handles.wholeSystem.onParamChanged(3,'theta',outputValue);
    end

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
    if isnan(textBoxValue)
        handles.warningDialog.appear(C_WarningDialogCode.WrongInput);
    else
        outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
        set(handles.slider_d4,'Value',outputValue);
        set(hObject,'String',outputValue);
        handles.wholeSystem.onParamChanged(4,'d',outputValue);
    end

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
    if isnan(textBoxValue)
        handles.warningDialog.appear(C_WarningDialogCode.WrongInput);
    else
        outputValue = F_Limit_Variable(handles.slider_theta5,textBoxValue);
        set(handles.slider_theta5,'Value',outputValue);
        set(hObject,'String',outputValue);
        handles.wholeSystem.onParamChanged(5,'theta',outputValue);
    end

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
    if isnan(textBoxValue)
        handles.warningDialog.appear(C_WarningDialogCode.WrongInput);
    else
        outputValue = F_Limit_Variable(handles.slider_opacity, textBoxValue);
        set(handles.slider_opacity,'Value',outputValue);
        set(hObject,'String',outputValue);
        handles.wholeSystem.onParamChanged(1,'opacity',outputValue); 
    end

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
    handles.desired.x      = str2double(get(handles.desired_x,      'String'));
    handles.desired.y      = str2double(get(handles.desired_y,      'String'));
    handles.desired.z      = str2double(get(handles.desired_z,      'String'));
    handles.desired.psi    = str2double(get(handles.desired_psi,    'String'));
    handles.desired.aMax   = str2double(get(handles.desired_aMax,   'String'));
    handles.desired.radius = str2double(get(handles.desired_radius, 'String'));
    fields = fieldnames(handles.desired);
    cnt    = 0;
    for i = 1:length(fields)
        textBoxValue = handles.desired.(fields{i});
        if isnan(textBoxValue)
            handles.warningDialog.appear(C_WarningDialogCode.WrongInput);
            cnt = cnt + 1;
        else
            handles.wholeSystem.set(fields{i,1},textBoxValue);
        end
    end
    if cnt == 0
        handles.wholeSystem.gotoDest;
    end

function wholeSystemMode_Callback(hObject, ~, handles)
    contents   = cellstr(get(hObject,'String'));
    systemMode = contents{get(hObject,'Value')};
    handles.wholeSystem.set('mode',systemMode);
    
    if strcmp(systemMode,'ForwardKinematics_1')
        set(handles.button_gotoDest,    'Visible',  'off');
        set(handles.inversed_panel,     'Visible',  'off');
        set(handles.button_deletePath,  'Visible',  'off');
    elseif strcmp(systemMode,'ForwardKinematics_2')
        set(handles.button_gotoDest,    'Visible',  'on');
        set(handles.inversed_panel,     'Visible',  'off');
        set(handles.button_deletePath,  'Visible',  'off');
    elseif strcmp(systemMode,'InversedKinematics_Straight')
        set(handles.button_gotoDest,    'Visible',  'on');
        set(handles.inversed_panel,     'Visible',  'on');
        set(handles.button_deletePath,  'Visible',  'on');
        set(handles.desired_radius,     'Visible',  'off');
        set(handles.text_radius,        'Visible',  'off');
        
        set(handles.desired_x,          'String',   num2str(handles.wholeSystem.current.x));
        set(handles.desired_y,          'String',   num2str(handles.wholeSystem.current.y));
        set(handles.desired_z,          'String',   num2str(handles.wholeSystem.current.z));
        set(handles.desired_psi,        'String',   num2str(handles.wholeSystem.current.psi));
        set(handles.desired_aMax,       'String',   num2str(handles.wholeSystem.desired.aMax));
    elseif strcmp(systemMode,'InversedKinematics_Circular')
        set(handles.button_gotoDest,    'Visible',  'on');
        set(handles.inversed_panel,     'Visible',  'on');
        set(handles.button_deletePath,  'Visible',  'on');
        set(handles.desired_radius,     'Visible',  'on');
        set(handles.text_radius,        'Visible',  'on');
        
        set(handles.desired_x,          'String',   num2str(handles.wholeSystem.current.x));
        set(handles.desired_y,          'String',   num2str(handles.wholeSystem.current.y));
        set(handles.desired_z,          'String',   num2str(handles.wholeSystem.current.z));
        set(handles.desired_psi,        'String',   num2str(handles.wholeSystem.current.psi));
        set(handles.desired_aMax,       'String',   num2str(handles.wholeSystem.desired.aMax));
        set(handles.desired_radius,     'String',   num2str(handles.wholeSystem.desired.radius));
    end
    

function desired_x_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.desired.x = textBoxValue;
    guidata(hObject, handles);
function desired_x_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function desired_y_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.desired.y = textBoxValue;
    guidata(hObject, handles);
function desired_y_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function desired_z_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.desired.z = textBoxValue;
    guidata(hObject, handles);
function desired_z_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function desired_psi_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.desired.psi = textBoxValue;
    guidata(hObject, handles);
function desired_psi_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function desired_aMax_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.desired.aMax = textBoxValue;
    guidata(hObject, handles);

function desired_aMax_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function desired_radius_Callback(hObject, ~, handles)
    textBoxValue = str2double(get(hObject,'String'));
%     outputValue = F_Limit_Variable(handles.slider_d4, textBoxValue);
    handles.desired.radius = textBoxValue;
    guidata(hObject, handles);
function desired_radius_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function button_deletePath_Callback(~, ~, handles)
    handles.wholeSystem.deletePath;


function consoleWindow_Callback(~, ~, ~)
function consoleWindow_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function button_dialog_ok_Callback(~, ~, handles)
    handles.warningDialog.hide;
    
