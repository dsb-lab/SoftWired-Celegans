function cumulativeDist = computeCumulativeFromHistogram(correlationNeuron, nBins)
% Creates CDF from neuron histogram

edges = linspace(0, 1, nBins+1);
countsHist = histcounts(correlationNeuron, edges);
countsHistNorm = countsHist / sum(countsHist);
cumulativeDist = cumsum(countsHistNorm);

end

