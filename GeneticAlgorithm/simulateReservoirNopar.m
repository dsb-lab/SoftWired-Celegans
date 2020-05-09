function states = simulateReservoirNopar(population,inputs)
% Simulates reservoir activity using a discrete map. No parallel computing used.ion

% Initialization of states
states = cell(length(population),1);

% Input signals
AFDL = inputs(1,:);
AFDR = inputs(2,:);

for i = 1:length(population)
states_input = zeros(length(population{i}),1); % Initialize states for individual

    for j = 1:length(inputs)
        states_input(15,:) = (AFDL(j)); % Set value of neuron AFDL the value of the position j of the time series
        states_input(16,:) = (AFDR(j)); % Set value of neuron AFDR the value of the position j of the time series
        if j == 1
            states{i}(:,j) = tanh(states_input(:,j)'*population{i}); % Simulation for the iteration j = 1
            states{i}(15,j) = tanh(AFDL(j)); % Rewrite the values of AFDL 
            states{i}(16,j) = tanh(AFDR(j)); % Rewrite the values of AFDR 
        else
            states{i}(:,j) = tanh(states{i}(:,j-1)'*population{i}); % Simulation for the iteration j != 1
            states{i}(15,j) = tanh(AFDL(j)); % Rewrite the values of AFDL 
            states{i}(16,j) = tanh(AFDR(j)); % Rewrite the values of AFDR
        end
    end
    
end

    
end

