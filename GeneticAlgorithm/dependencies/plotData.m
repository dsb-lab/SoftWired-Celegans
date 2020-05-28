function plotData(nIterations, bestIndividualIteration, bestIndividualsAll, bestIndividualRatio, neuronalData, time)
% 
% Function: 
% – plotData: Plots different graphs: Ratio and fitness, comparison of time
%   series, and correlation over generations.
%
% Inputs:
% - nIterations: Number of simulated generations.
% - bestIndividualIteration: Best individual of the historic generations.
% – bestIndividualsAll: Best individuals along generations.
% – bestIndividualRatio: Ratio of the best individual.
% – neuronalData: Neuronal time series.
% – time: Duration of neuronal data.
%
% https://github.com/sgalella-macasal-repo/SoftWired-Celegans
%

originalSize = [1 1 1280 800];
actualSize = get(0,'ScreenSize');
scale = actualSize(3)/originalSize(3);
columns = 2;
defaultFont = get(gca,'FontSize');

ccAIBL = zeros(1,nIterations);
ccAVAL = zeros(1,nIterations);
ccAVBL = zeros(1,nIterations);
ccAVDL = zeros(1,nIterations);
ccAVDR = zeros(1,nIterations);
ccRIML = zeros(1,nIterations);
ccRMEL = zeros(1,nIterations);

idxPruned = [127 157 155 141 142 148 167];

%%%%%%%%%%%%%%
%%% Axis 1 %%%
%%%%%%%%%%%%%%


subplot(10, columns, 1:(columns*3))
yyaxis left
plot(1:nIterations, bestIndividualIteration, 'LineWidth', scale)
set(gca, 'FontSize', defaultFont*scale)
xlabel('Iterations','FontSize', 12*scale, 'Interpreter', 'latex')
ylabel('Fitness','FontSize', 12*scale, 'Interpreter', 'latex')
title(['Temporal Evolution',' (',num2str(mean(bestIndividualsAll{end,3})),', ',num2str(calculateExciInhiRatio(bestIndividualsAll{end,1})),...
        ')'],'FontSize', 15*scale, 'Interpreter','latex')
ylim([0 1]);
xlim([1 nIterations])

yyaxis right

plot(1:nIterations, bestIndividualRatio, 'LineWidth', scale)
ylabel('\% Inhibition','FontSize', 12 * scale,'Interpreter','latex')
ylim([0 100])


for iIteration = 1:nIterations
    correlationsTime = cell2mat(bestIndividualsAll(iIteration,3));
    ccAIBL(iIteration) = correlationsTime(1); 
    ccAVAL(iIteration) = correlationsTime(2); 
    ccAVBL(iIteration) = correlationsTime(3); 
    ccAVDL(iIteration) = correlationsTime(4); 
    ccAVDR(iIteration) = correlationsTime(5); 
    ccRIML(iIteration) = correlationsTime(6); 
    ccRMEL(iIteration) = correlationsTime(7); 
end


