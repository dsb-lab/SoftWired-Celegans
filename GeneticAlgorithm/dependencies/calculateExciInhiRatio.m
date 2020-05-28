function exciInhiRatio = calculateExciInhiRatio(connectivityMatrix)
% 
% Function: 
% – calculateExciInhiRatio: Computes the proportion of inhibition-excitation
%   in a given adjacency matrix.
%
% Inputs:
% - connectivityMatrix: Adjacency matrix of the C.elegans connectome.
% 
% Returns:
% - exciInhiRatio: Percentage of inhibition.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

if ~iscell(connectivityMatrix)
    excitatory_connections = sum(sum(connectivityMatrix,2)>0);
    inhibitory_connections = sum(sum(connectivityMatrix,2)<0);
    exciInhiRatio = inhibitory_connections/(excitatory_connections+inhibitory_connections) *100;
else
    nIndividuals = length(connectivityMatrix);
    neurons = length(connectivityMatrix{1});
    ratioPerIndividual = nan(1,nIndividuals);
    for iIndividual = 1:nIndividuals
        inhibitory_connections = sum(sum(connectivityMatrix{iIndividual},2)<0);
        ratioPerIndividual(iIndividual) = 100*inhibitory_connections/neurons;
    end
    exciInhiRatio = mean(ratioPerIndividual);
end

