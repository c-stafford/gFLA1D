% Droplet trajectory plot

clear; close all;

load gfla1D
plot_opts

% Replace zero number density values with NaN
nd(nd == 0) = NaN;

% Figure sizing
plotsizex = 1024;
plotsizey = 540;
screensize = get(0,'ScreenSize');
figleft = screensize(3)/2 - plotsizex/2;
figbottom = screensize(4)/2 - plotsizey/2;
set(0,'DefaultAxesXLimMode','auto')
set(0,'DefaultAxesYLimMode','auto')
labelsize = 18;

figure('position',[figleft figbottom plotsizex plotsizey],'visible','on');
clf
hold on
for j = 1:NR
    scatter(xd(:,j),rd(:,j),6,nd(:,j),'filled');
end
hold off
box on
title('Droplet Trajectories')
xlabel('$x$')
ylabel('$r / r_{d0}^*$')
axis equal
axis([min(reshape(xd,[],1)) max(reshape(xd,[],1)) min(reshape(rd,[],1)) max(reshape(rd,[],1))])
colormap([[1,1,1];turbo])
c1 = colorbar('Fontsize',15,'Location','EastOutside');
c1.Label.FontSize = labelsize;
c1.Label.String = '$n_{d}$';
c1.Label.Interpreter = 'latex';
c1.TickLabelInterpreter = 'latex';
caxis([10^-4 1])
set(gca,'ColorScale','log')
set(gca,'Layer','top')
hgexport(gcf,['xr_trajectories','.',imgtype],hgexport('factorystyle'),'Format',imgtype);