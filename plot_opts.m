% plot_opts

%   *** Master Figure Options ***
figvis = 'off';
axissize = 20;
titlesize = 24;
labelsize = 24;
legsize = 18; %14;   % 24
linewidth = 1;
MarkerSize = 8;
imgtype = 'png';

% Colours and line data
colours = {'k','b','r','g','c','m','y'};
linestyles = {'-','--',':','-.'};
markers = {'o','^','s','x','d','*','+','v','<','>','p','h','.','_','|'};

% Figure sizing
figwidth = 1280;
aspectratio = (1 + sqrt(5))/2;  % Golden ratio
%aspectratio = sqrt(2);   % A4
figheight = figwidth/aspectratio;
screensize = get(0,'ScreenSize');
figleft = screensize(3)/2 - figwidth/2;
figbottom = screensize(4)/2 - figheight/2;
figpos = [figleft figbottom figwidth figheight];

% Plotting styles for data and models
Nlines = 16;
datastyle = cell(1,Nlines);
modelstyle = cell(1,Nlines);

for cno = 1:Nlines
    datastyle{cno} = strjoin([colours(mod(cno-1,size(colours,2))+1),markers(mod(cno-1,size(markers,2))+1)],'');
    modelstyle{cno} = strjoin([colours(mod(cno-1,size(colours,2))+1),linestyles(mod(cno-1,size(linestyles,2))+1)],'');
end

% Set default formatting options
set(0,'defaultLineLineWidth',linewidth)
set(0,'defaultLineMarkerSize',MarkerSize)
set(0,'DefaultAxesFontsize',axissize)
set(0,'DefaultLegendFontSizeMode','manual')
set(0,'DefaultLegendFontSize',legsize)

set(0,'DefaultAxesBox','on')
set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultLegendInterpreterMode','manual')
set(0,'DefaultLegendInterpreter','latex')
set(0,'DefaultAxesTickLabelInterpreter','latex')
set(0,'DefaultAxesXMinorTick','on')
set(0,'DefaultAxesYMinorTick','on')
set(0,'DefaultAxesXLimMode','manual')
set(0,'DefaultAxesYLimMode','manual')
set(0,'DefaultAxesXLim',[-Inf Inf])
set(0,'DefaultAxesYLim',[-Inf Inf])

%set(0,'defaultFigureVisible',figvis)
%set(0,'defaultFigurePosition',figpos)
%set(0,'DefaultAxesTitleFontsizeMultiplier',titlesize/axissize)
%set(0,'DefaultAxesLabelFontsizeMultiplier',labelsize/axissize)