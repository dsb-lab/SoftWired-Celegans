% Clear command window and workspace
clear;
clc;

% Add path to dependencies
addpath 'Data/'

% Load connectome data
load('Connectome_full.mat')
neuronsGephi = neurons;
nNeurons = length(neuronsGephi);

% Classify each neuron according their position in the reservoir computing
% architecture
for iNeuron = 1:nNeurons
    if any(strcmp(reservoirNeurons,string(neurons(iNeuron))))
        neuronsGephi(iNeuron, 2) = {'Reservoir'};
    elseif any(strcmp(inputLayer{1,1},string(neurons(iNeuron))))
        neuronsGephi(iNeuron ,2) = {'Input'};
    else
        neuronsGephi(iNeuron ,2) = {'Readout'};
    end
end

% Classify each neuron according to their types
for iNeuron = 1:nNeurons
    if iNeuron < 84
        neuronsGephi(iNeuron, 3) = {'Sensory Neurons'};
    elseif iNeuron >= 84 && iNeuron < 165
        neuronsGephi(iNeuron, 3) = {'Interneurons'};
    elseif iNeuron >= 165 && iNeuron < 273
        neuronsGephi(iNeuron, 3) = {'Motor Neurons'};
    elseif iNeuron >= 273 && iNeuron < 368
        neuronsGephi(iNeuron, 3) = {'Bodywall Muscles'};
    elseif iNeuron >= 368 && iNeuron < 384
        neuronsGephi(iNeuron, 3) = {'Other-end Organs'};
    elseif iNeuron >= 384
        neuronsGephi(iNeuron, 3) = {'Sex-specific Cells'};
    end
end

% Save neurons info
fileID = fopen('Gephi/neurons.csv','w');
fprintf(fileID,'Id, label, posx, posy, nodetype, function\n');

% Store position
input_posy = [-0.5,0.5];
readout_posy = [-0.5,0,0.5];
knownNeurons = [15 16 129 159 157 143 144 150 169];
for iNeuron = 1:nNeurons
    if any(knownNeurons == iNeuron)
        if strcmp(neuronsGephi(iNeuron, 2),'Reservoir')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),string(neuronsGephi(iNeuron, 1)),...
                8+normrnd(0, 1.5),normrnd(0, 1.5),string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
        elseif strcmp(neuronsGephi(iNeuron, 2),'Input')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),string(neuronsGephi(iNeuron, 1)),...
                0,input_posy(1),string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
            input_posy(1) = [];
        elseif strcmp(neuronsGephi(iNeuron, 2),'Readout')
            if any(strcmp(readoutLayer{1, 1},string(neuronsGephi(iNeuron, 1))))
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),string(neuronsGephi(iNeuron, 1)),...
                    20+normrnd(0, 0.25),normrnd(0, 1.5),...
                    string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
            else
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),string(neuronsGephi(iNeuron, 1)),...
                    16,readout_posy(1),...
                    string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
                readout_posy(1) = [];
            end
        end
    else
        if strcmp(neuronsGephi(iNeuron, 2),'Reservoir')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),'',...
                8+normrnd(0, 1.5),normrnd(0, 1.5),string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
        elseif strcmp(neuronsGephi(iNeuron, 2),'Input')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron,1)),'',...
                0,input_posy(1),string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
            input_posy(1) = [];
        elseif strcmp(neuronsGephi(iNeuron, 2),'Readout')
            if any(strcmp(readoutLayer{1, 1},string(neuronsGephi(iNeuron, 1))))
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),'',...
                    20+normrnd(0, 0.25),normrnd(0, 1.5),...
                    string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
            else
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(iNeuron, 1)),'',...
                    16,readout_posy(1),...
                    string(neuronsGephi(iNeuron, 2)),string(neuronsGephi(iNeuron, 3)));
                readout_posy(1) = [];
            end
        end 
    end
end
fclose(fileID);

% Store edges
fileID = fopen('Gephi/edges.csv','w');
fprintf(fileID,'Source, Target\n');
for iNeuron = 1:nNeurons
    for jNeuron = 1:nNeurons
        if A(iNeuron, jNeuron)>0
            fprintf(fileID,'%s,%s\n',string(neuronsGephi(iNeuron, 1)),string(neuronsGephi(jNeuron, 1)));
        end
    end
end
fclose(fileID);
