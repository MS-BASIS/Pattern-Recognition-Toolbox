function uidoplotAnovaFeatSelecDiagnostics(DRdata)
%% CV Anova Feature Selection Dianostics Plot
% To be used within dimension reduction toolbox cross validation with anova
% feature selection.
% Author: Ottmar Golf & Kirill Veselkov, Imperial College London, 2014

% Get the data from DRdata
feat  = DRdata.cv.anovaFeatSel.features;
pvals = median(DRdata.cv.anovaFeatSel.pVals);
% Scale average mass spectrum to base peak
%Sp    = bsxfun(@rdivide,mean(DRdata.Sp,1),max(mean(DRdata.Sp,1),[],2));

% Check if significant peaks were detected
sumFeat = sum(feat,1)==size(DRdata.cv.anovaFeatSel.features,1);
if max(sumFeat)==0;
    msgbox('No significant features detected. Try higher p-Value threshold?');
elseif max(sumFeat)~=0;
    DRdata.BR.pvalues = pvals;
    DRdata.BR.pThr    = max(pvals(sumFeat));
    DRdata.BR.CovXy   = DRdata.Sp'*getDummyY(DRdata.groupdata,'yes');
    nGrps             = length(unique(DRdata.groupdata));
    if nGrps>2
        DRdata.BR.CovXy = mean(abs(DRdata.BR.CovXy),2);
    else
        DRdata.BR.CovXy =  DRdata.BR.CovXy(:,1);
    end
    hFig  = plotCVSelectedFeatures(DRdata);
    hZoom = zoom(hFig);
    set(hZoom,'ActionPostCallback',{@zoomcallbackSTOCSY,DRdata.ppm,DRdata.BR.CovXy,...
        DRdata.SPplot.xreverse}); % set callback for zoom events
    set(hZoom,'Enable','on');
    updateFigTitleAndIconMS(hFig,'Feature Selection Diagnostics','MSINavigatorLogo.png')
    guidata(hFig,DRdata.ppm);
end

function hFig = plotCVSelectedFeatures(DRdata)

hFig = figure('units','normalized','menu','none','outerposition',[0 0 1 1],...
    'Color',[1 1 1]);

[ignore,DRdata.h.CBSubP1,DRdata.CB.YTick,DRdata.CB.YTickLbls] = ...
    plotPValues(1:DRdata.nVrbls, DRdata.BR.CovXy,DRdata.BR.pvalues,...
    1-DRdata.BR.pThr*1.4,1,[],DRdata.peakPickedData);

xlims    = [1 DRdata.nVrbls];
maxCovXy = max(DRdata.BR.CovXy(xlims(1):xlims(2)));
minCovXy = min(DRdata.BR.CovXy(xlims(1):xlims(2)));
range    = maxCovXy - minCovXy;

ylim([minCovXy-0.1*range maxCovXy+0.1*range]);
xlim(xlims);
[xTickIndcs,xTickLbls]  = getXTickMarks(gca,DRdata.ppm);
set(gca,'XTick',xTickIndcs);
set(gca,'XTickLabel',xTickLbls);
if DRdata.SPplot.xreverse ==1
    set(gca,'Xdir','reverse');
else
    set(gca,'Xdir','normal');
end
if ~ischar(DRdata.SPplot.xlabel)
    xlabel('{\delta}^{ 1}H ppm','FontSize',DRdata.fontsize.axislabel);
else
    xlabel(DRdata.SPplot.xlabel,'FontSize',DRdata.fontsize.axislabel);
end

set(gca,'YTickLabel',[]);
ylabel('Covaraince(X,y)','FontSize',DRdata.fontsize.axislabel);
set(gca,'FontSize',DRdata.fontsize.axis);

%% Clean up the colorbar YTick indices and labels
if ~isempty(DRdata.BR.pThr)
    index = find(DRdata.CB.YTick == 1-DRdata.BR.pThr);
    if ~isempty(index)
        DRdata.CB.YTick(index)= [];
        DRdata.CB.YTickLbls(index) = [];
    end
    [ignore,index]             = min(abs(DRdata.CB.YTick - (1-DRdata.BR.pThr))); %#ok<ASGLU>
    if index==1
        YTicks                 = DRdata.CB.YTick;
        YTickLabels            = DRdata.CB.YTickLbls;
        %      YTickLabels{1}         = sprintf('pFDR=%0.5f',DRdata.BR.pFDRThr);
    else
        DRdata.CB.YTick(index)     = [];
        DRdata.CB.YTickLbls(index) = [];
        YTicks                     = [DRdata.CB.YTick, 1-DRdata.BR.pThr];
        YTickLabels                = {DRdata.CB.YTickLbls{:}, sprintf('pThr=%0.5f',DRdata.BR.pThr)};
    end
    [YTicks,sortedIndcs]       = sort(YTicks);
    YTickLabels                = YTickLabels(sortedIndcs);
    set(DRdata.h.CBSubP1,'YTick',YTicks);
    set(DRdata.h.CBSubP1,'YTickLabel',YTickLabels,'FontSize',DRdata.fontsize.axis-2);
end
%ylim([min(DRdata.BR.CovXy(xlims(1):xlims(2))),max(DRdata.BR.CovXy(xlims(1):xlims(2)))]);
set(get(DRdata.h.CBSubP1,'ylabel'),'String', sprintf('p-values'),'FontSize',DRdata.fontsize.axislabel);