function [P,T,W] = mmclda(X,y,nDVs)
%%  Linear discriminant vectors exctraction based on maximum margin criterion
%  [P, T] = lda(X, y)
%%  Input:
%        X   - data matrix [observations x variables]
%        y   - class labels [observations x 1]
%       nDVs - number of latent variabels
%%  Output:
%        W   - orthogonal loadings of discrimating features
%        T   - scores of correlated discriminating features
%%	Reference:
%       Li, H., Jiang, T. and Zhang, K., Efficient and Robust Feature
%       Extraction by Maximum Margin Criterion. In Proceedings of
%       the Advances in Neural Information Processing Systems 16,
%      (Vancouver, Canada, 2004), MIT Press.
%% Author: Veselkov Kirill, Imperial College London, 2012

[nObs,nVar] = size(X);
classLabel  = unique(y);
nClasses    = length(classLabel);
pcaDimRed   = 0;
Xorig       = X;
if nVar > (nObs - 1)
    [W1, T1]    = pcasvd(X,nObs - 1);
    pcaDimRed   = 1;
    X           = T1;
    nVar        = size(X,2);
end

if nargin < 3
    nDVs = nVar;
end

sampleMean = mean(X);
temp        = zeros(nVar, nVar);
for i = 1:nClasses
    indices   = y==classLabel(i);
    classMean = mean(X(indices, :));
    temp       = temp + sum(indices).*classMean'*classMean;
end
Sw           = X'*X - temp;
Sb           = temp - nObs.*sampleMean'*sampleMean;
Sw           = (Sw + Sw')/2;
Sb           = (Sb + Sb')/2;
[W,D]        = eig(Sb-Sw);
[vals,indcs] = sort(diag(D),'descend');
W            = W(:,indcs(1:nDVs));
for i = 1:nDVs
    if W(1,i)>0 % rotate for consistency
        W = -W;
    end
end
if pcaDimRed == 1
    W = -W1*W;
end
T = Xorig*W;
P = zeros(size(W));
for j =1:nDVs
    P(:,j) = Xorig'*T(:,j)./(T(:,j)'*T(:,j));
end
return;