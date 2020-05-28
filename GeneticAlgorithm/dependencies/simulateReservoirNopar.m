function states = simulateReservoirNopar(population, inputs)
% 
% Function: 
% – simulateReservoirNoPar :Simulates reservoir activity using a discrete map. 
%   No parallel computing used.
%
% Inputs:
% - population: Current generation individuals (adjacency matrices with 
%   different inhi-exhi ratio).
% – inputs: Time series of AFDL and AFDR.
% 
% Returns:
% - states: Simulated neural activity.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

% Initialization of states
states = cell(length(population),1);

% Input signals
AFDL = inputs(1,:);
AFDR = inputs(2,:);
totalTime = length(inputs);

for iIndividual = 1:length(population)
statesInput = zeros(length(population{iIndividual}), 1); % Initialize states for individual

    for iTime = 1:totalTime
        statesInput(15, :) = (AFDL(iTime)); % Set value of neuron AFDL the value of the position iTime of the time series
        statesInput(16, :) = (AFDR(iTime)); % Set value of neuron AFDR the value of the position iTime of the time series
        if iTime == 1
            states{iIndividual}(:, iTime) = tanh(statesInput(:,iTime)' * population{iIndividual}); % Simulation for the iteration iTime = 1
            states{iIndividual}(15, iTime) = tanh(AFDL(iTime)); % Rewrite the values of AFDL 
            states{iIndividual}(16, iTime) = tanh(AFDR(iTime)); % Rewrite the values of AFDR 
        else
            states{iIndividual}(:, iTime) = tanh(states{iIndividual}(:, iTime-1)' * population{iIndividual}); % Simulation for the iteration iTime != 1
            states{iIndividual}(15, iTime) = tanh(AFDL(iTime)); % Rewrite the values of AFDL 
            states{iIndividual}(16, iTime) = tanh(AFDR(iTime)); % Rewrite the values of AFDR
        end
    end
    
end

    
end

