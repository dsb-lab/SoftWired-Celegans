function [inhibitedRows, inhibitedConnectivityMatrixB] = applyRowsInhibition(connectivityMatrixA, inhibitedConnectivityMatrixB)
% 
% Function: 
% – applyRowsInhibition: Takes the inhibitory rows of connectivity Matrix A 
%   and copies them to matrix B.
%
% Inputs:
% - connectivityMatrixA: Adjacency matrix of the C.elegans connectome.
% – connectivityMatrixB: Adjacency matrix of the C.elegans connectome.
% 
% Returns:
% - inhibitedRows: Number of inhibitory neurons.
% - inhibitedConnectivityMatrixB: Adjacency matrix with the inhibitions of
%   connectivity matrix A.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

if nargin == 1
    inhibitedRows = sum(connectivityMatrixA, 2);
    inhibitedRows = find(inhibitedRows < 0);
else
    inhibitedRows = sum(connectivityMatrixA, 2);
    inhibitedRows = find(inhibitedRows < 0);
    inhibitedConnectivityMatrixB = inhibitedConnectivityMatrixB;
    for iRow = 1:length(inhibitedRows)
        inhibitedConnectivityMatrixB(inhibitedRows(iRow),:) = -inhibitedConnectivityMatrixB(inhibitedRows(iRow),:);
    end
end

end

