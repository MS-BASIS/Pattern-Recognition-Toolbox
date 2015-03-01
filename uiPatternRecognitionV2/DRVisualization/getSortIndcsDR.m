function [sortSelInds,sortIndcs] = getSortIndcsDR(DRdata)
sortSelInds                      = 1:size(DRdata.Sp,1);
sortSelInds(DRdata.selsamples)   = [];
sortSelInds                      = [DRdata.selsamples sortSelInds];
[ignore,sortIndcs]               = sort(sortSelInds);