function DRdata = restartPlotsDR(DRdata,doubleclick)
if nargin < 2
    doubleclick =1 ;
end
xlims = get(DRdata.subplot.h(2),'xlim');
ylims = get(DRdata.subplot.h(3),'ylim');
updatePlotsDR(DRdata,doubleclick);
DRdata.selsamples    = [];
DRdata.spsortindcs   = [];
if ~isempty(DRdata.sortSelIndcs)
    DRdata.X              = DRdata.X(DRdata.sortSelIndcs,:);
    DRdata.groupdata      = DRdata.groupdata(DRdata.sortSelIndcs);
    DRdata.sampleIDs      = DRdata.sampleIDs(DRdata.sortSelIndcs);
    DRdata.sortSelIndcs   = [];
end
DRdata                    =  updateImagePlotsDR(DRdata,xlims,ylims);
imageSampleIdsDR(DRdata,ylims);