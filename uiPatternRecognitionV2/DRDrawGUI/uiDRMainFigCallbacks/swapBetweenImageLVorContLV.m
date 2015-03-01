function swapBetweenImageLVorContLV(hButton,ignore)

DRdata = guidata(hButton);
state    = get(hButton,'Value');
deleteColorbarDR(DRdata.subplot.h(5));
delete(DRdata.subplot.h(5:end));
DRdata.subplot.h(5:end) = [];

if state==1
    set(hButton,'TooltipString',sprintf('Image plot'));
    set(DRdata.h.LoadMapInScores,'Visible','off');
else
    set(hButton,'TooltipString',sprintf('Classic plot'));
    if get(DRdata.h.swapBetweenLVtoVV,'Value')==0
        set(DRdata.h.LoadMapInScores,'Visible','on');
    end
end
DRdata = plotLoadingsOrVrbVarDR(DRdata,get(DRdata.h.swapBetweenLVtoVV,'Value'));
guidata(hButton,DRdata);
return;