function output = uigetOutlierMapDR(DRdata,alpha,cutoff)
% The function calculates the threshold values for the outlier detection in
% PCA analysis adapted from the LIMMA package

% Author: Kirill Veselkov, Imperial College London 2009

% DRdata.scores    - scores
% DRdata.loadings  - loadings
% input.L            - eigenvalues
% DRdata.X         - original data
% DRdata.meanX     - robust center

set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(1)); cla;
DRdata   = guidata(hFig);
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

xlims = [min(output.sd(indcs)) max(output.sd(indcs))] + 0.05*([-min(output.sd(indcs)) max(output.sd(indcs))]);
ylims = [min(output.od(indcs)) max(output.od(indcs))] + 0.05*([-min(output.od(indcs)) max(output.od(indcs))]);
plot(xlims,[output.cutoff.od output.cutoff.od],'-r','LineWidth',2);
hold on
plot([output.cutoff.sd output.cutoff.sd],ylims,'-r','LineWidth',2);
xlim(xlims);
ylim(ylims);

for iGrp = 1:nGroups
    iGrpIndcs = find(DRdata.groups == iGrp);
    for iSmpl = iGrpIndcs
        if DRdata.PCplot.marker.fill{iGrp-iMFill(iGrp)}==1
            DRdata.h.markers(iSmpl) = line(output.sd(iSmpl,PC1)',...
                output.od(iSmpl,PC2)', ...
                'LineStyle','none', 'Color', [0 0 0], ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerFaceColor',DRdata.marker.color{iGrp-iMColor(iGrp)},...
                'MarkerSize', DRdata.PCplot.marker.size);
        else
            DRdata.h.markers(iSmpl) = line(output.sd(iSmpl,PC1)',...
                output.od(iSmpl,PC2)', ...
                'LineStyle','none', 'Color', DRdata.marker.color{iGrp-iMColor(iGrp)}, ...
                'Marker', DRdata.PCplot.marker.type{iGrp-iMType(iGrp)}, ...
                'MarkerSize', DRdata.PCplot.marker.size,'LineWidth',DRdata.PCplot.marker.linewidth);
        end
        DRdata.h.text(iSmpl) = text(output.sd(iSmpl,PC1)',...
            output.od(iSmpl,PC2)',...
            DRdata.sampleIDs{iSmpl},'Clipping','on','Color',...
            DRdata.marker.color{iGrp-iMColor(iGrp)},...
            'HorizontalAlignment','Center','Visible','off');
    end
end

%% Labelling x and y axes
xlabel(sprintf('Score distance (%s PCs)',num2str(DRdata.selDRparam{1})),'FontSize',...
    DRdata.fontsize.axislabel-2);
xlabel('Orthogonal distance','FontSize',DRdata.fontsize.axislabel-2);

return;