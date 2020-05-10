function [chiSquareValue, pValue] = computeChiSquareTest(X, Y, k)
%
% Function
% computeChiSquaredTest: Calculates the chi-square test of homogeneity
% between two data sets, X and Y, with degree of freedom k
% 
% Inputs:
% X: First set of sampled data (Double array)
% Y: Second set of sampled data (Double array)
% k: Degrees of freedom for chi distribution (Bins of the histogram - 1)
% 
% Output
% chiSquaredValue: Chi-square test result
% pValue: P-value of the chi-square test

% Compute histogram
edges = 0:1/(k+1):1;
countsX = histcounts(X, edges);
countsY = histcounts(Y, edges);

% Total samples for each histogram
sumCountsX = sum(countsX);
sumCountsY = sum(countsY);

sumTotal = sumCountsX + sumCountsY;

% Sum for each bin across histograms
sumColumns = countsX + countsY;

% Expected value for each bin and histogram
expectedProb = sumColumns / sumTotal;
countsNorm1Expected = expectedProb .* sumCountsX;
countsNorm2Expected = expectedProb .* sumCountsY;

% Computing chi suared
chiSquareValue = sum(((countsX - countsNorm1Expected).^2)./countsNorm1Expected) + ...
                  sum(((countsY - countsNorm2Expected).^2)./countsNorm2Expected);

% Computing chi distribution
epsilon = 10e-4;
chiVec = 0:epsilon:2*k;
chiSquarePdf = chi2pdf(chiVec, k);

% Compute pValue
[~, col] = find(abs(chiVec - chiSquareValue) < epsilon);
if col
    pValue = trapz(chiVec(col(1):end), chiSquarePdf(col(1):end));
else
    pValue = 0; 
end

% Uncomment to plot chi distribution
% plot(chiVec, chiSquarePdf);

end

