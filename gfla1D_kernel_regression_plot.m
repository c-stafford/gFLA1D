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

figure('position',[figleft figbottom plotsizex plotsizey]);
clf
fig = pcolor(Xgrid,Rgrid,p_grid);
set(fig,'EdgeColor','none')
title('Probability density $p(x,r)$')
xlabel('$x$')
ylabel('$r / r_{d0}^*$')
axis equal
axis([min(reshape(Xgrid,[],1)) max(reshape(Xgrid,[],1)) min(reshape(Rgrid,[],1)) max(reshape(Rgrid,[],1))])
colormap([[1,1,1];turbo])
c1 = colorbar('Fontsize',labelsize,'Location','EastOutside');
c1.Label.FontSize = labelsize;
c1.Label.String = '$p$';
c1.Label.Interpreter = 'latex';
caxis([10^-4 1])
set(gca,'ColorScale','log')

hgexport(gcf,[mfilename,'.',imgtype],hgexport('factorystyle'),'Format',imgtype);
