% Clear workspace
clc;
clear;

% Load data
interSeriesCorr = csvread("fig5_interseries_corr.csv");
intraSeriesCorr = csvread("fig5_intraseries_corr.csv");

% Compute the chi-square test
nbins = 200;
[chiSquaredValue, pValue] = computeChiSquareTest(interSeriesCorr, intraSeriesCorr, nbins-1);