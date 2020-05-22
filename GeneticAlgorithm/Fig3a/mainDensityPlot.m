% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath '../Dependencies'

% Load data
load connectomeData.mat  % Connectome
load wormData.mat  % Neural signals

% Clear other variables
clearvars -except connectomeNormMax listPruned neuronalData connectomePruned

% Print number of cores
numcores = feature('numcores');
parpool('local', numcores)

% Normalize and Standardize Data
neuronalDataStandardized = normalize(neuronalData);

% Normalize connectivity matrix by dividing each row by its maximum%
A = connectomePruned/max(max(connectomePruned));

% Set Algorithm Parameters
nIterations = 100; % Number of iterations of the optimization
nIndividuals = 100; % Number of total individuals of the population
nSelected = 30; % Number of individuals selected
nChildren = 50; % Number of individuals of the offspring
nImmigrants = 20; % Number of individuals of the migration
nMutations = 5;

% Note: num_individuals = num_selected + num_children + num_immigrants

% Number of genetic algorithms to start
nGeneticAlgorithms = 100;

datetime('now')

parfor iGeneticAlgorithm = 1:nGeneticAlgorithms
    
    % Initialization of variables
    bestIndividualsAll = {}; % Stores connectivity matrix, signals and correlation of best individuals
    bestIndividualIteration = []; % Index of Best individuals of each iteration
    inputs = [neuronalDataStandardized(32,:); neuronalDataStandardized(69,:)]; % Corrsponds to temperature neurons: AFDL (32) & AFDR (69)
    time = linspace(0, length(neuronal_data)/10, length(neuronal_data));
    CC = zeros(7, nIterations);

    % Create random stream    
    runSeed = iGeneticAlgorithm + 50; % For reproducing individual seeds if necessary
    s1 = RandStream.create('mrg32k3a', 'NumStreams', 1, 'Seed', runSeed);
    bestIndividualRatio = zeros(1,nIterations);

    for iIteration = 1:nIterations
        if iIteration == 1
            initialPopulation = generateRandomIndividuals(A, nIndividuals, s1); % Generate random population in the first iteration
            individualsStates = simulateReservoirNopar(initialPopulation,inputs); % Generate signals for each neuron of each individual
            [meanFitness, fitnessPopulation] = calculateFitness(individualsStates,neuronalDataStandardized); % Calculate the fitness for each individual
            [bestFitness, bestIndividuals] = sort(meanFitness,'descend'); % Sort the mean fitness for each individual % * Fitness maximize or minimize??
            bestIndividualsAll{iIteration, 1} = initialPopulation{bestIndividuals(1)}; % First column: best connectivity matrix
            bestIndividualsAll{iIteration, 2} = individualsStates{bestIndividuals(1)}; % Second column: best time series from simulation
            bestIndividualsAll{iIteration, 3} = fitnessPopulation{bestIndividuals(1)};
            bestIndividualsAll{iIteration, 4} = meanFitness(bestIndividuals(1)); % Third column: best mean fitness  
            nextPopulation = generateNextPopulation(initialPopulation, A, bestIndividuals, nSelected, nChildren, nImmigrants, nMutations, s1);
            bestIndividualIteration(iIteration) = max([bestIndividualsAll{:,4}]);
            bestIndividualRatio(iIteration) = calculateExciInhiRatio([bestIndividualsAll{end,1}]);
        else
            newPopulation = nextPopulation; %clearvars next_population;
            individualsStates = simulateReservoirNopar(newPopulation, inputs);
            [meanFitness, fitnessPopulation] = calculateFitness(individualsStates, neuronalDataStandardized);
            [bestFitness, bestIndividuals] = sort(meanFitness, 'descend');
            bestIndividualsAll{iIteration, 1} = newPopulation{bestIndividuals(1)};
            best_sign = (sum(bestIndividualsAll{iIteration,1},2) > 0) + -(sum(bestIndividualsAll{iIteration,1},2) < 0);
            bestIndividualsAll{iIteration, 2} = individualsStates{bestIndividuals(1)};
            bestIndividualsAll{iIteration, 3} = fitnessPopulation{bestIndividuals(1)};
            bestIndividualsAll{iIteration, 4} = meanFitness(bestIndividuals(1));
            nextPopulation = generateNextPopulation(newPopulation, A, bestIndividuals, nSelected, nChildren, nImmigrants, nMutations, s1);
            bestIndividualIteration(iIteration) = max([bestIndividualsAll{:, 4}]);
            bestIndividualRatio(iIteration) = calculateExciInhiRatio([bestIndividualsAll{end, 1}]);
        end

    dlmwrite('density_plot.csv',[runSeed,bestIndividualRatio(iIteration), bestIndividualsAll{iIteration,4}],'-append');

    end

    fprintf([num2str(iGeneticAlgorithm),'/',num2str(nGeneticAlgorithms),'\n']);

end

datetime('now')

% Uncomment to save 
% density_plot = unique(cluster_matrix,'rows');
% csvwrite('density_plot.csv', density_plot);

