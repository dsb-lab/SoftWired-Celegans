% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath '../Dependencies'

% Print time
fprintf('RNetworks.m started: %s\n', datestr(datetime('now')))

% Check cores
numcores = feature('numcores');
ppool = parpool('local', numcores);

% Set random seed for reproducibility
runSeed = 1234;
rng(runSeed);

% Load network from the genetic algorithm
load('Networks.mat');
connectivityMatrix = fig6_Rdistro;
if isfile('fig6_Rdistro.csv')
    fprintf('Deleting previous fig6_Rdistro.csv...\n')
    delete 'fig6_Rdistro.csv';
end
nNeurons = size(connectivityMatrix, 1);

% Set simulation time
totalTime = 500;

% Create random weights between input and neurons
% weightInputNeuron = 2 * rand(nNeurons, 1) - 1;
weightInputNeuron = csvread('weights.csv');

% Define simulation parameters
timeHighMean = 8;
timeHighStd = 2;
timeLow = 10;
initialTimeLow = 15;
[inputPulsesBin, inputPulsesNum] = createInputPulses(timeHighMean, timeHighStd, initialTimeLow, timeLow, totalTime);

% Main loop
nPulses = 20;
nIterationsTotal = 1000;
nIterationsIntra = 52;
nIterationsInter = 32;
nBins = 100;
fprintf('Starting iterations...\n')

parfor iIteration = 1:nIterationsTotal
    
    % Dynamics Intra-series
    responseIntraseries = nan(nPulses, timeLow, nNeurons, nIterationsIntra);
    correlationIntraseries = nan(nNeurons, nPulses*(nPulses - 1)/2, nIterationsIntra);
    
    for iIterationIntra = 1:nIterationsIntra
        outputPulsesIrregular = simulateActivity(connectivityMatrix, inputPulsesBin, weightInputNeuron, totalTime);
        for iPulse = 1:nPulses
            indices = find(inputPulsesNum == iPulse);
            neuronActivityLow = nan(1, timeLow, nNeurons);
            neuronActivityLow(1,:,:) = normalize(outputPulsesIrregular(:, indices), 2)';
            responseIntraseries(iPulse, :, :, iIterationIntra) = neuronActivityLow;
        end 
        for iNeuron = 1:nNeurons
           correlationIntraseries(iNeuron, :, iIterationIntra) = nonzeros(triu(corrcoef(responseIntraseries(:, :, iNeuron, iIterationIntra)')) - eye(nPulses))';     
        end
    end
    
    % Dynamics Inter-series
    responseInterseries = nan(nIterationsInter, timeLow, nPulses, nNeurons);
    correlationInterseries = nan(nNeurons, nPulses, nIterationsInter*(nIterationsInter-1)/2); 
    
    for iIterationInter = 1:nIterationsInter
        outputPulsesIrregular = simulateActivity(connectivityMatrix, inputPulsesBin, weightInputNeuron, totalTime);
        for iPulse = 1:nPulses
            indices = find(inputPulsesNum == iPulse);
            neuronActivityLow = nan(1, timeLow, nNeurons);
            neuronActivityLow(1,:,:) = normalize(outputPulsesIrregular(:, indices), 2)';
            responseInterseries(iIterationInter, :, iPulse, :) = neuronActivityLow;
        end 
    end 
    for iNeuron = 1:nNeurons
        for iPulse = 1:nPulses
            correlationPulse = corrcoef(responseInterseries(:, :, iPulse, iNeuron)');
            correlationInterseries(iNeuron, iPulse, :) = nonzeros(triu(correlationPulse, 1));
        end
    end
    
    % Calculate mean of R
    R = zeros(nNeurons, 1);
    for iNeuron = 1:nNeurons
        R(iNeuron) = computeReliability(correlationIntraseries(iNeuron,:,:), correlationInterseries(iNeuron,:,:), nBins);
    end
    dlmwrite('fig6_Rdistro.csv', mean(R), '-append')
    fprintf('%d\n', iIteration);

end

% Print time
fprintf('RNetworks.m finished: %s\n', datestr(datetime('now')))
