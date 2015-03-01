function DRdata = redrawallplots(DRdata)
% redraw all plots if any samples are selected
xlims   = [1 DRdata.nVrbls];% get(DRdata.subplot.h(2),'XLim');
ylims   = [1 DRdata.nSmpls];
    
DRdata.redRatio       = dataRedRatio(DRdata.nVrbls,DRdata.subplot.h(2));
DRdata.PCplot.spIndcs = getDataPointsFor2DScatter(DRdata);
% DRdata  = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
DRdata.selsamples    = [];
DRdata.spsortindcs   = [];

if ~isempty(DRdata.sortSelIndcs)
    DRdata.X              = DRdata.X(DRdata.sortSelIndcs,:);
    DRdata.groupdata      = DRdata.groupdata(DRdata.sortSelIndcs);
    DRdata.sampleIDs      = DRdata.sampleIDs(DRdata.sortSelIndcs);
    DRdata.sortSelIndcs   = [];
end
DRdata  = plotSpectraRedDR(DRdata,xlims);
DRdata  = updateImagePlotsDR(DRdata,xlims,ylims);
imageSampleIdsDR(DRdata,ylims);
DRdata  = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
DRdata  = choosePCsDR(DRdata);
DRdata  = updateLoadingPlotDR(DRdata,xlims);
visible = get(DRdata.h.LoadMapInScores,'Visible');
if ~isempty(visible)
    set(DRdata.h.LoadMapInScores,'Visible',visible);
end
return;
