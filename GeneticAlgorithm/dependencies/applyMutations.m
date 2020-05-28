function connectivityMatrixMutated = applyMutations(connectivityMatrix, nMutations, randStream)
% 
% Function: 
% – applyMutations: Applies different mutations to the connectivity matrix. 
%   Mutation consists in changing the neuron type (from inhi to exci and
%   viceversa).
%
% Inputs:
% - connectivityMatrix: Adjacency matrix of the C.elegans connectome.
% – nMutations: Number of neurons to mutate.
% - randStream: Stream of random numbers (for reproducibility).
% 
% Returns:
% - connectivityMatrixMutated: Connectome with nMutations. 
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

connectivityMatrixMutated = connectivityMatrix;
[row, ~] = size(connectivityMatrixMutated);
selectedRows = randperm(randStream, row, nMutations);
selectedRows = sort(selectedRows);

for iMutation = 1:nMutations
    for iRow = 1:length(selectedRows)
        connectivityMatrixMutated(selectedRows(iRow), :) = -connectivityMatrixMutated(selectedRows(iRow), :);
    end
end

end

