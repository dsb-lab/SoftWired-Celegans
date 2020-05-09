
rng(1);

norm1 = normrnd(0, 1, [1, 100000]);
norm2 = normrnd(0, 1, [1, 100000]);
histogram(norm1)
hold on
histogram(norm2)


numBins = 100;
edges = 0:1/numBins:1;
countsNorm1 = histcounts(norm1, edges);
countsNorm2 = histcounts(norm2, edges);

sumCountsNorm1 = sum(norm1);
sumCountsNorm2 = sum(norm2);

sumTotal = sumCountsNorm1 + sumCountsNorm2;
sumColumns = countsNorm1 + countsNorm2;

expectedProb = sumColumns / sumTotal;

countsNorm1Expected = expectedProb .* countsNorm1;
countsNorm2Expected = expectedProb .* countsNorm2;

chi = sum(((countsNorm1 - countsNorm1Expected).^2)./countsNorm1Expected) + ...
      sum(((countsNorm2 - countsNorm2Expected).^2)./countsNorm2Expected);