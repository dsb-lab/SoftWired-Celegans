function plotData(iterations, best_individual_iteration, best_individuals_all, best_individual_ratio, neuronal_data_standardized, time)
% Plots the genetic algorithm throughout iterations, including the inhibition, 
% the best signals and the correlation evolution.


original_size = [1 1 1280 800];
actual_size = get(0,'ScreenSize');
scale = actual_size(3)/original_size(3);

columns = 2;

default_font = get(gca,'FontSize');

CC_AIBL = zeros(1,iterations);
CC_AVAL = zeros(1,iterations);
CC_AVBL = zeros(1,iterations);
CC_AVDL = zeros(1,iterations);
CC_AVDR = zeros(1,iterations);
CC_RIML = zeros(1,iterations);
CC_RMEL = zeros(1,iterations);

idx_neurons = [127 157 155 141 142 148 167];

%%%%%%%%%%%%%%
%%% Axis 1 %%%
%%%%%%%%%%%%%%


subplot(10,columns,1:(columns*3));
yyaxis left
plot(1:iterations,best_individual_iteration,'LineWidth',scale);
set(gca, 'FontSize', default_font*scale)
xlabel('Iterations','FontSize', 12*scale,'Interpreter','latex');
ylabel('Fitness','FontSize', 12*scale,'Interpreter','latex');
title(['Temporal Evolution',' (',num2str(mean(best_individuals_all{end,3})),', ',num2str(calculateExciInhiRatio(best_individuals_all{end,1})),...
        ')'],'FontSize', 15*scale,'Interpreter','latex');
ylim([0 1]);
xlim([1 iterations])

yyaxis right

plot(1:iterations,best_individual_ratio,'LineWidth',scale);
ylabel('\% Inhibition','FontSize', 12*scale,'Interpreter','latex');
ylim([0 100]);


for i = 1:iterations
    
    correlations_time = cell2mat(best_individuals_all(i,3));
    CC_AIBL(i) = correlations_time(1); 
    CC_AVAL(i) = correlations_time(2); 
    CC_AVBL(i) = correlations_time(3); 
    CC_AVDL(i) = correlations_time(4); 
    CC_AVDR(i) = correlations_time(5); 
    CC_RIML(i) = correlations_time(6); 
    CC_RMEL(i) = correlations_time(7); 

end


%%%%%%%%%%%%%%
%%% Axis 2 %%%
%%%%%%%%%%%%%%

