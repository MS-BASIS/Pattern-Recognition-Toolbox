function [P,T,eigvals,rankX,meanX,X] =  robpcasvd(X,nPCs)
%% pcasvd calculates PC scores and loadings via singular value
%% decomposition
%    Input:    X    - [samples x variables] data matrix, assumed to be mean centered
%%   Author: Kirill Veselkov, Imperial College 2011

if nargin<2
    nPCs = size(X,1); % number of samples
end
meanX   = mean(X);
X       = X - meanX(ones(1,size(X,1)),:);
[U,D,P] = svd(X./sqrt(size(X,1)-1),'econ');
eigvals = diag(D.^2);
T       = X*P;
rankX   = sum(eigvals>eps); % the number of informative PCs
if nPCs<rankX
    rankX = nPCs;
end
if rankX <1
    error('The number of non-zero eigenvalues should be more than one');
else
    T = T(:,1:rankX); P = P(:,1:rankX); eigvals = eigvals(1:rankX);
end
return;