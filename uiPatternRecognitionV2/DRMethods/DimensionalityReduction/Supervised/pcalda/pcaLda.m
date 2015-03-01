function [P, T, varDV, W] = pcaLda(X,y,nPCs,nDVs) 
%% LDA: Linear discriminant analysis (Fisherfaces approach PCA+LDA) 
%  [P, T] = lda(X, y) 
%  Input: 
%        X - data matrix [observations x variables]
%        y - class labels [observations x 1]
%  Output: 
%        P - discriminant feature loadings
%        T - discriminant feature scores  

%	Reference: 
%        P. N. Belhumeur, J. P. Hespanha, and D. J. Kriegman, eigenfaces 
%        vs. fisherfaces: recognition using class specific linear 
%        projection,IEEE Transactions on Pattern Analysis and Machine 
%        Intelligence, vol. 19, no. 7, pp. 711-720, July 1997.   
% 
%% Author: Veselkov Kirill, Imperial College London  
 

[nObs,nVar] = size(X); 
classLabel  = unique(y); 
nClasses    = length(classLabel); 
pcaDimRed   = 0;
meanX       = mean(X);
X           = X - meanX(ones(1,size(X,1)),:); 
ssqX        = ssq(X);

if nargin<4 
    nDVs = nClasses-1;
end  

nPCs = min([nPCs,nVar-1,nObs-nClasses]);
%% Dimension reduction by means of principal component analysis
[P1, T1]  = pcasvd(X,nPCs);
pcaDimRed = 1;
X         = T1;
nVar      = size(X,2);
nDVs      = min(nDVs,nVar);
 
nDVs = max(2,nDVs);
%% Between and within class scatter matrix calculations
sampleMean = mean(X);
Sw         = zeros(nVar, nVar);
Sb         = zeros(nVar, nVar);
for i = 1:nClasses
    indcs       = (y == classLabel(i));
    nClassSmpls = sum(indcs);
    classMean   = mean(X(indcs,:));
    classMeanSw = classMean(ones(nClassSmpls,1),:);
    classprior  = nClassSmpls/nObs;
    Sw          = Sw + (1./nObs).*((X(indcs,:)-classMeanSw)'*(X(indcs,:)-classMeanSw));
    Sb          = Sb + classprior.*(classMean - sampleMean)'*(classMean - sampleMean);
end
Sw         = (Sw + Sw')/2;
Sb         = (Sb + Sb')/2;

%% Eigenvalue decomposition
[W,D]       = eigs(Sb,Sw,nDVs,'la',struct('disp',0)); 
%[W,D]        = eig(Sw\Sb); 
[vals,indcs] = sort(diag(D),'descend');
W            = W(:,indcs(1:nDVs));
for iDV = 1:nDVs
    W(:,iDV)     = W(:,iDV)./norm(W(:,iDV));
end
T = X*W;

P = zeros(size(W));
for iDV = 1:nDVs
    P(:,iDV)     = X'*T(:,iDV)./(T(:,iDV)'*T(:,iDV));
    varDV(iDV) = 100*ssq(T(:,iDV)*P(:,iDV)')./ssqX;
end

if pcaDimRed == 1  
    P = P1*P; 
    W = P1*W;
end
return;