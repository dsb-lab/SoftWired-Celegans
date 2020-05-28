function neuronalDataStandardized = normalizeSignals(neuronalData)
% 
% Function: 
% – normalizeSignals: Standardizes time series. Function needed in versions
%   of Matlab earlier than 2018a. Since 2018a onwards, a built-in normalize 
%   function is available.
%
% Inputs:
% - neuronalData: Neuronal time series.
% 
% Returns:
% - neuronalDataStandardized: Neuronal time series with mean 0 and std 1.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

neuronalDataStandardized = (neuronalData - mean(neuronalData, 2))./(std(neuronalData, 0, 2));

end

