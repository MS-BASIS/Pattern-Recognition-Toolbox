function DRdata = plotpvaluesBR(DRdata,xlims)
%% plotpvaluePWCA gives a surface plot of covariance values of the data matrix
%% X with class labels y colour-coded by p-values
%% Author: Kirill A. Veselkov, Imperial College London

%% re-define the axis limits
set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(2)); cla;
nVrbls   = length(DRdata.ppm);
if nargin<2
    xlims(1) = 1;
    xlims(2) = nVrbls;
else
    if xlims(1)<1
        xlims(1) = 1;
    end
    if xlims(2)>nVrbls
        xlims(2) = nVrbls;
    end
end
if ishandle(DRdata.h.CBSubP1)
    deleteColorbarDR(DRdata.h.CBSubP1);
end
if isnan(DRdata.BR.pThr)
    DRdata.BR.pThr = DRdata.BR.pFDRThr;
end

%% Visualise the surface plot
if size(DRdata.BR.CovXy,1)>size(DRdata.BR.CovXy,2)
    DRdata.BR.CovXy = DRdata.BR.CovXy';
end
[ignore,DRdata.h.CBSubP1,DRdata.CB.YTick,DRdata.CB.YTickLbls] = ...
    plotPValues(1:DRdata.nVrbls, DRdata.BR.CovXy,DRdata.BR.pvalues,...
    1-DRdata.BR.pThr*1.4,1,[],DRdata.peakPickedData); 

set(DRdata.subplot.h(1),'XLim',xlims);
maxCovXy = max(DRdata.BR.CovXy(xlims(1):xlims(2)));
minCovXy = min(DRdata.BR.CovXy(xlims(1):xlims(2)));
range    = maxCovXy - minCovXy;

ylim([minCovXy-0.1*range maxCovXy+0.1*range]);
xlim(xlims);
[xTickIndcs,xTickLbls]  = getXTickMarks(DRdata.subplot.h(2),DRdata.ppm);
set(gca,'XTick',xTickIndcs);
set(gca,'XTickLabel',xTickLbls);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(2),'Xdir','reverse');
else
    set(DRdata.subplot.h(2),'Xdir','normal');
end
set(gca,'YTickLabel',[]);
ylabel('Covaraince(X,y)','FontSize',DRdata.fontsize.axislabel);
set(gca,'FontSize',DRdata.fontsize.axis);

title(['FDR = ',num2str(DRdata.BR.alpha),', ', (DRdata.BR.method)],...
    'FontSize',DRdata.fontsize.title);
ylabel('Covaraince(X,y)','FontSize',DRdata.fontsize.axislabel);

%% Clean up the colorbar YTick indices and labels
if ~isempty(DRdata.BR.pFDRThr) 
    index = find(DRdata.CB.YTick == 1-DRdata.BR.pFDRThr);
    if ~isempty(index)
        DRdata.CB.YTick(index)= [];
        DRdata.CB.YTickLbls(index) = [];
    end
    [ignore,index]             = min(abs(DRdata.CB.YTick - (1-DRdata.BR.pFDRThr))); %#ok<ASGLU>
    if index==1
        YTicks                 = DRdata.CB.YTick;
        YTickLabels            = DRdata.CB.YTickLbls;
        YTickLabels{1}         = sprintf('pFDR=%0.5f',DRdata.BR.pFDRThr);
    else
        DRdata.CB.YTick(index)     = [];
        DRdata.CB.YTickLbls(index) = [];
        YTicks                     = [DRdata.CB.YTick, 1-DRdata.BR.pFDRThr];
        YTickLabels                = {DRdata.CB.YTickLbls{:}, sprintf('pFDR=%0.5f',DRdata.BR.pFDRThr)};
    end
    [YTicks,sortedIndcs]       = sort(YTicks);
    YTickLabels                = YTickLabels(sortedIndcs);
    set(DRdata.h.CBSubP1,'YTick',YTicks);
    set(DRdata.h.CBSubP1,'YTickLabel',YTickLabels,'FontSize',DRdata.fontsize.axis-2);
end
%ylim([min(DRdata.BR.CovXy(xlims(1):xlims(2))),max(DRdata.BR.CovXy(xlims(1):xlims(2)))]);
set(get(DRdata.h.CBSubP1,'ylabel'),'String', sprintf('p-values'),'FontSize',DRdata.fontsize.axislabel);

%% adjust spectral positions
adjustPlotPtns(DRdata.subplot.h(2),DRdata.subplot.h(4));

%% adjust colorbar positions
posCBSubP1 = get(DRdata.h.CBSubP1,'Position');
posCBSubP2 = get(DRdata.h.CBSubP2,'Position');
posCBSubP1(1) = posCBSubP2(1);
set(DRdata.h.CBSubP1,'Position',posCBSubP1);
return;