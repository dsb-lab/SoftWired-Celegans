results = csvread('cluster_matrix.csv');

h = figure();


%axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';

total_frames = 150;

for n = 1:total_frames
subplot(2,1,1)
plot(results(1:n*length(results)/total_frames,2),results(1:n*length(results)/total_frames,3),'b.');
xlim([0 100]); ylim([0.47 0.72]);
drawnow

subplot(2,1,2)
N = 120; Y = 0.47:(0.3/N):0.72; X = 0:(100/N):100;
N = histcounts2(results(1:n*length(results)/total_frames,3), results(1:n*length(results)/total_frames,2), Y, X);
imagesc(X,Y,log(N));
set(gca,'YDir','normal')
colormap jet
xlim([0 100]); ylim([0.47 0.72]); h.Position = [360 278 560 420];
drawnow

% Capture the plot as an image 
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
if n == 1 
  imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime', 0.03); 
else 
  imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime', 0.03); 
end 

end