% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath '../Dependencies'

% Load data
load newConnectome_minimal.mat  % Connectome
load worm_data.mat  % Neural signals

% Clean workspace
clearvars -except neurons_pruned neuronal_data A_pruned list_pruned

% Print number of cores
numcores = feature('numcores');
ppool = parpool('local',numcores);

% Normalize and Standardize Data
neuronalDataStandardized = normalizeSignals(neuronal_data);

% Normalize connectivity matrix by dividing each row by its maximum
A = A_pruned/max(max(A_pruned)); % Normalization for genetic algorithm

% Set Algorithm Parameters
nIterations = 100; % Number of iterations of the optimization
nIndividuals = 100; % Number of total individuals of the population
nSelected = 30; % Number of individuals selected
nChildren = 50; % Number of individuals of the offspring
nImmigrants = 20; % Number of individuals of the migration
nMutations = 5;

% Initialization of variables
bestIndividualsAll = cell(nIterations, 6); % Stores connectivity matrix, signals and correlation of best individuals
bestIndividualIteration = NaN(nIterations, 1); % Index of Best individuals of each iteration
inputs = [neuronalDataStandardized(32,:); neuronalDataStandardized(69,:)]; % Corrsponds to temperature neurons: AFDL (32) & AFDR (69)
time = linspace(0, length(neuronal_data)/10, length(neuronal_data));

% Create random stream
runSeed = 433; %644; %23011
s = RandStream.create('mrg32k3a','NumStreams',1,'Seed',runSeed);
CC = NaN(7, nIterations);

% Real sign
realSign = csvread('csv/sign.csv');
indexes = find(realSign ~= 0);
idxNeurons = [127 157 155 141 142 148 167];
bestIndividualRatio = NaN(1,nIterations);

% Initialize first population
nextPopulation = generateRandomIndividuals(A, nIndividuals, s); % Generate random population in the first iteration

% Intialize time
t1 = datetime();
fprintf('%s\n',pad(' Genetic Algorithm ',62,'both','-'));
fig = figure('Position', get(0,'ScreenSize'));

for iterations = 1:nIterations
    
    individualStates = simulateReservoirPar(nextPopulation,inputs); % Generate signals for each neuron of each individual
    [meanFitness, fitnessPopulation] = calculateFitness(individualStates, neuronalDataStandardized); % Calculate the fitness for each individual
    [bestFitness, bestIndividuals] = sort(meanFitness, 'descend'); % Sort the mean fitness for each individual % * Fitness maximize or minimize??
    bestIndividualsAll{iterations,1} = nextPopulation{bestIndividuals(1)}; % First column: best connectivity matrix
    bestIndividualsAll{iterations,2} = individualStates{bestIndividuals(1)}; % Second column: best time series from simulation
    bestIndividualsAll{iterations,3} = fitnessPopulation{bestIndividuals(1)};
    bestIndividualsAll{iterations,4} = meanFitness(bestIndividuals(1)); % Third column: best mean fitness
    bestSign = (sum(bestIndividualsAll{iterations,1},2) > 0) + -(sum(bestIndividualsAll{iterations,1},2) < 0);
    accuracyAll = 100*sum(realSign(indexes) == bestSign(indexes))/length(indexes);
    bestIndividualsAll{iterations,5} = accuracyAll ;
    accuracy7 = sum(realSign(idxNeurons) == bestSign(idxNeurons));
    bestIndividualsAll{iterations,6} = accuracy7;
    nextPopulation = generateNextPopulation(nextPopulation, A, bestIndividuals, nSelected, nChildren, nImmigrants, nMutations, s);
    bestIndividualIteration(iterations) = max([bestIndividualsAll{:,4}]); %mean(mean_fitness);%max([best_individuals_all{:,4}]);
    bestIndividualRatio(iterations) = calculateExciInhiRatio([bestIndividualsAll{iterations,1}]);%;ratioEI(next_population);%ratioEI([best_individuals_all{iterations,1}]);
    
if mod(iterations,5) == 0
    t2 = datetime();
    fprintf('\nIterations completed: %40d\n', iterations);
    fprintf('Mean time per iteration: %37s\n', (t2-t1)/iterations);
    fprintf('Estimated time to complete iterations: %23s\n', (t2-t1)/iterations*(nIterations-iterations))
    fprintf('Mean fitness of selected individuals (%d/%d): %15.5f\n', nSelected, nIndividuals, mean(bestFitness(1:nSelected)));
    fprintf('Fitness of best individual: %34.5f\n', max([bestIndividualsAll{:,4}]));
    fprintf('Percentage of inhibition of best individual: %16.3f%%\n\n', calculateExciInhiRatio(bestIndividualsAll{iterations,1}))
    clf;
    plotData(iterations, bestIndividualIteration(1:iterations), bestIndividualsAll(1:iterations,:), bestIndividualRatio(1:iterations),...
        neuronalDataStandardized, time)
    drawnow;
end

end

fprintf('%s\n',pad(' end ',62,'both','-'));

saveData(bestIndividualsAll, bestIndividualIteration, bestIndividualRatio, nIterations, idxNeurons, 'genetic', runSeed)