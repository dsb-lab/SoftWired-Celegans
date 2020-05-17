% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath 'Data/'

% Import data from hermaphrodite chemical connectome
A_table = readtable('herm_chemical.xlsx');

% Detect pre and posynaptics neurons
posNeurons = table2cell(A_table(2,4:end-1))';
preNeurons = table2cell(A_table(3:end-1,3));
A = table2cell(A_table(3:end-1,4:end-1));

for iPreNeuron = 1:length(preNeurons)
    for jPosNeuron =1:length(posNeurons)
        if strcmp(A(iPreNeuron, jPosNeuron),'')
            A(iPreNeuron, jPosNeuron)={'0'};
        end
    end
end

A = cellfun(@str2num, A);

% Square the newtwork
[sharedNeurons, ~, ~] = intersect(posNeurons,preNeurons);
[notSharedNeurons, index] = setdiff(posNeurons,preNeurons);
index = sort(index);
neurons = posNeurons;

for iIndex = 1:length(index)
    if index(iIndex) <= size(A,1)
        A = [A(1:index(iIndex)-1,:); zeros(1,length(posNeurons)); A(index(iIndex):end,:)];
    else
        A = [A;zeros(1,length(posNeurons))];
    end    
end

% Deletee neurons from pharynx
pharynxNeurons = 50;
A(:,1:pharynxNeurons) = []; A(1:pharynxNeurons,:) = [];
neurons(1:pharynxNeurons) = [];

clearvars -except neurons A

% Filter neurons not belonging either to input, reservoir or readout (inDegree=outDegree=0)
inDegree = sum(A,1);
outDegree = sum(A,2);
index = find(inDegree==0 & outDegree'==0);
deletedNeurons = neurons(index);

A(index,:) = [];
A(:,index) = [];
neurons(index) = [];

clearvars inDegree outDegree index

% Pruning
% Input layer detection
A_pruned = A;
inDegree = sum(A_pruned, 1);
reservoirNeurons = neurons;
layer = 1;
inputLayer = {};

while any(inDegree==0)
    index = find(inDegree==0);
    A_pruned(index,:) = []; A_pruned(:,index) = [];
    inputLayer(1,layer) = {reservoirNeurons(index)};
    reservoirNeurons(index) = [];
    inDegree = sum(A_pruned,1);
    layer = layer + 1;
end

clearvars index inDegree layer

% Readout detection with layers
outDegree = sum(A_pruned,2);
layer = 1;
readoutLayer = {};

while any(outDegree==0)
    index = find(outDegree==0);
    A_pruned(index,:) = []; A_pruned(:,index) = [];
    readoutLayer(1,layer) = {reservoirNeurons(index)};
    reservoirNeurons(index) = [];
    outDegree = sum(A_pruned,2);
    layer = layer+1;
end

A_norm_max = A_pruned;
for iRow = 1:size(A_norm_max,1)
   A_norm_max(iRow,:) = A_norm_max(iRow,:)/max(abs(A_pruned(iRow,:)));
end

clearvars layer outDegree index i

% Uncomment to save
% save('Connectome/newConnectome_full.mat')

list_pruned = reservoirNeurons;
clearvars -except A_pruned A_norm_max list_pruned

% Uncomment to save
% save('Connectome/newConnectome_minimal.mat')
