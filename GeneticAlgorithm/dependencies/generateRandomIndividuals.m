function individuals = generateRandomIndividuals(mother,num_individuals,s1)
% Generates random individuals for a population.

% We take the number of rows from the mother matrix
[row,~] = size(mother);

for i = 1:num_individuals
    random_rows = randi(s1,[1 row]); % We take a random number from [1,row]
    selected_rows = randperm(s1,row,random_rows); % We take x rows randomly
    selected_rows = sort(selected_rows); % Sort the selected rows
    new = mother; % We create one individual from the mother
    new(selected_rows,:) = -new(selected_rows,:); % Flip the sign of the random rows
    individuals{i,1} = new; % Store the individual in the cell 'individuals'
end

end

