classdef C_LinkType
    enumeration
        Prismatic
        Revolute
        Fixed
    end
    methods
        function trueFalse = isPrismatic(obj)
                trueFalse = C_LinkType.Prismatic == obj;
        end
        function trueFalse = isRevolute(obj)
                trueFalse = C_LinkType.Revolute == obj;
        end
        function trueFalse = isFixed(obj)
                trueFalse = C_LinkType.Fixed == obj;
        end
    end
end
