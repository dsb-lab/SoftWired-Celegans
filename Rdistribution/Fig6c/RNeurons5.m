% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath '../Dependencies'

% Set random seed for reproducibility
runSeed = 1234;
rng(runSeed);

% Load network from the genetic algorithm
load("Networks.mat");
connectivityMatrix = randomInhi5;
legendLabel = 'Random 5\% inhibition';
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
nIterationsTotal = 1;
nIterationsIntra = 52;
nIterationsInter = 32;

for iIteration = 1:nIterationsTotal
    
    % Dynamics Intraseries
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
           correlationIntraseries(iNeuron, :, iIterationIntra) = nonzeros(triu(corrcoef(responseIntraseries(:, :, iNeuron, iIterationIntra)'), 1))';     
        end
    end
    
    % Dynamics Interseries
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
end

%% Calculate cumulative distribution and R for the different neurons

numNeuron = 200;
nBins = 100;
cumulativeDistIntra = nan(nNeurons, nBins);
cumulativeDistInter = nan(nNeurons, nBins);
R = nan(nNeurons, 1);
for iNeuron = 1:nNeurons
    cumulativeDistIntra(iNeuron, :) = computeCumulativeFromHistogram(correlationIntraseries(iNeuron,:,:), nBins);
    cumulativeDistInter(iNeuron, :) = computeCumulativeFromHistogram(correlationInterseries(iNeuron,:,:), nBins);
    R(iNeuron) = computeReliability(correlationIntraseries(iNeuron,:,:), correlationInterseries(iNeuron,:,:), nBins);
end

% Figure 1: CDF
figure('Position', [202 237 886 342])
subplot(1,2,1)
plot(linspace(0, 1, size(cumulativeDistIntra, 2)), cumulativeDistIntra(numNeuron, :))
hold on
plot(linspace(0, 1, size(cumulativeDistInter, 2)), cumulativeDistInter(numNeuron, :))
xlabel('Pearson Correlation Coefficient', 'FontSize', 18, 'Interpreter', 'Latex');
ylabel('cdf', 'FontSize', 18, 'Interpreter', 'Latex')
legend({'intra-series', 'inter-series'}, 'Location', 'NorthWest', 'FontSize', 15, 'Interpreter', 'Latex')

% Figure 2: AUROC
subplot(1,2,2)
random = 0:1;
plot(cumulativeDistInter(numNeuron, :), cumulativeDistIntra(numNeuron, :));
hold on
plot(random, random, 'k')
xlabel('cdf inter-series', 'FontSize', 18, 'Interpreter', 'Latex');
ylabel('cdf intra-series', 'FontSize', 18, 'Interpreter', 'Latex');
legend({strcat('$R = ', num2str(R(numNeuron)), '$')}, 'Location', 'NorthWest', 'FontSize', 15, 'Interpreter', 'Latex')

% Figure 3: Mean R Neurons
figure
histogram(R, 30, 'Normalization', 'probability');
xlabel('$R$','Interpreter', 'Latex', 'FontSize', 18);
ylabel('pdf', 'FontSize', 18, 'Interpreter', 'Latex');
legend(legendLabel, 'Location', 'NorthEast', 'Fontsize', 15, 'Interpreter', 'Latex')
