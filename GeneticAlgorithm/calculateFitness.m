function [mean_fitness,fitness_population] = fitness(individuals_states,time_series)
% Calculates the fitness of the different individuals in the population.
% The recorded time series are needed to compute the fitness, since it is
% defined as the mean correlation of the different 7 neurons.

% Index neurons in 'neuronal_data_standardized'
idx_data = [6 7 4 28 49 2 11];

% Index neurons in 'list_prunned'
%idx_pruned = [13 54 56 58 59 173 188];
idx_pruned = [127 157 155 141 142 148 167];

% Initialize correlation
correlation = zeros(size(idx_data));
mean_fitness = zeros(length(individuals_states),1);

for i = 1:length(individuals_states)
    for j = 1:length(idx_data)
        individuals_states{i}(idx_pruned(j),:) = normalize(individuals_states{i}(idx_pruned(j),:)); % Standarize the signals generated in the reservoir simulation
        coef = corrcoef(time_series(idx_data(j),:),individuals_states{i}(idx_pruned(j),:)); % Correlation between original and artificial signals
        coef(coef<0)=0;
        correlation(j,1) = coef(1,2);
    end
    mean_fitness(i) = mean(correlation(:,1)); % Fitness is computed as sqrt(mean((1-coef).^2))
    fitness_population{i,1} = correlation(:,1); 
end

end

