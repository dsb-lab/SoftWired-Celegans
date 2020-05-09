function [chiSquaredValue, pValue] = ComputeChiSquaredTest(X, Y, k)
% X: first set of sampled data
% Y: second set of sampled data
% k: degrees of freedom for chi distribution (bins of the histogram - 1)

%compute histogram
edges = 0:1/(k+1):1;
countsX = histcounts(X, edges);
countsY = histcounts(Y, edges);

%total samples for each histogram
sumCountsX = sum(countsX);
sumCountsY = sum(countsY);

sumTotal = sumCountsX + sumCountsY;

%sum for each bin across histograms
sumColumns = countsX + countsY;

%expected value for each bin and histogram
expectedProb = sumColumns / sumTotal;
countsNorm1Expected = expectedProb .* sumCountsX;
countsNorm2Expected = expectedProb .* sumCountsY;

%computing chi suared
chiSquaredValue = sum(((countsX - countsNorm1Expected).^2)./countsNorm1Expected) + ...
                  sum(((countsY - countsNorm2Expected).^2)./countsNorm2Expected);

%computing chi distribution
epsilon = 10e-4
chiVec = 0:epsilon:2*k;
chiSquarePdf = chi2pdf(chiVec, k);

%uncomment to plot chi distribution
%plot(chiVec, chiSquarePdf);

%compute pvalue
[~, col] = find(abs(chiVec - chiSquaredValue) < epsilon);
if col
    pValue = trapz(chiVec(col(1):end), chiSquarePdf(col(1):end));
else
    pValue = 0; 
end

end

