function uiGetLegend(hMainFig,eventdata)
%% uiGetLenend inserts or deletes class labels
%    Input: hMainFig - handle of the main figure of DR toolbox
%% Author: Kirill A. Veselkov, Imperial College London, 2011.

DRdata = guidata(hMainFig);
if get(hMainFig,'Value')==1
    DRdata  = insertLegendDR(DRdata);
else
    delete(DRdata.PCplot.h.legend);
    DRdata.PCplot.h.legend = [];
end  
guidata(hMainFig,DRdata);