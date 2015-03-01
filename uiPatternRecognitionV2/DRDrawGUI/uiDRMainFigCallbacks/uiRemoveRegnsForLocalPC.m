function uiRemoveRegnsForLocalPC(hMainFigure,eventdata)

DRdata = guidata(hMainFigure);
if isempty(DRdata.h.PCregions)
    return;
end
%% delete previousy selected region
delete(DRdata.h.PCregions(end));
DRdata.h.PCregions(end)            = [];
DRdata.SPplot.regions.bndrs(:,end) = [];
guidata(hMainFigure,DRdata);

    