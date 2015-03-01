function showLoadingsDR(hMainFigDR,eventdata)
%% showLoadings visualizes loadings plot
%           Input: hMainFigDR - figure handle for dimension reduction toolbox
%% Author: Kirill Veselkov, Imperial College 2011

DRdata = guidata(hMainFigDR);
state  = get(hMainFigDR,'State');
if strcmp(state,'on')
    set(DRdata.subplot.h(2),'YAxisLocation','Left');
    set(DRdata.subplot.h(2),'XAxisLocation','Top');
    SpPos               = get(DRdata.subplot.h(2),'Position'); %get positions of sample profiles
    ImPos               = get(DRdata.subplot.h(4),'Position'); %get positions of metabolic map
    DRdata.LPlot.Pos    = ImPos;
    DRdata.LPlot.Pos(2) = ImPos(2) + ImPos(4);
    DRdata.LPlot.Pos(4) = SpPos(2) - DRdata.LPlot.Pos(2); %get positions of loadings values
    DRdata.LPlot.Pos(4) = DRdata.LPlot.Pos(4)-DRdata.LPlot.Pos(4)./10;
    DRdata.LPlot.Pos(2) = DRdata.LPlot.Pos(2)+DRdata.LPlot.Pos(4)./20;
    posFB               = get(DRdata.h.swapBetweenXorRecXorRes,'Position'); %typical size of funtional button
    posSwapLVtoVV       = posFB;
    posSwapLVtoVV(1)    = posSwapLVtoVV(1)-posFB(3);
    
    DRdata.h.swapBetweenLVtoVV = uicontrol('style', 'togglebutton','CData',...  
        DRdata.icons.Arrow4,'units','normalized','Position',posSwapLVtoVV,...
        'Callback', @swapBetweenLVorVV, 'TooltipString',sprintf('Show variable variances \n explained by components'));
    DRdata.h.swapBetweenImageLVorContLV = uicontrol('style', 'togglebutton','CData',...    
        DRdata.icons.chart,'units','normalized','Position',posFB,...
        'Callback', @swapBetweenImageLVorContLV, 'TooltipString',sprintf('Classic plot'));
    posFB(1)  = posFB(1) - 2*posFB(3);
    set(DRdata.h.swapBetweenXorRecXorRes,'Position',posFB);
    set(DRdata.h.LoadMapInScores,'Visible','on');
    DRdata    = plotLoadingsOrVrbVarDR(DRdata);
else
    set(DRdata.subplot.h(2),'XAxisLocation','Bottom');
    posFB = get(DRdata.h.swapBetweenImageLVorContLV,'Position');
    set(DRdata.h.swapBetweenXorRecXorRes,'Position',posFB);
    delete([DRdata.h.swapBetweenLVtoVV,DRdata.h.swapBetweenImageLVorContLV]);
    deleteColorbarDR(DRdata.subplot.h(5));
    delete(DRdata.subplot.h(5:end));
    DRdata.subplot.h(5:end) = [];
    set(DRdata.h.LoadMapInScores,'Visible','off');
end

guidata(hMainFigDR,DRdata);
return;