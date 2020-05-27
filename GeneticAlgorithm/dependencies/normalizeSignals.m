function normalizedData = normalizeSignals(data)
% Standardizes time series. Function needed in versions of Matlab earlier
% than 2018a. Since 2018a onwards, a built-in normalize function is available.

normalizedData = (data - mean(data, 2))./(std(data, 0, 2));

end

