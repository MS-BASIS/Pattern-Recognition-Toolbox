function outdist = getOutliers(X,mX,T,P,mT,covT,nonoutliers,cutoff,nPerms)
%% getOutlierDist calculates orthogonal and score distances for detecting
%%                outliers using PCA
% Input:  P           - PC loadings
%         T           - PC scores
%         mT          - mean values of PC scores (e.g. zeros(1,nPCs))
%         covT        - covariance matrix of PC scores
%         cutoff      - cutoff
%         nonoutliers - the number of non-outlying observations
%% Author: Kirill A. Veselkov, Imperial College London, 2011. 


%% Get score distances within the PCA subspace
nPCs              = size(T,2);
nSmpls            = size(X,1);

if nargin<9
    nPerms = 250;
end

if isempty(mT)||isempty(covT) % get robust estimates of location and scatter
    resmcd = mcdcov(T,'h',nonoutliers,'ntrial',nPerms);
    mT     = resmcd.center;
    covT   = resmcd.cov;
end

outdist.sd.vals   = sqrt(mahalanobis(T,mT,'cov',covT))';
outdist.sd.cutoff = sqrt(chi2inv(cutoff,nPCs));
outdist.sd.flag   = (outdist.sd.vals<=outdist.sd.cutoff);

%% Orthogonal distances to the PCA subspace
mcX             = X - mX(ones(1,nSmpls),:);
Xrec            = T*P';
Xres            = mcX - Xrec;
outdist.od.vals = sqrt(sum(Xres.^2,2));
if sum(outdist.od.vals)~=0
    [m,s]              = unimcd(outdist.od.vals.^(2/3),nonoutliers);
    outdist.od.cutoff  = sqrt(norminv(cutoff,m,s).^3); % Robust cutoff-value for orthogonal distances
    outdist.od.flag    = (outdist.od.vals<=outdist.od.cutoff);
    outdist.sdod.flag  = outdist.sd.flag&outdist.od.flag;
else
    outdist.sdod.flag  = outdist.sd.flag;
end

return;