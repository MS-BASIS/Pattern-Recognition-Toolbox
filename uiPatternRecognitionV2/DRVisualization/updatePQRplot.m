function DRdata = updatePQRplot(DRdata,xlims)

xlims = floor(xlims);
if ishandle(DRdata.h.CBSubP1)
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
else
    if strcmp(get(DRdata.h.pvalues,'state'),'on')
        DRdata = plotpvaluesBR(DRdata,xlims);
    elseif strcmp(get(DRdata.h.qvalues,'state'),'on')
        DRdata = plotqvaluesBR(DRdata,xlims);
    elseif strcmp(get(DRdata.h.rvalues,'state'),'on')
        DRdata = plotpvaluesBR(DRdata,xlims);
    end
end
return;
