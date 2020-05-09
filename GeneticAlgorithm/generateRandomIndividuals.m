function individuals = generateRandomIndividuals(mother,num_individuals,s1)
% Generates random individuals for a population.

% We take the number of rows from the mother matrix
[row,~] = size(mother);

for i = 1:num_individuals
    random_rows = randi(s1,[1 row]); % We take a random number from [1,row]
    selected_rows = randperm(s1,row,random_rows); % We take x rows randomly
    selected_rows = sort(selected_rows); % Sort the selected rows
    new = mother; % We create one individual from the mother
    %selected_rows = 1:275;
    new(selected_rows,:) = -new(selected_rows,:); % Flip the sign of the random rows

    % Serotonin 5, 6, 15, 16, 111, 112, 260, 261
    % From http://home.sandiego.edu/~cloer/loerlab/5htcells.html
%     new(5,:) = -abs(new(5,:)); % ADFL
%     new(6,:) = -abs(new(6,:)); % ADFR
%     new(15,:) = -abs(new(15,:)); % AIML
%     new(16,:) = -abs(new(16,:)); % AIMR
%     new(111,:) = -abs(new(111,:)); % HSNL
%     new(112,:) = -abs(new(112,:)); % HSNR
%     new(260,:) = -abs(new(260,:)); %VC04
%     new(261,:) = -abs(new(261,:)); %VC05
    
    % Dopamine 3, 4, 83, 84, 135, 136
    % From http://home.sandiego.edu/~cloer/loerlab/dacells.html
%     new(3,:) = abs(new(3,:)); % ADEL
%     new(4,:) = abs(new(4,:)); % ADER
%     new(83,:) = abs(new(83,:)); % CEPVL
%     new(84,:) = abs(new(84,:)); % CEPVR
%     new(135,:) = abs(new(135,:)); %PDEL
%     new(136,:) = abs(new(136,:)); %PDER

%     new(71,:) = -abs(new(71,:));
%     new(103,:) = -abs(new(103,:));
%     new(104,:) = -abs(new(104,:));
%     new(105,:) = -abs(new(105,:));
%     new(107,:) = -abs(new(107,:));
%     new(178,:) = -abs(new(178,:));
%     new(187,:) = -abs(new(187,:));
%     new(188,:) = -abs(new(188,:));
%     new(189,:) = -abs(new(189,:));
%     new(190,:) = -abs(new(190,:));
%     new(263,:) = -abs(new(263,:));
%     new(264,:) = -abs(new(264,:));
%     new(265,:) = -abs(new(265,:));
%     new(266,:) = -abs(new(266,:));
%     new(267,:) = -abs(new(267,:));
%     new(268,:) = -abs(new(268,:)); 
%     new(269,:) = -abs(new(269,:));
%     new(270,:) = -abs(new(270,:));
%     new(271,:) = -abs(new(271,:));
%     new(272,:) = -abs(new(272,:));
%     new(273,:) = -abs(new(273,:));
%     new(274,:) = -abs(new(274,:));
%     new(275,:) = -abs(new(275,:));

    individuals{i,1} = new; % Store the individual in the cell 'individuals'
    
end

end

