function [Xout, Yout, Zout] = F_Shift_Along_Vector(Xin,Yin,Zin,orientation,height)
    output   = zeros(3,length(Xin),'double');
    for i = 1:length(Xin)
        output(:,i) = [Xin(i) + orientation(1)*height;...
                       Yin(i) + orientation(2)*height;...
                       Zin(i) + orientation(3)*height];
    end
    Xout = output(1,:);
    Yout = output(2,:);
    Zout = output(3,:);
end

