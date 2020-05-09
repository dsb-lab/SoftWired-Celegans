function [A_mutated] = applyMutations(A,num_mutations,s1)
% Applies different mutations to connectivity matrix A. If a neuron is selected
% for mutation, its activity will be changed: if it is excitatory it will become
% inhibitory; otherwise, if inhibitory it will become excitatory. This is 
% accomplished by changing the sign of the connections of the neuron.

A_mutated = A;
[row,~] = size(A_mutated);
%random_rows = randi(s1,row);
selected_rows = randperm(s1,row,num_mutations);
selected_rows = sort(selected_rows);

for i = 1:num_mutations
    for j = 1:length(selected_rows)
        A_mutated(selected_rows(j),:) = -A_mutated(selected_rows(j),:);
    end
end

%     % Serotonin 5, 6, 15, 16, 111, 112, 260, 261
%     A_mutated(5,:) = -abs(A_mutated(5,:));
%     A_mutated(6,:) = -abs(A_mutated(6,:));
%     A_mutated(15,:) = -abs(A_mutated(15,:));
%     A_mutated(16,:) = -abs(A_mutated(16,:));
%     A_mutated(111,:) = -abs(A_mutated(111,:));
%     A_mutated(112,:) = -abs(A_mutated(112,:));
%     A_mutated(260,:) = -abs(A_mutated(260,:));
%     A_mutated(261,:) = -abs(A_mutated(261,:));
%     
%     % Dopamine 3, 4, 83, 84, 135, 136
%     A_mutated(3,:) = abs(A_mutated(3,:));
%     A_mutated(4,:) = abs(A_mutated(4,:));
%     A_mutated(83,:) = abs(A_mutated(83,:));
%     A_mutated(84,:) = abs(A_mutated(84,:));
%     A_mutated(85,:) = abs(A_mutated(84,:));
%     A_mutated(86,:) = abs(A_mutated(84,:));
%     A_mutated(135,:) = abs(A_mutated(135,:));
%     A_mutated(136,:) = abs(A_mutated(136,:));
%     
%     % GABA NEW 2/12/2018
%     A_mutated(71,:) = -abs(A_mutated(71,:));
%     A_mutated(103,:) = -abs(A_mutated(103,:));
%     A_mutated(104,:) = -abs(A_mutated(104,:));
%     A_mutated(105,:) = -abs(A_mutated(105,:));
%     A_mutated(107,:) = -abs(A_mutated(107,:));
%     A_mutated(178,:) = -abs(A_mutated(178,:));
%     A_mutated(187,:) = -abs(A_mutated(187,:));
%     A_mutated(188,:) = -abs(A_mutated(188,:));
%     A_mutated(189,:) = -abs(A_mutated(189,:));
%     A_mutated(190,:) = -abs(A_mutated(190,:));
%     A_mutated(263,:) = -abs(A_mutated(263,:));
%     A_mutated(264,:) = -abs(A_mutated(264,:));
%     A_mutated(265,:) = -abs(A_mutated(265,:));
%     A_mutated(266,:) = -abs(A_mutated(266,:));
%     A_mutated(267,:) = -abs(A_mutated(267,:));
%     A_mutated(268,:) = -abs(A_mutated(268,:)); 
%     A_mutated(269,:) = -abs(A_mutated(269,:));
%     A_mutated(270,:) = -abs(A_mutated(270,:));
%     A_mutated(271,:) = -abs(A_mutated(271,:));
%     A_mutated(272,:) = -abs(A_mutated(272,:));
%     A_mutated(273,:) = -abs(A_mutated(273,:));
%     A_mutated(274,:) = -abs(A_mutated(274,:));
%     A_mutated(275,:) = -abs(A_mutated(275,:));

end

