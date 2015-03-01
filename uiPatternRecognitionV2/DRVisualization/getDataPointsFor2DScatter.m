function spIndcs = getDataPointsFor2DScatter(DRdata)
% scatter plot is relatively slow for a large number of data points;
% this solution randomly sub-samples data points

if DRdata.nSmpls < DRdata.PCplot.maxNumPoints
    spIndcs = [];
    return;
end

% caclulate the sample frequency per each group
nSpPerGroup    = hist(DRdata.groupdata,unique(DRdata.groupdata));
spIndcs        = zeros(1,DRdata.nSmpls);
nGroups        = length(nSpPerGroup);
spRedRatio     = DRdata.nSmpls/DRdata.PCplot.maxNumPoints;      
maxnSpPerGroup = floor(nSpPerGroup./spRedRatio);
for iGrp = 1:nGroups
    grpIndcs = find(DRdata.groupdata==iGrp);
    if nSpPerGroup<DRdata.PCplot.minNumClassPoints
        spIndcs(grpIndcs) = 1;
    else
        grpIndcs = grpIndcs(randperm(length(grpIndcs))); % randomly permute indices
        spIndcs(grpIndcs(1:maxnSpPerGroup(iGrp))) = 1;
    end    
end
spIndcs = logical(spIndcs);
return;