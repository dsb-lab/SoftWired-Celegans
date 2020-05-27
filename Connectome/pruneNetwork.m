% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath 'Data/'

% Import data from hermaphrodite chemical connectome
connectomeTable = readtable('herm_chemical.xlsx');

% Detect pre and posynaptics neurons
posNeurons = table2cell(connectomeTable(2,4:end-1))';
preNeurons = table2cell(connectomeTable(3:end-1,3));
connectomeMatrix = table2cell(connectomeTable(3:end-1,4:end-1));

for iPreNeuron = 1:length(preNeurons)
    for jPosNeuron =1:length(posNeurons)
        if strcmp(connectomeMatrix(iPreNeuron, jPosNeuron),'')
            connectomeMatrix(iPreNeuron, jPosNeuron)={'0'};
        end
    end
end

connectomeMatrix = cellfun(@str2num, connectomeMatrix);

% Square the newtwork
[sharedNeurons, ~, ~] = intersect(posNeurons,preNeurons);
[notSharedNeurons, index] = setdiff(posNeurons,preNeurons);
index = sort(index);
neurons = posNeurons;

for iIndex = 1:length(index)
    if index(iIndex) <= size(connectomeMatrix,1)
        connectomeMatrix = [connectomeMatrix(1:index(iIndex)-1,:); zeros(1,length(posNeurons)); connectomeMatrix(index(iIndex):end,:)];
    else
        connectomeMatrix = [connectomeMatrix;zeros(1,length(posNeurons))];
    end    
end

% Deletee neurons from pharynx
pharynxNeurons = 50;
connectomeMatrix(:,1:pharynxNeurons) = []; connectomeMatrix(1:pharynxNeurons,:) = [];
neurons(1:pharynxNeurons) = [];

clearvars -except neurons connectomeMatrix

% Filter neurons not belonging either to input, reservoir or readout (inDegree=outDegree=0)
inDegree = sum(connectomeMatrix, 1);
outDegree = sum(connectomeMatrix, 2);
index = find(inDegree==0 & outDegree'==0);
deletedNeurons = neurons(index);

connectomeMatrix(index,:) = [];
connectomeMatrix(:,index) = [];
neurons(index) = [];

clearvars inDegree outDegree index

% Pruning
% Input layer detection
connectomePruned = connectomeMatrix;
inDegree = sum(connectomePruned, 1);
reservoirNeurons = neurons;
layer = 1;
inputLayer = {};

while any(inDegree==0)
    index = find(inDegree==0);
    connectomePruned(index,:) = []; connectomePruned(:,index) = [];
    inputLayer(1,layer) = {reservoirNeurons(index)};
    reservoirNeurons(index) = [];
    inDegree = sum(connectomePruned,1);
    layer = layer + 1;
end

clearvars index inDegree layer

% Readout detection with layers
outDegree = sum(connectomePruned,2);
layer = 1;
readoutLayer = {};

while any(outDegree==0)
    index = find(outDegree==0);
    connectomePruned(index,:) = []; connectomePruned(:,index) = [];
    readoutLayer(1,layer) = {reservoirNeurons(index)};
    reservoirNeurons(index) = [];
    outDegree = sum(connectomePruned,2);
    layer = layer+1;
end

connectomeNormMax = connectomePruned;
for iRow = 1:size(connectomeNormMax,1)
   connectomeNormMax(iRow,:) = connectomeNormMax(iRow,:)/max(abs(connectomePruned(iRow,:)));
end

clearvars layer outDegree index iRow

% Uncomment to save
save('Data/connectomeFullData.mat')

listPruned = reservoirNeurons;
clearvars -except connectomePruned connectomeNormMax listPruned

% Uncomment to save
save('Data/connectomeData.mat')
