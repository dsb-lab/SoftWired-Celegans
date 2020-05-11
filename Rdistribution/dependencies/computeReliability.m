function R = computeReliability(correlationIntra, correlationInter, nBins)
% Creates CDF from intraseries and interseries historam

cumulativeDistIntra = computeCumulativeFromHistogram(correlationIntra, nBins);
cumulativeDistInter = computeCumulativeFromHistogram(correlationInter, nBins);
R = 2 * (trapz(cumulativeDistInter, cumulativeDistIntra) - 0.5);

end

