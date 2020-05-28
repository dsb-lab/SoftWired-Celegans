function nextPopulation = generateNextPopulation(initialPopulation, connectivityMatrix, bestIndividuals, nSelected, nChildren, nImmigrants, nMutations, randStream)
% 
% Function: 
% – generateNextPopulation: Generates the next population of the algorithm. 
%   Since the algorithm uses elitism, mutations are also included in the 
%   form of immigrants.
%
% Inputs:
% - initialPopulation:
% - connectivityMatrix: Adjacency matrix of the C.elegans connectome.
% – bestIndividuals: Individuals in the population ranked by fitness.
% – nSelected: Number of selected individuals for the following generation.
% - nChildren: Number of children to generate.
% – nImmigrants: Number of total immigrants in the population.
% – nMutations: Number of single mutations in each mutated individual.
% – randStream: Stream of random numbers (for reproducibility).
% 
% Returns:
% - nextPopulation: Group of individuals forming the next generation.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

% Initialize new population matrix
nextPopulation = cell(size(initialPopulation));

% Select those individuals with the best fitness
idxBestSelected = bestIndividuals(1:nSelected);

% Fill the next_population matrix with the survivors
for iSelected = 1:nSelected
nextPopulation{iSelected} = cell2mat(initialPopulation(idxBestSelected(iSelected)));
end

% Generate pairs of best individuals
pairs = randsample(randStream, idxBestSelected, 2*nChildren, 'true');
pairs = reshape(pairs,[],2);

% Fill the next_population matrix with the children
for iSelected = 1:nChildren
    nextPopulation{iSelected + nSelected} = cell2mat(recombineMatrices(initialPopulation(pairs(iSelected,1)), initialPopulation(pairs(iSelected,2)), randStream));
end

% Fill the next_population matrix with the immigrants
if nImmigrants > 1
    migrationRandom = nImmigrants/2; % Half random and half elitist
    migrationElitist = nImmigrants/2;
    
    for iSelected = 1:migrationRandom
     nextPopulation{iSelected + nSelected + nChildren} = cell2mat(generateRandomIndividuals(connectivityMatrix, 1, randStream));
    end

    for iSelected = 1:migrationElitist
    nextPopulation{iSelected + nSelected + nChildren + migrationRandom} = applyMutations(initialPopulation{idxBestSelected(1)}, 5, randStream);
    end

else
    migrationElitist = 1;
    
    for iSelected = 1:migrationElitist
        nextPopulation{iSelected + nSelected + nChildren} = applyMutations(initialPopulation{idxBestSelected(1)}, nMutations, randStream);
    end
    
end

end

