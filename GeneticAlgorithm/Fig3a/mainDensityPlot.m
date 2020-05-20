% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath '../Dependencies'

% Load pruned data 
load data_python_50.mat

% Load neuronal_data
load worm_data.mat
delete 'cluster_matrix.csv';

% Clear other variables
clearvars -except A_norm_max list_prunned neuronal_data A_prunned

% Print number of cores
numcores = feature('numcores');
parpool('local',numcores)

% Normalize and Standardize Data
neuronal_data_standardized = normalize(neuronal_data);

% Normalize connectivity matrix by dividing each row by its maximum%
A = A_prunned/max(max(A_prunned));

% Set Algorithm Parameters
num_iterations_algorithm = 100; % Number of iterations of the optimization
num_individuals = 100; % Number of total individuals of the population
num_selected = 30; % Number of individuals selected
num_children = 50; % Number of individuals of the offspring
num_immigrants = 20; % Number of individuals of the migration

% Note: num_individuals = num_selected + num_children + num_immigrants

% Real sign
real_sign = csvread('sign.csv');
indexes = find(real_sign ~= 0);
neurons_indexes = [13, 54, 56, 58, 59, 173, 188];

% Cluster matrix
num_iterations_cluster = 100;

datetime('now')

parfor cluster_iterations = 1:num_iterations_cluster
    
% Initialization of variables
best_individuals_all = {}; % Stores connectivity matrix, signals and correlation of best individuals
best_individual_iteration = []; % Index of Best individuals of each iteration
inputs = [neuronal_data_standardized(32,:);neuronal_data_standardized(69,:)]; % Corrsponds to temperature neurons: AFDL (32) & AFDR (69)
time = linspace(0,length(neuronal_data)/10,length(neuronal_data));
CC = zeros(7,num_iterations_algorithm);
    
% Create random stream    
runSeed = cluster_iterations+50; %23011
s1 = RandStream.create('mrg32k3a','NumStreams',1,'Seed',runSeed);

best_individual_ratio = zeros(1,num_iterations_algorithm);

for iterations = 1:num_iterations_algorithm
if iterations == 1
    tic;
    initial_population = random_individuals(A,num_individuals,s1); % Generate random population in the first iteration
    individuals_states = reservoir_simulation_nopar(initial_population,inputs); % Generate signals for each neuron of each individual
    [mean_fitness, fitness_population] = fitness(individuals_states,neuronal_data_standardized); % Calculate the fitness for each individual
    [best_fitness, best_individuals] = sort(mean_fitness,'descend'); % Sort the mean fitness for each individual % * Fitness maximize or minimize??
    best_individuals_all{iterations,1} = initial_population{best_individuals(1)}; % First column: best connectivity matrix
    best_individuals_all{iterations,2} = individuals_states{best_individuals(1)}; % Second column: best time series from simulation
    best_individuals_all{iterations,3} = fitness_population{best_individuals(1)};
    best_individuals_all{iterations,4} = mean_fitness(best_individuals(1)); % Third column: best mean fitness
    best_sign = (sum(best_individuals_all{iterations,1},2) > 0) + -(sum(best_individuals_all{iterations,1},2) < 0);
    accuracy_all = 100*sum(real_sign(indexes) == best_sign(indexes))/length(indexes);
    best_individuals_all{iterations,5} = accuracy_all ;
    accuracy_7 = sum(real_sign(neurons_indexes) == best_sign(neurons_indexes));
    best_individuals_all{iterations,6} = accuracy_7;
    next_population = next_generation(initial_population,A,best_individuals, num_selected, num_children, num_immigrants,s1);
    best_individual_iteration(iterations) = max([best_individuals_all{:,4}]);
    best_individual_ratio(iterations) = ratioEI([best_individuals_all{end,1}]);
    
else
    new_population = next_population; %clearvars next_population;
    individuals_states = reservoir_simulation_nopar(new_population,inputs);
    [mean_fitness, fitness_population] = fitness(individuals_states,neuronal_data_standardized);
    [best_fitness, best_individuals] = sort(mean_fitness,'descend');
    best_individuals_all{iterations,1} = new_population{best_individuals(1)};
    best_sign = (sum(best_individuals_all{iterations,1},2) > 0) + -(sum(best_individuals_all{iterations,1},2) < 0);
    accuracy_all = 100*sum(real_sign(indexes) == best_sign(indexes))/length(indexes);
    best_individuals_all{iterations,2} = individuals_states{best_individuals(1)};
    best_individuals_all{iterations,3} = fitness_population{best_individuals(1)};
    best_individuals_all{iterations,4} = mean_fitness(best_individuals(1));
    best_individuals_all{iterations,5} = accuracy_all ;
    accuracy_7 = sum(real_sign(neurons_indexes) == best_sign(neurons_indexes));
    best_individuals_all{iterations,6} = accuracy_7;
    next_population = next_generation(new_population,A,best_individuals,num_selected, num_children, num_immigrants,s1);
    best_individual_iteration(iterations) = max([best_individuals_all{:,4}]);
    best_individual_ratio(iterations) = ratioEI([best_individuals_all{end,1}]);
end

dlmwrite('cluster_matrix.csv',[runSeed,best_individual_ratio(iterations), best_individuals_all{iterations,4}],'-append');

end

fprintf([num2str(cluster_iterations),'/',num2str(num_iterations_cluster),'\n']);

end

datetime('now')

%cluster_matrix = unique(cluster_matrix,'rows');
%csvwrite('cluster_matrix.csv',cluster_matrix);
%save(['data_python_',num2str(floor(ratioEI(A_norm_max_inh)))],'-v7.3');

