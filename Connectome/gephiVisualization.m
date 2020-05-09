clear; clc;

addpath('Connectome')

load('Connectome_full.mat')

neuronsGephi = neurons;
for i = 1:length(neurons)
    if any(strcmp(reservoirNeurons,string(neurons(i))))
        neuronsGephi(i,2) = {'Reservoir'};
    elseif any(strcmp(inputLayer{1,1},string(neurons(i))))
        neuronsGephi(i,2) = {'Input'};
    else
        neuronsGephi(i,2) = {'Readout'};
    end
end

for i = 1:length(neurons)
    if i < 84
        neuronsGephi(i,3) = {'Sensory Neurons'};
    elseif i >= 84 && i < 165
        neuronsGephi(i,3) = {'Interneurons'};
    elseif i >= 165 && i < 273
        neuronsGephi(i,3) = {'Motor Neurons'};
    elseif i >= 273 && i < 368
        neuronsGephi(i,3) = {'Bodywall Muscles'};
    elseif i >= 368 && i < 384
        neuronsGephi(i,3) = {'Other-end Organs'};
    elseif i >= 384
        neuronsGephi(i,3) = {'Sex-specific Cells'};
    end
end

fileID = fopen('Gephi/neurons.csv','w');
fprintf(fileID,'Id, label, posx, posy, nodetype, function\n');


input_posy = [-0.5,0.5];
readout_posy = [-0.5,0,0.5];

knownNeurons = [15 16 129 159 157 143 144 150 169];

for i = 1:length(neuronsGephi)
    if any(knownNeurons == i)
        if strcmp(neuronsGephi(i,2),'Reservoir')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),string(neuronsGephi(i,1)),...
                8+normrnd(0,1.5),normrnd(0,1.5),string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
        elseif strcmp(neuronsGephi(i,2),'Input')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),string(neuronsGephi(i,1)),...
                0,input_posy(1),string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
            input_posy(1) = [];
        elseif strcmp(neuronsGephi(i,2),'Readout')
            if any(strcmp(readoutLayer{1,1},string(neuronsGephi(i,1))))
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),string(neuronsGephi(i,1)),...
                    20+normrnd(0,0.25),normrnd(0,1.5),...
                    string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
            else
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),string(neuronsGephi(i,1)),...
                    16,readout_posy(1),...
                    string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
                readout_posy(1) = [];
            end
        end
    else
        if strcmp(neuronsGephi(i,2),'Reservoir')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),'',...
                8+normrnd(0,1.5),normrnd(0,1.5),string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
        elseif strcmp(neuronsGephi(i,2),'Input')
            fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),'',...
                0,input_posy(1),string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
            input_posy(1) = [];
        elseif strcmp(neuronsGephi(i,2),'Readout')
            if any(strcmp(readoutLayer{1,1},string(neuronsGephi(i,1))))
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),'',...
                    20+normrnd(0,0.25),normrnd(0,1.5),...
                    string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
            else
                fprintf(fileID,'%s,%s,%f,%f,%s,%s\n',string(neuronsGephi(i,1)),'',...
                    16,readout_posy(1),...
                    string(neuronsGephi(i,2)),string(neuronsGephi(i,3)));
                readout_posy(1) = [];
            end
        end 
    end
end

fclose(fileID);

fileID = fopen('Gephi/edges.csv','w');
fprintf(fileID,'Source, Target\n');

for i = 1:length(neuronsGephi)
    for j = 1:length(neuronsGephi)
        if A(i,j)>0
            fprintf(fileID,'%s,%s\n',string(neuronsGephi(i,1)),string(neuronsGephi(j,1)));
        end
    end
end

fclose(fileID);