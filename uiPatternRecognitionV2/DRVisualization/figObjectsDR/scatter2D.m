function DRdata = scatter2D(DRdata,PC1,PC2,PC3)
%% scatter2D outputs scatter plot of DR scores 
%   Input: DRdata - data for visualizing the results of
%                     dimension reduction techniques (see variableDescription.txt) 
%          PC1       - the first component chosen for visualization
%          PC2       - the second component chosen for visualization
%% Author: Kirill Veselkov, Imperial College London, 2011

set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(1)); cla;
set(DRdata.subplot.h(1),'YTickMode','Auto');
set(DRdata.subplot.h(1),'YTickLabelMode','Auto');
set(DRdata.subplot.h(1),'XTickMode','Auto');
set(DRdata.subplot.h(1),'XTickLabelMode','Auto');
set(DRdata.subplot.h(1),'YDir','normal');
view(2);

if nargin<2
    PC1 = 1;
end
if nargin<3
    PC2 = 2;
end
if nargin<3
    PC3 = 3;
end

if DRdata.PCplot.stateOM ~= 1
    if DRdata.PCplot.parallelCoord==1
        DRdata = paralCoord(DRdata,PC1,PC2);
    elseif DRdata.PCplot.plot3D==1
        DRdata = scatter3D(DRdata,PC1,PC2,PC3);
        if ~isempty(DRdata.test)
            plotTestSpecrumDR(DRdata,1,0);
        end
        return;
    end
end

nGroups  = length(DRdata.groupIds);
nMTypes  = length(DRdata.PCplot.marker.type);
mMColors = length(DRdata.marker.color);
nMFills  = length(DRdata.PCplot.marker.fill);

if nMTypes<nGroups
    iMType  = [0 1:nGroups-nMTypes];
else
    iMType  = zeros(1,nGroups);
end
if mMColors<nGroups
    iMColor = [0 1:nGroups-nMTypes];
else
    iMColor  = zeros(1,nGroups);
end
if mMColors<nGroups
    iMFill  = [0 1:nGroups-nMFills];
else
    iMFill  = zeros(1,nGroups);
end

if DRdata.PCplot.stateOM == 1
    x = DRdata.outliers.sd.vals;
    y = DRdata.outliers.od.vals;
elseif DRdata.PCplot.CVScores==1
    x = DRdata.cv.T(:,PC1);
    y = DRdata.cv.T(:,PC2);
else
    x = DRdata.scores(:,PC1);
    y = DRdata.scores(:,PC2);
end
[DRdata.PCplot.xlims, DRdata.PCplot.ylims] = getAxisLims(x,y,DRdata);

if DRdata.PCplot.stateOM == 0
    if DRdata.PCScoreGraphics  ~= 0;
        DRdata.h.LoadMapInScores =[];
        %DRdata       = plotGradLoadMapDR(DRdata,xlims,ylims,[PC1,PC2]);
    else
        DRdata.h.LoadMapInScores =[];
    end
else
    DRdata.h.LoadMapInScores =[];
end

if ~isempty(DRdata.sortSelIndcs)
    sampleIDs = DRdata.sampleIDs(DRdata.sortSelIndcs);
else
    sampleIDs = DRdata.sampleIDs;
end
DRdata.PCplot.h.scoresLeg = [];
xlim(DRdata.PCplot.xlims);
ylim(DRdata.PCplot.ylims);
set(DRdata.subplot.h(1),'YTickMode','Manual');
set(DRdata.subplot.h(1),'YTickLabelMode','Manual');
set(DRdata.subplot.h(1),'XTickMode','Manual');
set(DRdata.subplot.h(1),'XTickLabelMode','Manual');

if ~isempty(DRdata.PCplot.spIndcs)
    % only select maximum allowable spectra for visualization
    groups    = DRdata.groups(DRdata.PCplot.spIndcs);
    x         = x(DRdata.PCplot.spIndcs);
    y         = y(DRdata.PCplot.spIndcs);
    sampleIDs = sampleIDs(DRdata.PCplot.spIndcs);
else
    groups    = DRdata.groups;
end
nPoints          = sum(DRdata.PCplot.spIndcs);
DRdata.h.text    = zeros(1,nPoints);
DRdata.h.markers = zeros(1,nPoints);

