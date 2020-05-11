function connectivityMatrixInhi = applyRandomInhibition(connectivityMatrix, inhiRatio)

% Remove inhibitions from matrix
connectivityMatrixNoInhi = abs(connectivityMatrix);

% Set the default number of inhibitions to 0
nNeurons = size(connectivityMatrix, 1);
nNeuronsInhi = round(inhiRatio * nNeurons);

% Initialize neurons type
neuronsType = zeros(nNeurons, 1);

% Set random neurons to be inhibitory and default to be excitatory
neuronsType(randperm(numel(neuronsType), nNeuronsInhi)) = -1;
neuronsType(neuronsType == 0) = 1;

% Apply inhibitions to connectivity matrix
connectivityMatrixInhi = neuronsType .* connectivityMatrixNoInhi;

end

