clc; clear; close all;

% Print number of cores
%numcores = feature('numcores');
%ppool = parpool('local',numcores);

%random number generator
runSeed = 5000;
rng(runSeed)

%load optimal network
addpath('Matlab_data');
mat = load('optimalNetwork.mat');
W = abs(mat.A_norm_max_inh);

%parameter initialization
time = 2000;
inhibition = 0:5:275;
Hstd = NaN(1,length(inhibition));
Hmean = NaN(1,length(inhibition));
num_trials = 8000;
num_sets = 10;
num_trials_set = num_trials / num_sets;
N = length(W);

for i = 1:length(inhibition)

    inhi = inhibition(i);
    H = zeros(N,num_trials);

    parfor j = 1:num_trials

        W_trial = randomInhibition(W,inhi); %inhibit optimal network
        rows_inhi_W = checkInhibition(W_trial);
        X = simulation(time,W_trial); %simulate dynamics
        for k = 1:N
            y = X(k,time/4:time);
            H(k,j) = petropy(y,3,1,'order'); %pentropy for each neuron and trial
        end
    end

    H = reshape(H,[size(H,1),num_trials_set,num_sets]);
    Hmean_set = [];
    Hstd_set = [];
    for j = 1:num_sets
        Hmean_neurons = mean(H(:,:,j)) %mean across neurons
        Hmean_set(j) = mean(Hmean_neurons); %mean across networks
        Hstd_set(j) = std(Hmean_neurons); %std across networks
    end
    Hmean(i) = nanmean(Hmean_set./Hstd_set); %mean across sets
    Hstd(i) = nanstd(Hmean_set./Hstd_set); %std across sets
end

clearvars -except Hstd Hmean

%uncomment to save results
%save('chaos_pentropy.mat')
