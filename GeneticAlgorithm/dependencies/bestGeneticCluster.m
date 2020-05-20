%% Genetic Algorithm

clear;
clc;
close all;

% Load pruned data 
load newConnectome_minimal.mat

% Load neuronal_data
load worm_data.mat

% Clear other variables
clearvars -except A_norm_max list_prunned neuronal_data A_prunned

% Print number of cores
numcores = feature('numcores');
parpool('local',numcores)

% Normalize and Standardize Data
neuronal_data_standardized = normalize(neuronal_data);
%neuronal_data_standardized = (neuronal_data - mean(neuronal_data,2))./(std(neuronal_data,0,2));
%neuronal_data_standardized = (neuronal_data - mean(neuronal_data,2))./(max(neuronal_data,[],2)-min(neuronal_data,[],2));

% Normalize connectivity matrix by dividing each row by its maximum
%A = A_norm_max;
A = A_prunned/max(max(A_prunned));

% Set Algorithm Parameters
num_iterations_algorithm = 10; % Number of iterations of the optimization
num_individuals = 10; % Number of total individuals of the population
num_selected = 3; % Number of individuals selected
num_children = 5; % Number of individuals of the offspring
num_immigrants = 2; % Number of individuals of the migration

% Note: num_individuals = num_selected + num_children + num_immigrants

% Real sign
real_sign = csvread('sign.csv');
indexes = find(real_sign ~= 0);
neurons_indexes = [13, 54, 56, 58, 59, 173, 188];

% Cluster matrix
num_iterations_algorithm_cluster = 1;
cluster_matrix = [];
k = 1;

datetime('now')

for cluster_iterations = 1:num_iterations_algorithm_cluster
    
% Initialization of variables
best_individuals_all = {}; % Stores connectivity matrix, signals and correlation of best individuals
best_individual_iteration = []; % Index of Best individuals of each iteration
inputs = [neuronal_data_standardized(32,:);neuronal_data_standardized(69,:)]; % Corrsponds to temperature neurons: AFDL (32) & AFDR (69)
time = linspace(0,length(neuronal_data)/10,length(neuronal_data));
CC = zeros(7,num_iterations_algorithm);
    
% Create random stream    
runSeed = 83; %cluster_iterations; %23011
s1 = RandStream.create('mrg32k3a','NumStreams',1,'Seed',runSeed);

for iterations = 1:num_iterations_algorithm
if iterations == 1
    tic;
    initial_population = random_individuals(A,num_individuals,s1); % Generate random population in the first iteration
    individuals_states = reservoir_simulation_par(initial_population,inputs); % Generate signals for each neuron of each individual
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
    best_individual_iteration(iterations) = min([best_individuals_all{:,4}]);
    best_individual_ratio(iterations) = ratioEI([best_individuals_all{end,1}]);
    
else
    new_population = next_population; clearvars next_population;
    individuals_states = reservoir_simulation_par(new_population,inputs);
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
    best_individual_iteration(iterations) = min([best_individuals_all{:,4}]);
    best_individual_ratio(iterations) = ratioEI([best_individuals_all{end,1}]);
end


if mod(iterations,5) == 0 && iterations ~=num_iterations_algorithm
    t = toc;
    fprintf('\nIterations Completed:                          %d\n',iterations);
    fprintf('Mean Seconds per iteration:                    %fs\n',t/iterations);
    fprintf('Estimated time to Complete Iterations:         %dh %dmin %ds\n',...
        round(((num_iterations_algorithm-iterations)*(t/iterations))/3600), floor(mod(((num_iterations_algorithm-iterations)*(t/iterations)),3600)/60), ...
        round(mod(mod(((num_iterations_algorithm-iterations)*(t/iterations)),3600),60)));
    [~,col] = find([best_individuals_all{1:iterations,4}] == max([best_individuals_all{1:iterations,4}]));
    if length(col)>1
        col = col(1);
    end
    fprintf('Mean Error of Selected Individuals (%d/%d):   %f\n',num_selected,num_individuals,mean(best_fitness(1:num_selected)));
    fprintf('Error of Best Individual:                      %f\n',min([best_individuals_all{:,4}]));
    fprintf('Mean Correlation of Best Individual:           %f\n',mean([best_individuals_all{end,3}]));
    fprintf('Percentage of inhibition of Best Individual:   %f%%\n\n',ratioEI(best_individuals_all{col,1}));
    
    
elseif mod(iterations,5) == 0 && iterations== num_iterations_algorithm
    t = toc;
    fprintf('\nNumber of completed iterations:                %d\n',iterations);
    fprintf('Total time to Completation:                    %dh %dmin %ds\n',...
        round(((num_iterations_algorithm)*(t/iterations))/3600), floor(mod((num_iterations_algorithm*(t/iterations)),3600)/60), ...
        round(mod(mod(((num_iterations_algorithm)*(t/iterations)),3600),60)));
    fprintf('Total Mean Seconds per iteration:              %fs\n',t/iterations);
    [~,col] = find([best_individuals_all{1:iterations,4}] == max([best_individuals_all{1:iterations,4}]));
    if length(col)>1
       col = col(1);
    end
    fprintf('Mean Error of Best Individuals (%d):          %f\n',iterations,mean([best_individuals_all{1:iterations,4}])); 
    fprintf('Error of Best Individual:                      %f\n',min([best_individuals_all{1:iterations,4}]));
    fprintf('Mean Correlation of Best Individual:           %f\n',mean([best_individuals_all{end,3}]));
    fprintf('Percentage of inhibition of Best Individual:   %f%%\n\n',ratioEI(best_individuals_all{col,1}));
end


cluster_matrix(k,:) = [runSeed, best_individual_ratio(iterations), best_individuals_all{iterations,4}];
k = k + 1;

end

end

%cluster_matrix = unique(cluster_matrix,'rows');
%csvwrite('cluster_matrix.csv',cluster_matrix);
%clearvars A_norm_max_inh
%[~, A_norm_max_inh] = rows_inhibition(best_individuals_all{end,1}, A_norm_max);
%clearvars -except A_norm_max_inh
%save(['data_python_',num2str(floor(ratioEI(A_norm_max_inh)))]);

datetime('now')


