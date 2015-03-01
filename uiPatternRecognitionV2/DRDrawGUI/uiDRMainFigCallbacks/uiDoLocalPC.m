function uiDoLocalPC(hMainFigure,eventdata)
%% uiDoLocalPC performs PCA on user selected regions
% Input: 
%                   hMainFigre - the figure handle 
%% Author: Kirill A. Veselkov, Imperial College London 2011
DRdata   = guidata(hMainFigure);
selIndcs = [];
if ~isempty(DRdata.SPplot.regions.bndrs)
    selRegns = DRdata.SPplot.regions.bndrs;
    nRegns   = size(selRegns,2);
    for iReg = 1: nRegns
        selIndcs = [selIndcs DRdata.SPplot.regions.bndrs(1,iReg):DRdata.SPplot.regions.bndrs(2,iReg)];
    end
    selIndcs = floor(sort(selIndcs));
    %% Regroup data-matrix before applying local PCA
    if ~isempty(DRdata.sortSelIndcs)
        DRdata.X         = DRdata.X(DRdata.sortSelIndcs,:);
        DRdata.groupdata = DRdata.groupdata(DRdata.sortSelIndcs);
        DRdata.sampleIDs = DRdata.sampleIDs(DRdata.sortSelIndcs);
    end
elseif DRdata.pos.showBR == 1
    selIndcs = (DRdata.BR.pvalues<DRdata.BR.pThr);
end
if ~isempty(selIndcs)
    uiDimensionReduction(DRdata.ppm(selIndcs),DRdata.Sp(:,selIndcs),DRdata.X(:,selIndcs),DRdata.groupdata,'markerType',DRdata.PCplot.marker.type,...
        'markerFill',DRdata.PCplot.marker.fill,'colors',DRdata.marker.color,...
        'sampleIDs',DRdata.sampleIDs,'replicates', DRdata.replicates,'groupIDs',DRdata.groupIds,'nmr',DRdata.NMR);
end
return;