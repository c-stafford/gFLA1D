% plot_opts

%   *** Master Figure Options ***
figvis = 'on';
labelsize = 18;
legsize = 18;
linewidth = 1;
markersize = 8;
imgtype = 'png';

% Colours and line styles
colours = {'k','b','r','g','c','m','y'};
linestyles = {'-','--',':','-.'};
markers = {'o','^','s','x','d','*','+','v','<','>','p','h','.','_','|'};

% Plotting styles for data and models
Nlines = 16;
datastyle = cell(1,Nlines);
modelstyle = cell(1,Nlines);

for cno = 1:Nlines
    datastyle{cno} = strjoin([colours(mod(cno-1,size(colours,2))+1),markers(mod(cno-1,size(markers,2))+1)],'');
    modelstyle{cno} = strjoin([colours(mod(cno-1,size(colours,2))+1),linestyles(mod(cno-1,size(linestyles,2))+1)],'');
end

% Set default formatting options
set(0,'defaultFigureVisible',figvis)
set(0,'defaultLineLineWidth',linewidth)
set(0,'defaultLineMarkerSize',markersize)
set(0,'defaultAxesFontsize',labelsize)
set(0,'defaultLegendFontSizeMode','manual')
set(0,'defaultLegendFontSize',legsize)
set(0,'defaultAxesBox','on')
set(0,'defaultTextInterpreter','latex')
set(0,'defaultLegendInterpreterMode','manual')
set(0,'defaultLegendInterpreter','latex')
set(0,'defaultAxesTickLabelInterpreter','latex')
set(0,'defaultAxesXMinorTick','on')
set(0,'defaultAxesYMinorTick','on')
set(0,'defaultAxesXLim',[-Inf Inf])
set(0,'defaultAxesYLim',[-Inf Inf])
set(0,'defaultAxesLayer','top')
set(0,'defaultColorbarFontSize',labelsize)
set(0,'defaultColorbarTickLabelInterpreter','latex')
set(0,'defaultAxesColorScale','linear')