subplot(10,columns,7);
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(1),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(6,:)),'b','LineWidth',scale)
xlim([0 226.1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
%ylim([min(normalize(neuronal_data_standardized(6,:)))-1 max(normalize(neuronal_data_standardized(6,:)))+1])
ylim([-5 5])
title(['AIBL',' (',num2str(best_individuals_all{end,3}(1)),')'],'FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 9 %%%
%%%%%%%%%%%%%%

subplot(10,columns,8);
plot(1:iterations,CC_AIBL,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
xlim([1 iterations]);
title('AIBL correlation','FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 3 %%%
%%%%%%%%%%%%%%

subplot(10,columns,9);
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(2),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(7,:)),'b','LineWidth',scale)
xlim([0 226.1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
%ylim([min(normalize(neuronal_data_standardized(7,:)))-1 max(normalize(neuronal_data_standardized(7,:)))+1])
ylim([-5 5])
title(['AVAL',' (',num2str(best_individuals_all{end,3}(2)),')'],'FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 10 %%%
%%%%%%%%%%%%%%

subplot(10,columns,10);
plot(1:iterations,CC_AVAL,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
if iterations ~=1; xlim([1 iterations]); end
title('AVAL correlation','FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 4 %%%
%%%%%%%%%%%%%%

subplot(10,columns,11);
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(3),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(4,:)),'b','LineWidth',scale)
xlim([0 226.1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
%ylim([min(normalize(neuronal_data_standardized(4,:)))-1 max(normalize(neuronal_data_standardized(4,:)))+1])
ylim([-5 5])
title(['AVBL',' (',num2str(best_individuals_all{end,3}(3)),')'],'FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);

%%%%%%%%%%%%%%%
%%% Axis 11 %%%
%%%%%%%%%%%%%%%

subplot(10,columns,12)
plot(1:iterations,CC_AVBL,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
xlim([1 iterations]);
title('AVBL correlation','FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 5 %%%
%%%%%%%%%%%%%%


subplot(10,columns,13)
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(4),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(28,:)),'b','LineWidth',scale)
xlim([0 226.1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
%ylim([min(normalize(neuronal_data_standardized(28,:)))-1 max(normalize(neuronal_data_standardized(28,:)))+1])
ylim([-5 5])
title(['AVDL',' (',num2str(best_individuals_all{end,3}(4)),')'],'FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%%
%%% Axis 12 %%%
%%%%%%%%%%%%%%%

subplot(10,columns,14)
plot(1:iterations,CC_AVDL,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
xlim([1 iterations]);
title('AVDL correlation','FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 6 %%%
%%%%%%%%%%%%%%

subplot(10,columns,15)
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(5),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(49,:)),'b','LineWidth',scale)
xlim([0 226.1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
%ylim([min(normalize(neuronal_data_standardized(49,:)))-1 max(normalize(neuronal_data_standardized(49,:)))+1])  
ylim([-5 5])
title(['AVDR',' (',num2str(best_individuals_all{end,3}(5)),')'],'FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%%
%%% Axis 13 %%%
%%%%%%%%%%%%%%%

subplot(10,columns,16);
plot(1:iterations,CC_AVDR,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
xlim([1 iterations]);
title('AVDR correlation','FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 7 %%%
%%%%%%%%%%%%%%

subplot(10,columns,17)
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(6),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(2,:)),'b','LineWidth',scale)
xlim([0 226.1])
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
%ylim([min(normalize(neuronal_data_standardized(2,:)))-1 max(normalize(neuronal_data_standardized(2,:)))+1])    
ylim([-5 5])
title(['RIML',' (',num2str(best_individuals_all{end,3}(6)),')'],'FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]); 


%%%%%%%%%%%%%%%
%%% Axis 14 %%%
%%%%%%%%%%%%%%%

subplot(10,columns,18)
set(gca,'xtick',[]); set(gca, 'FontSize', default_font*scale*0.75)
plot(1:iterations,CC_RIML,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
xlim([1 iterations]);
title('RIML correlation','FontSize', 12*scale,'Interpreter','latex')
set(gca,'xtick',[]);


%%%%%%%%%%%%%%
%%% Axis 8 %%%
%%%%%%%%%%%%%%

subplot(10,columns,19);
plot(time,normalize(best_individuals_all{end,2}(idx_neurons(7),:)),'r','LineWidth',scale);
hold on
plot(time,normalize(neuronal_data_standardized(11,:)),'b','LineWidth',scale)
xlim([0 226.1])
%ylim([min(normalize(neuronal_data_standardized(11,:)))-1 max(normalize(neuronal_data_standardized(11,:)))+1])
ylim([-5 5])
set(gca, 'FontSize', default_font*scale*0.75)
title(['RMEL',' (',num2str(best_individuals_all{end,3}(7)),')'],'FontSize', 12*scale,'Interpreter','latex')
xlabel('time [s]','FontSize',12*scale,'Interpreter','Latex');


%%%%%%%%%%%%%%%
%%% Axis 15 %%%
%%%%%%%%%%%%%%%

subplot(10,columns,20);
plot(1:iterations,CC_RMEL,'Color',[107,142,35]/255,'LineWidth',scale);
ylim([0 1])
xlim([1 iterations]);
set(gca, 'FontSize', default_font*scale*0.75)
title('RMEL correlation','FontSize', 12*scale,'Interpreter','latex');
xlabel('Iterations','FontSize',12*scale,'Interpreter','Latex');



end
