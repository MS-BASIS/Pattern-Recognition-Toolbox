function DRdata = resetparamDR(DRdata)
DRdata.PCplot.stateOM       = 0;
DRdata.PCplot.parallelCoord = 0;
set(DRdata.h.DRLocalTBOutMap,'State','off');
if ~isempty(DRdata.spsortindcs) || ~isempty(DRdata.selsamples)
    DRdata.spsortindcs    = [];
    DRdata.selsamples     = [];
    if ~isempty(DRdata.sortSelIndcs)
        DRdata.X              = DRdata.X(DRdata.sortSelIndcs,:);
        DRdata.groupdata      = DRdata.groupdata(DRdata.sortSelIndcs);
        DRdata.sampleIDs      = DRdata.sampleIDs(DRdata.sortSelIndcs);
        DRdata.sortSelIndcs   = [];
    end
end
return;