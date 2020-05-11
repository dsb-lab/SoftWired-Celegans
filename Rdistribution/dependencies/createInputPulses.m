function [inputPulsesBin, inputPulsesNum] = createInputPulses(timeHighMean, timeHighStd, initialTimeLow, timeLow, totalTime)
% timeHigh (2 x 1): Mean and std of the 1 state
% timeLow (1): Duration of the 0 state
% totalTime (1): Total time of the simulation

% Initialize inputPulse
inputPulsesBin = zeros(1, totalTime);
inputPulsesNum = zeros(1, totalTime);

isPulseCompleted = false;
currentTime = initialTimeLow;
currentPulse = 1;

% Loop until pulse is completed
while ~isPulseCompleted
    timeHigh = timeHighMean + round(2 * timeHighStd * rand(1) - 1);  
    if currentTime + timeHigh > totalTime
        isPulseCompleted = true;
    else
        % Add state 1
        inputPulsesBin(currentTime+1:currentTime+timeHigh) = 1;
        currentTime = currentTime + timeHigh;
        
        % Add pulse num
        if currentTime + timeLow > totalTime
            inputPulsesNum(currentTime+1:end) = currentPulse;
        else
            inputPulsesNum(currentTime+1:currentTime+timeLow) = currentPulse;
        end
        currentTime = currentTime + timeLow;  
        currentPulse = currentPulse + 1;
    end
end


end

