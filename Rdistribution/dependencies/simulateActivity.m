function timeSeries = simulateActivity(connectivityMatrix, externalInput, weightInputNeuron, totalTime)
% connectivityMatrix: W (numNeurons x numNeurons)
% externalInputs: z (1 x totalTime)
% weightInputNeuron: v (1 x numNeurons)
% totalTime: t

% Initialize time series and numNeurons
nNeurons = size(connectivityMatrix, 1);
timeSeries = nan(nNeurons, totalTime);

% Initialize initial conditions of each neuron
initialConditions = 2 * rand(nNeurons, 1) - 1;
timeSeries(:, 1) = initialConditions;

for time = 2:totalTime
    timeSeries(:, time) = tanh(weightInputNeuron * externalInput(1, time) + connectivityMatrix * timeSeries(:, time - 1));
end


end

