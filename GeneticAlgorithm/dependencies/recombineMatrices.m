function connectivityMatrixC = recombineMatrices(connectivityMatrixA, conenctivityMatrixB, s)
% Generates a new individual by combining two parent matrices.

% Choose where to cut
randomCut = randi(s,length(connectivityMatrixA));

%Horizontal recombination
connectivityMatrixC = [connectivityMatrixA(1:randomCut,:);conenctivityMatrixB((randomCut+1):end,:)];

end

