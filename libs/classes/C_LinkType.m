
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

classdef C_LinkType
    enumeration
        Prismatic
        Revolute
    end
    methods
        function trueFalse = isPrismatic(obj)
                trueFalse = C_LinkType.Prismatic == obj;
        end
        function trueFalse = isRevolute(obj)
                trueFalse = C_LinkType.Revolute == obj;
        end
    end
end
