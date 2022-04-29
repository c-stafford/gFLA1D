% Plotting of averaged field variables

clear; close all;

% ----------------------------------------------------------

% Sampling rate of data points
nfx = 2;

% ----------------------------------------------------------

load gfla1D_statistics
plot_opts

% Figure sizing
plotsizex = 1024;
plotsizey = 540;
screensize = get(0,'ScreenSize');
figleft = screensize(3)/2 - plotsizex/2;
figbottom = screensize(4)/2 - plotsizey/2;

figure('position',[figleft figbottom plotsizex plotsizey]);
clf
legendinfo = cell(1,3);
hold on
plot(xmesh(1:nfx:end),rho_grid(1:nfx:end),datastyle{1});
legendinfo{1} = '$n$';
plot(xmesh(1:nfx:end),ravg(1:nfx:end),datastyle{2});
legendinfo{2} = '$\overline{r} / r_{d0}^*$';
plot(xmesh(1:nfx:end),rvar(1:nfx:end),datastyle{3});
legendinfo{3} = '$\overline{r^{\prime}r^{\prime}} / {r_{d0}^*}^2$';
hold off
legend(legendinfo,'Location','East');
title('Averaged field variables')
xlabel('$x$')
axis([xmin xmax 0 1.05*max(ravg)]);

hgexport(gcf,[mfilename,'.',imgtype],hgexport('factorystyle'),'Format',imgtype);