for iGrp = 1:nGroups
    iGrpIndcs = find(groups == iGrp);
    for iSmpl = iGrpIndcs
        if DRdata.PCplot.marker.fill{iGrp-iMFill(iGrp)}==1
            DRdata.h.markers(iSmpl) = line(x(iSmpl)',...
                y(iSmpl)', ...
                'LineStyle','none', 'Color', [0 0 0], ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerFaceColor',DRdata.marker.color{iGrp-iMColor(iGrp)},...
                'MarkerSize', DRdata.PCplot.marker.size);
        else
            DRdata.h.markers(iSmpl) = line(x(iSmpl)',...
                y(iSmpl)', ...
                'LineStyle','none', 'Color', DRdata.marker.color{iGrp-iMColor(iGrp)}, ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerSize', DRdata.PCplot.marker.size,'LineWidth',DRdata.PCplot.marker.linewidth);
        end
        DRdata.h.text(iSmpl) = text(x(iSmpl)',...
            y(iSmpl)',...
            sampleIDs{iSmpl},'Clipping','on','Color',...
            DRdata.marker.color{iGrp-iMColor(iGrp)},'Interpreter','none',...
            'HorizontalAlignment','Center','Visible','off');
    end
    DRdata.PCplot.h.scoresLeg(iGrp)  = DRdata.h.markers(iSmpl(1));
end
DRdata.PCplot.marker.fontsize = get(DRdata.h.text(1),'FontSize');

%% Labelling x and y axes
if DRdata.PCplot.stateOM == 0
    if isempty(DRdata.PCvar) || DRdata.PCplot.CVScores==1
        selPC     = DRdata.PCplot.selPCs(1);
        xlabelstr = ['Component #',num2str(selPC)];
        selPC     = DRdata.PCplot.selPCs(2);
        ylabelstr = ['Component #',num2str(selPC)];
    else
        selPC     = DRdata.PCplot.selPCs(1);
        xlabelstr = ['Component #',num2str(selPC),' (',num2str(DRdata.PCvar(selPC)),'%)'];
        selPC     = DRdata.PCplot.selPCs(2);
        ylabelstr = ['Component #',num2str(selPC),' (',num2str(DRdata.PCvar(selPC)),'%)'];
    end
else
    xlabelstr = 'Score distance';
    ylabelstr = 'Orthogonal distance';
    line([DRdata.outliers.sd.cutoff,DRdata.outliers.sd.cutoff],DRdata.PCplot.ylims,'Color','r','LineWidth',DRdata.SPplot.linewidth+1);
    line(DRdata.PCplot.xlims,[DRdata.outliers.od.cutoff,DRdata.outliers.od.cutoff],'Color','r','LineWidth',DRdata.SPplot.linewidth+1);
end
if DRdata.PCplot.CVScores==1
    DRdata = updateIncorrectlyClassScoresDR(DRdata);
else
    DRdata.h.misclass          = [];
    DRdata.PCplot.h.mislegend  = [];
    DRdata.PCplot.mislegendids = [];
end

DRdata.PCplot.h.scoresForLeg = [DRdata.PCplot.h.scoresLeg, DRdata.PCplot.h.mislegend];
DRdata.PCplot.legids         = [DRdata.groupIds', DRdata.PCplot.mislegendids];
if get(DRdata.h.legendbutton,'Value')==1
    DRdata  = insertLegendDR(DRdata);
else
    if ishandle(DRdata.PCplot.h.legend)
        delete(DRdata.PCplot.h.legend);
        DRdata.PCplot.h.legend = [];
    end
end

state    = get(DRdata.h.switchSampleIds ,'Value');
if state == 1
    set(DRdata.h.markers,'Visible','off');
    set(DRdata.h.text,'Visible','on');
    if ishandle(DRdata.h.misclass)
        set(DRdata.h.misclass,'Visible','off');
    end
end
   
xlabel(xlabelstr,'FontSize',DRdata.fontsize.axislabel-1);
ylabel(ylabelstr,'FontSize',DRdata.fontsize.axislabel-1);
if ~isempty(DRdata.test)
    plotTestSpecrumDR(DRdata,1,0);
end
set(DRdata.subplot.h(1),'FontSize',DRdata.fontsize.axis);
return;

function [xlims, ylims] = getAxisLims(x,y,DRdata)
xMinVal = min(x);
xMaxVal = max(x);
yMinVal = min(y);
yMaxVal = max(y);
xlims   = [xMinVal xMaxVal];
ylims   = [yMinVal yMaxVal];
xlim(xlims);
ylim(ylims);
h1 = text(x(1)', y(1)',...
            DRdata.sampleIDs{1},'Clipping','on');
LblPos    = get(h1,'Extent'); 
LblWidth  = LblPos(3);
LblHeight = LblPos(4);
xlims(1)  = xlims(1) - LblWidth;
xlims(2)  = xlims(2) + LblWidth;
ylims(1)  = ylims(1) - LblHeight;
ylims(2)  = ylims(2) + LblHeight;
delete(h1);
return;