
% Plot heatmap
results = csvread('cluster_matrix_100000.csv');
N = 120; Y = 0.47:(0.3/N):0.72; X = 0:(100/N):100;
N = histcounts2(results(:,3), results(:,2), Y, X);
imagesc(X,Y,log(N));
set(gca,'YDir','normal')
colormap jet
fig1 = gcf;
fig1.Units = 'inches';
fig1.Position = [0 0 15 5];
xlabel('$\%$ Inhibition','Interpreter','latex','fontsize',20)
ylabel('Fitness','Interpreter','latex','fontsize',20)
colormap jet
colorbar