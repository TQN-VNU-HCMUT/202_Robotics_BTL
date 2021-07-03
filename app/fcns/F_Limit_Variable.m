
% Programmed by: Quang-Nguyen Thai
% Program date: 29th March 2021
% Robotics: Modelling, Planning and Control
% Contact: nguyenquangthai03122000@gmail.com

function outputValue = F_Limit_Variable(handles, inputValue)
    maxValue = get(handles,'Max');
    minValue = get(handles,'Min');
    if inputValue > maxValue
        outputValue = maxValue;
    elseif inputValue < minValue
        outputValue = minValue;
    else
        outputValue = inputValue;
    end
end

