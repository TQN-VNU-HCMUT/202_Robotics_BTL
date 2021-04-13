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

