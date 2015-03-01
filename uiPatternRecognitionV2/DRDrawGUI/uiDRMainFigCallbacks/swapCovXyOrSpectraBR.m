function swapCovXyOrSpectraBR(hMainFig,ignore)

DRdata = guidata(hMainFig);
xlims  = get(DRdata.subplot.h(2),'xlim');
if strcmp(get(DRdata.h.swapCovXyOrSp,'State'),'on')
    set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(2)); cla;
    if ishandle(DRdata.h.CBSubP1)
        cbfreeze(DRdata.h.CBSubP1,'del')
    end    
    DRdata = plotSpectraRedDR(DRdata,xlims);
    set(DRdata.h.swapCovXyOrSp,'TooltipString','Show statistically significant feautres');
else
    DRdata = updatePQRplot(DRdata,xlims);
    set(DRdata.h.swapCovXyOrSp,'TooltipString','Show spectral profiles')
end
guidata(hMainFig,DRdata)
return;