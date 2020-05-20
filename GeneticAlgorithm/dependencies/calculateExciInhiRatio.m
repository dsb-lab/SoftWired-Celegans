function ratio = calculateExciInhiRatio(mother)

if ~iscell(mother)
    excitatory_connections = sum(sum(mother,2)>0);
    inhibitory_connections = sum(sum(mother,2)<0);
    ratio = inhibitory_connections/(excitatory_connections+inhibitory_connections) *100;
    %fprintf("Percentage of inhibitory connections of daughter: %f%% \n",ratio);
else
    individuals = length(mother);
    neurons = length(mother{1});
    ratio_per_individual = nan(1,individuals);
    for i = 1:individuals
        inhibitory_connections = sum(sum(mother{i},2)<0);
        ratio_per_individual(i) = 100*inhibitory_connections/neurons;
    end
    ratio = mean(ratio_per_individual);
end

