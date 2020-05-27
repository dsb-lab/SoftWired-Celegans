function connectivityMatrixMutated = applyMutations(connectivityMatrix, nMutations, s)
% Applies different mutations to connectivity matrix A. If a neuron is selected
% for mutation, its activity will be changed: if it is excitatory it will become
% inhibitory; otherwise, if inhibitory it will become excitatory. This is 
% accomplished by changing the sign of the connections of the neuron.

connectivityMatrixMutated = connectivityMatrix;
[row, ~] = size(connectivityMatrixMutated);
selectedRows = randperm(s, row, nMutations);
selectedRows = sort(selectedRows);

for iMutation = 1:nMutations
    for iRow = 1:length(selectedRows)
        connectivityMatrixMutated(selectedRows(iRow), :) = -connectivityMatrixMutated(selectedRows(iRow), :);
    end
end

end

