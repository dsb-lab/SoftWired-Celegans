function population = generateRandomIndividuals(connectivityMatrix, nIndividuals, randStream)
% 
% Function: 
% – generateRandomIndividuals: Populates generation with random individuals
%
% Inputs:
% - connectivityMatrix: Adjacency matrix of the C.elegans connectome.
% - nIndividuals: Number of total individuals in the generation.
% – randStream: Stream of random numbers (for reproducibility).
% 
% Returns:
% - population: Current generation individuals (adjacency matrices with 
%   different inhi-exhi ratio).
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

% We take the number of rows from the mother matrix
[row, ~] = size(connectivityMatrix);

for iIndividual = 1:nIndividuals
    random_rows = randi(randStream,[1 row]); % We take a random number from [1, row]
    selected_rows = randperm(randStream,row,random_rows); % We take x rows randomly
    selected_rows = sort(selected_rows); % Sort the selected rows
    new = connectivityMatrix; % We create one individual from the mother
    new(selected_rows,:) = -new(selected_rows,:); % Flip the sign of the random rows
    population{iIndividual,1} = new; % Store the individual in the cell 'individuals'
end

end

