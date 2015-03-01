function selsamples = getSelectedSpectra(DRdata)
if ~isempty(DRdata.PCplot.spIndcs)
    [~,selsamples] = intersect(find(DRdata.PCplot.spIndcs==1),DRdata.selsamples);
else
    selsamples = DRdata.selsamples;
end
