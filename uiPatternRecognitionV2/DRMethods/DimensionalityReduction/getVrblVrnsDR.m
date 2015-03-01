function varValues = getVrblVrnsDR(DRdata)
%% getVrblVrnsDR calculates individual variables' variances explained by PCs 
%                  Input: DRdata - data of dimension reduction objects
%% Author: Kirill A. Veselkov, Imperial College London 2011. 


nSmpls        = size(DRdata.X,1);
selPCsForRecs = DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1);
if ~isempty(DRdata.selsamples)
    selIndcs  = DRdata.selIndcs;
else
    selIndcs  = 1:nSmpls;
end
RecX          = DRdata.scores(selIndcs,selPCsForRecs)*DRdata.loadings(:,selPCsForRecs)';
if ~isempty(DRdata.meanX)
    RecX     = RecX + DRdata.meanX(ones(1,nSmpls),:);
end
X                      = DRdata.X - RecX;
varValues              = 1-var(X)./var(DRdata.X);
varValues(varValues<0) = 0;
return