%%%%%%%%%%%%%%
%%% Axis 2 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 7)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(1),:)), 'r', 'LineWidth', scale)
hold on
plot(time, normalize(neuronalData(6,:)), 'b', 'LineWidth', scale)
title(['AIBL',' (',num2str(bestIndividualsAll{end,3}(1)),')'],'FontSize', 12*scale,'Interpreter','latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 9 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 8)
plot(1:nIterations, ccAIBL, 'Color', [107,142,35]/255, 'LineWidth',scale)
title('AIBL correlation', 'FontSize', 12*scale, 'Interpreter', 'latex')
xlim([1 nIterations])
ylim([0 1])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 3 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 9)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(2),:)), 'r', 'LineWidth', scale)
hold on
plot(time, normalize(neuronalData(7,:)), 'b', 'LineWidth', scale)
title(['AVAL',' (',num2str(bestIndividualsAll{end,3}(2)),')'], 'FontSize', 12*scale,'Interpreter','latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 10 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 10)
plot(1:nIterations, ccAVAL, 'Color', [107,142,35]/255, 'LineWidth', scale)
title('AVAL correlation', 'FontSize', 12*scale, 'Interpreter', 'latex')
if nIterations ~=1
    xlim([1 nIterations]) 
end
ylim([0 1])
set(gca, 'xtick', []);
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 4 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 11)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(3),:)), 'r', 'LineWidth', scale)
hold on
plot(time, normalize(neuronalData(4,:)), 'b', 'LineWidth', scale)
title(['AVBL',' (', num2str(bestIndividualsAll{end,3}(3)),')'], 'FontSize', 12*scale,'Interpreter','latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%%
%%% Axis 11 %%%
%%%%%%%%%%%%%%%

subplot(10, columns, 12)
plot(1:nIterations, ccAVBL, 'Color',[107,142,35]/255, 'LineWidth', scale)
title('AVBL correlation','FontSize', 12*scale,'Interpreter','latex')
xlim([1 nIterations])
ylim([0 1])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 5 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 13)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(4),:)), 'r', 'LineWidth', scale)
hold on
plot(time, normalize(neuronalData(28,:)), 'b', 'LineWidth', scale)
title(['AVDL',' (',num2str(bestIndividualsAll{end,3}(4)),')'],'FontSize', 12*scale,'Interpreter','latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%%
%%% Axis 12 %%%
%%%%%%%%%%%%%%%

subplot(10, columns, 14)
plot(1:nIterations, ccAVDL, 'Color', [107,142,35]/255, 'LineWidth', scale)
title('AVDL correlation', 'FontSize', 12*scale, 'Interpreter', 'latex')
xlim([1 nIterations])
ylim([0 1])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 6 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 15)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(5),:)), 'r', 'LineWidth', scale)
hold on
plot(time,normalize(neuronalData(49,:)), 'b', 'LineWidth', scale)
title(['AVDR',' (',num2str(bestIndividualsAll{end,3}(5)),')'],'FontSize', 12*scale, 'Interpreter', 'latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%%
%%% Axis 13 %%%
%%%%%%%%%%%%%%%

subplot(10, columns, 16)
plot(1:nIterations, ccAVDR, 'Color', [107,142,35]/255, 'LineWidth', scale)
title('AVDR correlation','FontSize', 12*scale,'Interpreter','latex')
xlim([1 nIterations])
ylim([0 1])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 7 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 17)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(6),:)), 'r', 'LineWidth', scale)
hold on
plot(time, normalize(neuronalData(2,:)), 'b', 'LineWidth', scale)
title(['RIML',' (',num2str(bestIndividualsAll{end,3}(6)),')'],'FontSize', 12*scale, 'Interpreter', 'latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%%
%%% Axis 14 %%%
%%%%%%%%%%%%%%%

subplot(10, columns, 18)
plot(1:nIterations, ccRIML, 'Color', [107,142,35]/255, 'LineWidth', scale)
title('RIML correlation','FontSize', 12*scale,'Interpreter','latex')
ylim([0 1])
xlim([1 nIterations])
set(gca, 'xtick', [])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%
%%% Axis 8 %%%
%%%%%%%%%%%%%%

subplot(10, columns, 19)
plot(time, normalize(bestIndividualsAll{end,2}(idxPruned(7),:)), 'r', 'LineWidth', scale)
hold on
plot(time, normalize(neuronalData(11,:)), 'b', 'LineWidth', scale)
title(['RMEL',' (',num2str(bestIndividualsAll{end,3}(7)),')'],'FontSize', 12*scale,'Interpreter','latex')
xlabel('time [s]','FontSize',12*scale,'Interpreter','Latex')
xlim([0 226.1])
ylim([-5 5])
set(gca, 'FontSize', defaultFont*scale*0.75)


%%%%%%%%%%%%%%%
%%% Axis 15 %%%
%%%%%%%%%%%%%%%

subplot(10, columns, 20)
plot(1:nIterations, ccRMEL,'Color', [107,142,35]/255, 'LineWidth', scale)
title('RMEL correlation','FontSize', 12*scale, 'Interpreter', 'latex')
xlabel('Iterations', 'FontSize', 12*scale, 'Interpreter', 'Latex')
xlim([1 nIterations])
ylim([0 1])
set(gca, 'FontSize', defaultFont*scale*0.75)


end
