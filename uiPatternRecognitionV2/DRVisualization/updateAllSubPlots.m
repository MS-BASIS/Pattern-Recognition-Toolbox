function DRdata = updateAllSubPlots(DRdata)

set(0,'CurrentFigure',DRdata.h.figure);
if DRdata.PCplot.plot3D ==1&&size(DRdata.scores,1)>2
    DRdata.PCplot.selPCs = [1,2,3];
else
    DRdata.PCplot.selPCs = [1,2];
end
visible              = []; %get(DRdata.h.LoadMapInScores,'Visible');
DRdata               = scatter2D(DRdata);
if ~isempty(visible)
    set(DRdata.h.LoadMapInScores,'Visible',visible);
end
DRdata = choosePCsDR(DRdata);
DRdata = updateLoadingPlotDR(DRdata);
DRdata = plotSpectraRedDR(DRdata);
DRdata = updatePlotsDR(DRdata);
DRdata = plotMetabolicMapDR(DRdata);
imageSampleIdsDR(DRdata);
return;