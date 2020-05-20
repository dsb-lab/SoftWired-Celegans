function nextPopulation = generateNextPopulation(initialPopulation, A, bestIndividuals, nSelected, nChildren, nImmigrants, nMutations, s)
% Generates the next population of the algorithm. Since the algorithm uses
% elitism, mutations are included in the form of immigrants.

% Initialize new population matrix
nextPopulation = cell(size(initialPopulation));

% Select those individuals with the best fitness
idxBestSelected = bestIndividuals(1:nSelected);

% Fill the next_population matrix with the survivors
for iSelected = 1:nSelected
nextPopulation{iSelected} = cell2mat(initialPopulation(idxBestSelected(iSelected)));
end

% Generate pairs of best individuals
pairs = randsample(s, idxBestSelected, 2*nChildren, 'true');
pairs = reshape(pairs,[],2);

% Fill the next_population matrix with the children
for iSelected = 1:nChildren
    nextPopulation{iSelected + nSelected} = cell2mat(recombineMatrices(initialPopulation(pairs(iSelected,1)), initialPopulation(pairs(iSelected,2)), s));
end

% Fill the next_population matrix with the immigrants
if nImmigrants > 1
    migrationRandom = nImmigrants/2; % Half random and half elitist
    migrationElitist = nImmigrants/2;
    
    for iSelected = 1:migrationRandom
     nextPopulation{iSelected + nSelected + nChildren} = cell2mat(generateRandomIndividuals(A, 1, s));
    end

    for iSelected = 1:migrationElitist
    nextPopulation{iSelected + nSelected + nChildren + migrationRandom} = applyMutations(initialPopulation{idxBestSelected(1)}, 5, s);
    end

else
    migrationElitist = 1;
    
    for iSelected = 1:migrationElitist
        nextPopulation{iSelected + nSelected + nChildren} = applyMutations(initialPopulation{idxBestSelected(1)}, nMutations, s);
    end
    
end


% for i = num_selected/2:num_children
%    pairs(i,:) = randsample(length(idx_best_selected),2)'; 
%    
% end
% 
% for i = 1:length(idx_best_selected)
%     next_population{i} = initial_population{idx_best_selected(i)};
%     mothers{i} = initial_population{idx_best_selected(i)};
% end
% 
% for i = (length(idx_best_selected)+1):(length(idx_best_selected)+m)
%     next_population{i} = recombination(mothers{pairs(i-length(idx_best_selected),1)},mothers{pairs(i-length(idx_best_selected),2)});
% end
% 
% for i =(length(idx_best_selected)+m+1):(n+m+p)-10
%      next_population{i} = cell2mat(random_individuals(A,1));
% end
% 
% 
% for i =(n+m+p)-9:(n+m+p)
%      next_population{i} = 
% end

end

