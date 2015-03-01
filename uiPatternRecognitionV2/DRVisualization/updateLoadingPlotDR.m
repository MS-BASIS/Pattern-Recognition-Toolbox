function DRdata = updateLoadingPlotDR(DRdata,xlims)

if length(DRdata.subplot.h)<5
    return;
end

if nargin<2
    deleteColorbarDR(DRdata.subplot.h(5));
    indcs = find(ishandle(DRdata.subplot.h(5:end)));
    if ~isempty(indcs)
        delete(DRdata.subplot.h(5:end));
    end
    DRdata.subplot.h(5:end) = [];
    DRdata = plotLoadingsOrVrbVarDR(DRdata,get(DRdata.h.swapBetweenLVtoVV,'Value'));
else
    deleteColorbarDR(DRdata.subplot.h(5));
    indcs = find(ishandle(DRdata.subplot.h(5:end)));
    if ~isempty(indcs)
        delete(DRdata.subplot.h(5:end));
    end
    DRdata.subplot.h(5:end) = [];
    DRdata = plotLoadingsOrVrbVarDR(DRdata,get(DRdata.h.swapBetweenLVtoVV,'Value'));
    %set(DRdata.subplot.h(5:end),'XLim',xlims);
end
return;