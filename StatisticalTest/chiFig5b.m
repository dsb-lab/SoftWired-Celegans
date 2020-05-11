% Clear workspace
clc;
clear;

% Load data
interSeriesCorr = csvread("fig5_interseries_cor.csv");
intraSeriesCorr = csvread("fig5_intraseries_cor.csv");

% Compute the chi-square test
nbins = 200;
[chiSquaredValue, pValue] = computeChiSquareTest(interSeriesCorr, intraSeriesCorr, nbins-1);