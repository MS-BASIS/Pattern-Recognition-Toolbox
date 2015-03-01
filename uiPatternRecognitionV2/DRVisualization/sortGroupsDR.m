function DRdata = sortGroupsDR(DRdata,order)
%% sortGroupsDR

nGrps    = length(DRdata.groupIds);
arrIndcs = DRdata.groups;
groups   = DRdata.groups;
indexStart = 1;

for iGrp = 1:nGrps
    iGrpIndcs                     = find(DRdata.groups==order(iGrp));
    indexEnd                      = indexStart+length(iGrpIndcs)-1;
    arrIndcs(indexStart:indexEnd) = iGrpIndcs;
    groups(indexStart:indexEnd)   = iGrp;
    indexStart                    = indexEnd+1;
end
DRdata.sampleIDs          = DRdata.sampleIDs(arrIndcs);
DRdata.Sp                 = DRdata.Sp(arrIndcs,:);
DRdata.X                  = DRdata.X(arrIndcs,:);
DRdata.scores             = DRdata.scores(arrIndcs,:);
DRdata.groups             = groups;
DRdata.groupdata          = groups;
DRdata.spcolors           = DRdata.spcolors(order,:);
DRdata.marker.color       = DRdata.marker.color(order);
DRdata.PCplot.marker.fill = DRdata.PCplot.marker.fill(order);
DRdata.PCplot.marker.type = DRdata.PCplot.marker.type(order);
DRdata.h.text             = DRdata.h.text(arrIndcs);
DRdata.h.markers          = DRdata.h.markers(arrIndcs);
DRdata.groupIds           = DRdata.groupIds(order);
DRdata.pca.T              = DRdata.pca.T(arrIndcs,:);
return;