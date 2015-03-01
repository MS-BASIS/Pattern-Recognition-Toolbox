function swapBetweenLVorVV(hButton,eventdata)
%% swapSpOrRecSpDR swaps between loadings or variable variances explained
%%                 by PCs
%   hMainFigDR     - a handle of the main figure    
%% Author: Kirill A. Veselkov, Imperial College 2011

DRdata = guidata(hButton);
state  = get(hButton,'Value');
deleteColorbarDR(DRdata.subplot.h(5));
delete(DRdata.subplot.h(5:end));
DRdata.subplot.h(5:end) = [];
if state==1
    set(hButton,'TooltipString',sprintf('Show loadings values'));
    DRdata = plotLoadingsOrVrbVarDR(DRdata,1);
    set(DRdata.h.LoadMapInScores,'Visible','off');    
else
    set(hButton,'TooltipString',sprintf('Show variable variances \n explained by components '));
    DRdata = plotLoadingsOrVrbVarDR(DRdata,0);
    if get(DRdata.h.swapBetweenImageLVorContLV,'Value')==0
        set(DRdata.h.LoadMapInScores,'Visible','on');
    end
end
guidata(hButton,DRdata);