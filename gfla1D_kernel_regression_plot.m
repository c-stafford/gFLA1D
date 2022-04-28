% Kernel regression plot

clear; close all;

load gfla1D_kernel_regression
plot_opts

caxismin = min(p_grid(p_grid > 0));
caxismax = max(p_grid(p_grid > 0));
p_grid(p_grid == 0) = eps;

% Extract variables
Nx = size(p_grid,1) - 1;
Nr = size(p_grid,2) - 1;

% Meshgrid for interpolation
Xgrid = zeros(Nx+1,Nr+1);
Rgrid = zeros(Nx+1,Nr+1);
for nx = 1:Nx+1
    for nr = 1:Nr+1
        Xgrid(nx,nr) = xmesh(nx);
        Rgrid(nx,nr) = rmesh(nr);
    end
end

% Figure sizing
plotsizex = 1024;
plotsizey = 540;
screensize = get(0,'ScreenSize');
figleft = screensize(3)/2 - plotsizex/2;
figbottom = screensize(4)/2 - plotsizey/2;
set(0,'DefaultAxesXLimMode','auto')
set(0,'DefaultAxesYLimMode','auto')
hintspace = 0.00;
vintspace = 0.00;
cbarspace = 0.13;

figure('position',[figleft figbottom plotsizex plotsizey],'visible','on');
clf
fig = pcolor(Xgrid,Rgrid,p_grid);
set(fig,'EdgeColor','none')
box on
title('Probability density $p (x,r)$')
xlabel('$x$')
ylabel('$r / r_{d0}^*$')
axis equal
axis([min(reshape(Xgrid,[],1)) max(reshape(Xgrid,[],1)) min(reshape(Rgrid,[],1)) max(reshape(Rgrid,[],1))])
colormap([[1,1,1];turbo])
c1 = colorbar('Fontsize',18,'Location','EastOutside');
c1.Label.FontSize = 18;
c1.Label.Interpreter = 'latex';
c1.TickLabelInterpreter = 'latex';
c1.Label.String = '$p$';
c1.Ruler.MinorTick = 'on';
caxis([10^-4 1])
set(gca,'ColorScale','log')
set(gca,'Layer','top')

hgexport(gcf,[mfilename,'.',imgtype],hgexport('factorystyle'),'Format',imgtype);