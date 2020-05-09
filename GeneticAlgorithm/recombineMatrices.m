function daughter = recombineMatrices(individual1, individual2, s1)
% Generates a new individual by combining two parent matrices.

% Choose where to cut
%cut = floor(length(individual1)/2);
random_area = randi(s1,length(individual1));
%cut = floor(length(individual1)/2);

%Horizontal recombination
daughter = [individual1(1:random_area,:);individual2((random_area+1):end,:)];
%daughter = [individual1(1:cut,:);individual2((cut+1):end,:)];

end

