function output = getOutlierMap(hMainFigDR,ignore)
%% The function calculates the threshold values for the outlier detection in
%% PCA analysis adapted from the LIMMA package

%% Author: Kirill Veselkov, Imperial College London 2009


DRdata = guidata(hMainFigDR);
[alpha,cutoff] = getVarArgin();
set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(1)); cla;
output   = getOutliersDR(DRdata,alpha,cutoff);
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
    iMColor = zeros(1,nGroups);
end
if mMColors<nGroups
    iMFill  = [0 1:nGroups-nMFills];
else
    iMFill  = zeros(1,nGroups);
end

for iGrp = 1:nGroups
    iGrpIndcs = find(DRdata.groups == iGrp);
    for iSmpl = iGrpIndcs
        if DRdata.PCplot.marker.fill{iGrp-iMFill(iGrp)}==1
            DRdata.h.markers(iSmpl) = line(output.sd(iSmpl)',...
                output.od(iSmpl)', ...
                'LineStyle','none', 'Color', [0 0 0], ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerFaceColor',DRdata.marker.color{iGrp-iMColor(iGrp)},...
                'MarkerSize', DRdata.PCplot.marker.size);
        else
            DRdata.h.markers(iSmpl) = line(output.sd(iSmpl)',...
                output.od(iSmpl)', ...
                'LineStyle','none', 'Color', DRdata.marker.color{iGrp-iMColor(iGrp)}, ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerSize', DRdata.PCplot.marker.size,'LineWidth',DRdata.PCplot.marker.linewidth);
        end
        DRdata.h.text(iSmpl) = text(output.sd(iSmpl)',...
            output.od(iSmpl)',...
            DRdata.sampleIDs{iSmpl},'Clipping','on','Color',...
            DRdata.marker.color{iGrp-iMColor(iGrp)},...
            'HorizontalAlignment','Center','Visible','off');
    end
end

%% Labelling x and y axes
xlabel(['Score disctance #' num2str(DRdata.selDRparam.values(1))],'FontSize',...
    DRdata.fontsize.axislabel-2);
xlabel('Orthogonal distance','FontSize',DRdata.fontsize.axislabel-2);
sprintf('Score distance (%s PCs)',num2str(DRdata.selDRparam.values(1)))
return;


function [alpha,cutoff] = getVarArgin()
%% get default input parameters...
selparam.names{1}  = 'Apha';
selparam.values{1} = '0.9';
selparam.names{2}  = 'Cuttoff';
selparam.values{2} = '0.975';
answer             = inputdlg(selparam.names,'Outlier Detection',1,selparam.values);
alpha              = str2double(answer{1});
cutoff             = str2double(answer{2});
return;