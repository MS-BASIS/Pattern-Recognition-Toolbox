function DRdata = scatter3D(DRdata,PC1,PC2,PC3)
%% scatter2D outputs scatter plot of DR scores 
%   Input: DRdata - data for visualizing the results of
%                     dimension reduction techniques (see variableDescription.txt) 
%          PC1       - the first component chosen for visualization
%          PC2       - the second component chosen for visualization
%% Author: Kirill Veselkov, Imperial College London, 2011


if nargin<2; PC1 = 1; end
if nargin<3; PC2 = 2; end
if nargin<4; PC2 = 3; end

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

if DRdata.PCplot.CVScores==1
    if size(DRdata.cv.T,2) < max([PC1,PC2,PC3])
        DRdata.PCplot.plot3D = 0;
        return;
    end
    x = DRdata.cv.T(:,PC1);
    y = DRdata.cv.T(:,PC2);
    z = DRdata.cv.T(:,PC3);
else
    if size(DRdata.scores,2) < max([PC1,PC2,PC3])
        DRdata.PCplot.plot3D = 0;
        return;
    end
    x = DRdata.scores(:,PC1);
    y = DRdata.scores(:,PC2);
    z = DRdata.scores(:,PC3);
end
[DRdata.PCplot.xlims, DRdata.PCplot.ylims,DRdata.PCplot.zlims] = getAxisLims(x,y,z,DRdata);

if ~isempty(DRdata.sortSelIndcs)
    sampleIDs = DRdata.sampleIDs(DRdata.sortSelIndcs);
else
    sampleIDs = DRdata.sampleIDs;
end
DRdata.PCplot.h.scoresLeg = [];
DRdata.h.text             = ones(1,DRdata.nSmpls);
xlim(DRdata.PCplot.xlims);
ylim(DRdata.PCplot.ylims);
zlim(DRdata.PCplot.zlims);
set(DRdata.subplot.h(1),'YTickMode','Manual');
set(DRdata.subplot.h(1),'YTickLabelMode','Manual');
set(DRdata.subplot.h(1),'XTickMode','Manual');
set(DRdata.subplot.h(1),'XTickLabelMode','Manual');
for iGrp = 1:nGroups
    iGrpIndcs = find(DRdata.groups == iGrp);
    for iSmpl = iGrpIndcs
        if DRdata.PCplot.marker.fill{iGrp-iMFill(iGrp)}==1
            DRdata.h.markers(iSmpl) = line(x(iSmpl)',...
                y(iSmpl)', z(iSmpl)',...
                'LineStyle','none', 'Color', [0 0 0], ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerFaceColor',DRdata.marker.color{iGrp-iMColor(iGrp)},...
                'MarkerSize', DRdata.PCplot.marker.size);
        else
            DRdata.h.markers(iSmpl) = line(x(iSmpl)',...
                y(iSmpl)', z(iSmpl)',...
                'LineStyle','none', 'Color', DRdata.marker.color{iGrp-iMColor(iGrp)}, ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerSize', DRdata.PCplot.marker.size,'LineWidth',DRdata.PCplot.marker.linewidth);
        end
        DRdata.h.text(iSmpl) = text(x(iSmpl)',...
            y(iSmpl)',z(iSmpl)',...
            sampleIDs{iSmpl},'Clipping','on','Color',...
            DRdata.marker.color{iGrp-iMColor(iGrp)},'Interpreter','none',...
            'HorizontalAlignment','Center','Visible','off');
    end
    DRdata.PCplot.h.scoresLeg(iGrp)  = DRdata.h.markers(iSmpl(1));
end
DRdata.PCplot.marker.fontsize = get(DRdata.h.text(1),'FontSize');

%% Labelling x and y axes
if isempty(DRdata.PCvar) || DRdata.PCplot.CVScores==1
    selPC     = DRdata.PCplot.selPCs(1);
    xlabelstr = ['Component #',num2str(selPC)];
    selPC     = DRdata.PCplot.selPCs(2);
    ylabelstr = ['Component #',num2str(selPC)];
    selPC     = DRdata.PCplot.selPCs(3);
    zlabelstr = ['Component #',num2str(selPC)];
else
    selPC     = DRdata.PCplot.selPCs(1);
    xlabelstr = ['Component #',num2str(selPC),' (',num2str(DRdata.PCvar(selPC)),'%)'];
    selPC     = DRdata.PCplot.selPCs(2);
    ylabelstr = ['Component #',num2str(selPC),' (',num2str(DRdata.PCvar(selPC)),'%)'];
    selPC     = DRdata.PCplot.selPCs(3);
    zlabelstr = ['Component #',num2str(selPC),' (',num2str(DRdata.PCvar(selPC)),'%)'];
end
%if DRdata.PCplot.CVScores==1
%    DRdata = updateIncorrectlyClassScoresDR(DRdata);
%else
DRdata.h.misclass          = [];
DRdata.PCplot.h.mislegend  = [];
DRdata.PCplot.mislegendids = [];
%end

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
   
xlabel(xlabelstr,'FontSize',DRdata.fontsize.axislabel-3);
ylabel(ylabelstr,'FontSize',DRdata.fontsize.axislabel-3);
zlabel(zlabelstr,'FontSize',DRdata.fontsize.axislabel-3);
set(DRdata.subplot.h(1),'FontSize',DRdata.fontsize.axis-2);
view(3);
return;

function [xlims, ylims,zlims] = getAxisLims(x,y,z,DRdata)
xMinVal = min(x);
xMaxVal = max(x);
yMinVal = min(y);
yMaxVal = max(y);
zMinVal = min(z);
zMaxVal = max(z);

xlims   = [xMinVal xMaxVal];
ylims   = [yMinVal yMaxVal];
zlims   = [zMinVal zMaxVal];
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