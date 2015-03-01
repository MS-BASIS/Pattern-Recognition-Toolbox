function cvpartindcs = cvDataSetPartition(DRdata)
%% cvDataSetPartition performs data partitions for cross-validation
    % Input: nObs         - number of observations
    %        cvType       - n fold cross validation {'nfold', nfolds } or...
    %                       leave-one-out cross validations {'loo'}
    % Output: cvpartindcs - cross validation partition indices
%% Author: Kirill A. Veselkov, Imperial College London

nObs   = DRdata.nSmpls;
cvType = DRdata.cv.Type;

if strcmp(cvType{1},'K-fold')
    nfold = cvType{2};
    if nObs<nfold
        warning( ['The number of folds  is greater than the number of observations'...
            'n is set to the number of observations!']);
        nfold = nObs;
    end
    cvpartindcs = 1 + mod((1:nObs)',nfold);
    cvpartindcs = cvpartindcs(randperm(nObs)); % reshafle cv partition indices
    
elseif strcmp(cvType{1},'Leave one out')
    if ~isempty(DRdata.replicates)
        cvpartindcs = DRdata.replicates;
    else
        cvpartindcs = 1:nObs; % reshafle cv partition indices
    end
end
return;