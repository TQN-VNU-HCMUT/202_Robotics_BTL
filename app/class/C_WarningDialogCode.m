
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

classdef C_WarningDialogCode
    enumeration
        WrongInput ('Invalid input detected. Please try again.')
    end
    properties
        msg
    end
    methods
        function warningDialogCodeObj = C_WarningDialogCode(msg)
            warningDialogCodeObj.msg = msg;
        end
        function trueFalse = isWrongInput(this)
            trueFalse = C_WarningDialogCode.WrongInput == this;
        end
    end
    
end

