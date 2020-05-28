function connectivityMatrixC = recombineMatrices(connectivityMatrixA, conenctivityMatrixB, randStream)
% 
% Function: 
% – recombineMatrices: Generates a new individual by combining two matrices.
%
% Inputs:
% - connectivityMatrixA: Adjacency matrix of the C.elegans connectome.
% – connectivityMatrixB: Adjacency matrix of the C.elegans connectome.
% – randStream: Stream of random numbers (for reproducibility).
% 
% Returns:
% - connectivityMatrixC: Recombined adjacency mattrix.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

% Choose where to cut
randomCut = randi(randStream, length(connectivityMatrixA));

%Horizontal recombination
connectivityMatrixC = [connectivityMatrixA(1:randomCut, :); conenctivityMatrixB((randomCut+1):end, :)];

end

