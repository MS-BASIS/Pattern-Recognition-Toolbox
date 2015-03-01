function DRdata = paralCoord(DRdata,PC1,PC2)
%% scatter2D outputs scatter plot of DR scores 
%   Input: DRdata - data for visualizing the results of
%                     dimension reduction techniques (see variableDescription.txt) 
%          PC1       - the first component chosen for visualization
%          PC2       - the second component chosen for visualization
%% Author: Kirill Veselkov, Imperial College London, 2011

set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(1)); cla;

if nargin<2
    PC1 = 1;
end
if nargin<3
    PC2 = 5;
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

PCs    = PC1:PC2;
flucts = rand(length(PCs),DRdata.nSmpls)./4 - 0.125;
y      = PCs(ones(1,DRdata.nSmpls),:)+ flucts';

if DRdata.PCplot.CVScores==1
    x = DRdata.cv.T(:,PC1:PC2);
else
    x = DRdata.scores(:,PC1:PC2);
end
[DRdata.PCplot.xlims, DRdata.PCplot.ylims] = getAxisLims(x(:),y(:),DRdata);
if ~isempty(DRdata.sortSelIndcs)
    sampleIDs = DRdata.sampleIDs(DRdata.sortSelIndcs);
else
    sampleIDs = DRdata.sampleIDs;
end
DRdata.PCplot.h.scoresLeg = [];
DRdata.h.text             = [];

xlim(DRdata.PCplot.xlims);
ylim(DRdata.PCplot.ylims);
set(DRdata.subplot.h(1),'YTickMode','Manual');
set(DRdata.subplot.h(1),'YTickLabelMode','Manual');
set(DRdata.subplot.h(1),'XTickMode','Manual');
set(DRdata.subplot.h(1),'XTickLabelMode','Manual');
for iGrp = 1:nGroups
    iGrpIndcs = find(DRdata.groups == iGrp);
    for iSmpl = iGrpIndcs
        if DRdata.PCplot.marker.fill{iGrp-iMFill(iGrp)}==1
            DRdata.h.markers(iSmpl) = line(x(iSmpl,:)',...
                y(iSmpl,:)', ...
                'LineStyle','none', 'Color', [0 0 0], ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerFaceColor',DRdata.marker.color{iGrp-iMColor(iGrp)},...
                'MarkerSize', DRdata.PCplot.marker.size);
        else
            DRdata.h.markers(iSmpl) = line(x(iSmpl,:)',...
                y(iSmpl,:)', ...
                'LineStyle','none', 'Color', DRdata.marker.color{iGrp-iMColor(iGrp)}, ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerSize', DRdata.PCplot.marker.size,'LineWidth',DRdata.PCplot.marker.linewidth);
        end
        DRdata.h.text(:,iSmpl) = text(x(iSmpl,:)',...
            y(iSmpl,:)',...
            sampleIDs(iSmpl),'Clipping','on','Color',...
            DRdata.marker.color{iGrp-iMColor(iGrp)},'Interpreter','none',...
            'HorizontalAlignment','Center','Visible','off');
    end
    DRdata.PCplot.h.scoresLeg(iGrp)  = DRdata.h.markers(iSmpl(1));
end
DRdata.PCplot.marker.fontsize = get(DRdata.h.text(1),'FontSize');

%% Labelling x and y axes
xlabelstr = 'Score values';
ylabelstr = 'Component #';

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
   
xlabel(xlabelstr,'FontSize',DRdata.fontsize.axislabel-2);
ylabel(ylabelstr,'FontSize',DRdata.fontsize.axislabel-2);
set(DRdata.subplot.h(1),'YDir','reverse');
set(gca,'YTick',PCs);
set(gca,'YTickLabel',PCs);
xlim(DRdata.PCplot.xlims);
ylim(DRdata.PCplot.ylims);
DRdata.PCplot.parXY.x = x(:);
DRdata.PCplot.parXY.y = y(:);
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