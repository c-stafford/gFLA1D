% 1D gFLA animation in (x,r) space

clear; close all;

% ----------------------------------------------------------

% Sampling rate of timesteps
nf = 4;

% Switches
sswitch = 0;    % Switch to save frames (0 = no, 1 = yes)

% ----------------------------------------------------------

load gfla1D
plot_opts

% Folder to save in
fname = mfilename;
if (~exist(fname,'dir')) && (sswitch == 1)
    mkdir(fname);
end

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

% ----------------------------------------------------------

% Set up figure
figure('position',[figleft figbottom plotsizex plotsizey])
clf
hold on
scpt = scatter(xd(1,:),rd(1,:),20,nd(1,:),'filled');
hold off
title(['$t = \;$',num2str((1-1)*dt,'%.2f')],'Fontsize',12,'Interpreter','latex');
xlabel('$x$','Fontsize',labelsize,'Interpreter','latex');
ylabel('$r / r_{d0}^*$','Fontsize',labelsize,'Interpreter','latex');
axis equal
axis([min(reshape(xd,[],1)) max(reshape(xd,[],1)) min(reshape(rd,[],1)) max(reshape(rd,[],1))])
colormap turbo
c1 = colorbar('Fontsize',18,'Location','EastOutside');
c1.Label.FontSize = labelsize;
c1.Label.Interpreter = 'latex';
c1.TickLabelInterpreter = 'latex';
c1.Label.String = '$n_d$';
caxis([10^-4 1])
set(gca,'ColorScale','log')
set(gca,'Fontsize',labelsize);

% Loop through timesteps
for ns = 2:nf:NS
    
    % Trajectories which have not evaporated
    nrvals = find(NSEVAP > ns);
    
    set(scpt,'XData',xd(ns,nrvals));
    set(scpt,'YData',rd(ns,nrvals));
    set(scpt,'CData',nd(ns,nrvals));
    title(['$t = \;$',num2str((ns-1)*dt,'%.2f')],'Fontsize',20,'Interpreter','latex');
    
    drawnow
    pause(0.05)
    
    if sswitch == 1
        hgexport(gcf,[fname,'/',fname,num2str((ns-1)/nf,'%03.f'),'.',imgtype],hgexport('factorystyle'),'Format',imgtype);
    end

end

% ----------------------------------------------------------

close