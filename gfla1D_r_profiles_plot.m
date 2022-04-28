% Probability density profiles at r cross sections

clear; close all;

load gfla1D_kernel_regression
plot_opts

% Extract variables
Nx = size(p_grid,1) - 1;
Nr = size(p_grid,2) - 1;

% r cross sections for plotting number density profile
rcs = [0.0,0.5,1.0,1.5,2.0];
NCS = size(rcs,2);

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
    rval = rcs(ncs);            % r location value
    nr = floor(rval/dr) + 1;    % Grid point number
    plot(xmesh,p_grid(:,nr),datastyle{ncs},'LineWidth',1);
    legendinfo{ncs} = ['$r = ',num2str(rval),'$'];
end
hold off
legend(legendinfo,'Location','NorthEast');
title('$p (x,r)$ profiles')
xlabel('$x$')
ylabel('$p$')
axis([0 4 0 1])
set(gca,'Layer','top')

hgexport(gcf,[mfilename,'.',imgtype],hgexport('factorystyle'),'Format',imgtype);