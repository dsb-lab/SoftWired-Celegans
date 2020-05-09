% Clear workspace
clc;
clear;

% Load data
interSeriesCorr = csvread("fig5_interseries_corr.csv");
intraSeriesCorr = csvread("fig5_intraseries_corr.csv");

%chi squared test
nbins = 200;
[chiSquaredValue, pValue] = ComputeChiSquaredTest(interSeriesCorr, intraSeriesCorr, nbins-1)