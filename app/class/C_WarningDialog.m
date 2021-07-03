
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

classdef C_WarningDialog
    properties
        panelHandle
        textboxHandle
        msgCode C_WarningDialogCode
    end
    
    methods
        function warningDialogObj = C_WarningDialog(panelHandle, textboxHandle)
            warningDialogObj.panelHandle   = panelHandle;
            warningDialogObj.textboxHandle = textboxHandle;
        end
        function appear(this, msgCode)
            this.msgCode = msgCode;
            set(this.textboxHandle, 'String',  this.msgCode.msg);
            set(this.panelHandle,   'Visible', 'on');
        end
        function hide(this)
            set(this.panelHandle, 'Visible', 'off');
        end
    end
    
end

