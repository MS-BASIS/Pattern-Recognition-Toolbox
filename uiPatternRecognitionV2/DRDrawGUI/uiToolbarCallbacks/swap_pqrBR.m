function swap_pqrBR(hpqr,eventdata)
%% uidoANOVA sets parameters for ANOVA-type feature selection
%    Input: hMainFig - handle of the main figure of DR toolbox
%% Author: Kirill A. Veselkov, Imperial College London, 2012.
DRdata = guidata(hpqr);
statType = get(hpqr,'TooltipString');
xlims    = get(DRdata.subplot.h(4),'XLim');  
xlims    = [ceil(xlims(1)),floor(xlims(2))];
switch statType 
    case 'p-values'
        DRdata = plotpvaluesBR(DRdata,xlims);
    case 'q-values'
        if ~isempty(DRdata.BR.qvals)
            DRdata = plotqvaluesBR(DRdata,xlims);
        else
            set(hpqr,'State','Off');
            return;
        end
    case 'rank values'
end
set(DRdata.h.pvalues,'State','Off');
set(DRdata.h.qvalues,'State','Off');
set(DRdata.h.rvalues,'State','Off');
set(hpqr,'State','On');
guidata(hpqr,DRdata);
return;