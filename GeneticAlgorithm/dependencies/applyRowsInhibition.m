function [inhibitedRows, inhibitionB] = applyRowsInhibition(connectivityMatrixA, connectivityMatrixB)
% Takes the inhibitory rows of A and copies them to matrix B.

if nargin == 1
    inhibitedRows = sum(connectivityMatrixA,2);
    inhibitedRows = find(inhibitedRows < 0);
else
    inhibitedRows = sum(connectivityMatrixA,2);
    inhibitedRows = find(inhibitedRows < 0);
    inhibitionB = connectivityMatrixB;
    for iRow = 1:length(inhibitedRows)
        inhibitionB(inhibitedRows(iRow),:) = -inhibitionB(inhibitedRows(iRow),:);
    end
end

end

