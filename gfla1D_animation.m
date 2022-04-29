% 1D gFLA animation

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

% Scaling value for plotting radius values
scalr = 50;

% Replace zero radius values with NaN
rd(rd == 0) = NaN;

% Replace zero number density values with NaN
nd(nd == 0) = NaN;

% Specify zero y-values for plotting
yd = zeros(NR,1);

% Figure sizing
plotsizex = 768;
plotsizey = 360;
screensize = get(0,'ScreenSize');
figleft = screensize(3)/2 - plotsizex/2;
figbottom = screensize(4)/2 - plotsizey/2;

% ----------------------------------------------------------

% Set up figure
figure('outerposition',[figleft figbottom plotsizex plotsizey])
clf
scpt = scatter(xd(1,:),yd,scalr*rd(1,:).^2,nd(1,:),'filled');
title(['$t = \;$',num2str((1-1)*dt,'%.2f')]);
xlabel('$x$');
axis equal
axis([min(reshape(xd,[],1)) max(reshape(xd,[],1)) min(yd)-eps max(yd)+eps])
colormap turbo
c1 = colorbar('Fontsize',labelsize,'Location','SouthOutside');
c1.Label.FontSize = labelsize;
c1.Label.Interpreter = 'latex';
c1.Label.String = '$n_d$';
caxis([10^-4 1])
set(gca,'ColorScale','log')
set(gca,'Layer','bottom')

% Loop through timesteps
for ns = 1:nf:NS+1
    
    set(scpt,'XData',xd(ns,:));
    set(scpt,'SizeData',scalr*rd(ns,:).^2);
    set(scpt,'CData',nd(ns,:));
    title(['$t = \;$',num2str((ns-1)*dt,'%.2f')]);
    
    drawnow
    pause(0.05)
    
    if sswitch == 1
        hgexport(gcf,[fname,'/',fname,num2str((ns-1)/nf,'%03.f'),'.',imgtype],hgexport('factorystyle'),'Format',imgtype);
    end

end

% ----------------------------------------------------------

close