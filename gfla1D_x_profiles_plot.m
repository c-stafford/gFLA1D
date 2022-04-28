% Probability density profiles at x cross sections

clear; close all;

load gfla1D_kernel_regression
plot_opts

% Extract variables
Nx = size(p_grid,1) - 1;
Nr = size(p_grid,2) - 1;

% x cross sections for plotting number density profile
xcs = [0.0,0.5,1.0,2.0,4.0];
NCS = size(xcs,2);

% Figure sizing
plotsizex = 1024;
plotsizey = 540;
screensize = get(0,'ScreenSize');
figleft = screensize(3)/2 - plotsizex/2;
figbottom = screensize(4)/2 - plotsizey/2;
set(0,'DefaultAxesXLimMode','auto')
set(0,'DefaultAxesYLimMode','auto')

% Color vector
colvals = {'k','b','r','y','g','c'};

figure('position',[figleft figbottom plotsizex plotsizey],'visible','on');
clf
legendinfo = cell(1,NCS);
hold on
for ncs = 1:NCS
    xval = xcs(ncs);            % x location value
    nx = floor(xval/dx) + 1;    % Grid point number
    plot(rmesh,p_grid(nx,:),datastyle{ncs},'LineWidth',1);
    legendinfo{ncs} = ['$x = ',num2str(xval),'$'];
end
hold off
legend(legendinfo,'Location','NorthEast');
title('$p (x,r)$ profiles')
xlabel('$r / r_{d0}^*$')
ylabel('$p$')
set(gca,'Layer','top')

hgexport(gcf,[mfilename,'.',imgtype],hgexport('factorystyle'),'Format',imgtype);