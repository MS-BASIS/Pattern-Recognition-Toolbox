function uiRemoveOutliers(hMainFigure,eventdata)

DRdata   = guidata(hMainFigure);
if isempty(DRdata.selsamples)
    return;
elseif length(DRdata.selsamples) > DRdata.nSmpls-4
    display('Warning: Need more than five samples for performing dimensionality reduction');
    return;
end

if ~isempty(DRdata.sortSelIndcs)
    DRdata.X         = DRdata.X(DRdata.sortSelIndcs,:);
    DRdata.groupdata = DRdata.groupdata(DRdata.sortSelIndcs);
    DRdata.sampleIDs = DRdata.sampleIDs(DRdata.sortSelIndcs);
end

DRdata.X(DRdata.selsamples,:)        = [];
DRdata.Sp(DRdata.selsamples,:)       = [];
DRdata.groupdata(DRdata.selsamples)  = [];
DRdata.sampleIDs(DRdata.selsamples)  = [];
DRdata.replicates(DRdata.selsamples) = [];
groupIndcs                           = unique(DRdata.groupdata);
DRdata.PCplot.marker.fill            = DRdata.PCplot.marker.fill(groupIndcs);
DRdata.marker.color                  = DRdata.marker.color(groupIndcs);
DRdata.groupIds                      = DRdata.groupIds(groupIndcs);
DRdata.PCplot.marker.type            = DRdata.PCplot.marker.type(groupIndcs);

uiDimensionReduction(DRdata.ppm,DRdata.Sp,DRdata.X,DRdata.groupdata,'markerType',DRdata.PCplot.marker.type,...
    'markerFill',DRdata.PCplot.marker.fill,'colors',DRdata.marker.color,...
    'sampleIDs',DRdata.sampleIDs,'replicates', DRdata.replicates,'groupIDs',DRdata.groupIds,'nmr',DRdata.NMR);

return;