function [rows_inhibited, B_inhibition] = applyRowsInhibition(A, B)
% Takes the inhibitory rows of A and copies them to matrix B.

if nargin == 1
    rows_inhibited = sum(A,2);
    [rows_inhibited] = find(rows_inhibited < 0);
else
    rows_inhibited = sum(A,2);
    [rows_inhibited] = find(rows_inhibited < 0);
    B_inhibition = B;
    for i = 1:length(rows_inhibited)
        B_inhibition(rows_inhibited(i),:) = -B_inhibition(rows_inhibited(i),:);
    end
    
end

end

