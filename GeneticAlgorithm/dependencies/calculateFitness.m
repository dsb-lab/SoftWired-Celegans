function [meanFitness, fitnessPopulation] = calculateFitness(individualStates, neuronalData)
% Calculates the fitness of the different individuals in the population.
% The recorded time series are needed to compute the fitness, since it is
% defined as the mean correlation of the different 7 neurons.

% Index neurons in 'neuronalDataStandardized'
idxData = [6 7 4 28 49 2 11];

% Index neurons in 'listPrunned'
idxPruned = [127 157 155 141 142 148 167];

% Initialize correlation
correlation = zeros(size(idxData));
meanFitness = zeros(length(individualStates),1);

for i = 1:length(individualStates)
    for j = 1:length(idxData)
        individualStates{i}(idxPruned(j),:) = normalize(individualStates{i}(idxPruned(j),:)); % Standarize the signals generated in the reservoir simulation
        coef = corrcoef(neuronalData(idxData(j),:),individualStates{i}(idxPruned(j),:)); % Correlation between original and artificial signals
        coef(coef<0)=0;
        correlation(j,1) = coef(1,2);
    end
    meanFitness(i) = mean(correlation(:,1)); % Fitness is computed as sqrt(mean((1-coef).^2))
    fitnessPopulation{i,1} = correlation(:,1); 
end

end

