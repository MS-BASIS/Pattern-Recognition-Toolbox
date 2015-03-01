function [P, T,varDV] = recursivePcaLda(X,y,nPCs,nDVs) 
%% LDA: Recursive Linear discriminant analysis (Fisherfaces approach PCA+LDA) 
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

%% mean center data
meanX = mean(X);
X     = X - meanX(ones(1,nObs),:);
Xorig = X;
ssqX  = ssq(X);
%% initialize parameters
T     = zeros(nObs,nDVs);
P     = zeros(nVar,nDVs);

if nargin<4 
    nDVs = nClasses-1;
end  

%% Dimension reduction by means of principal component analysis
if nVar > (nObs - nClasses)
    %[P1, T1]   = pcasvd(X,nObs - nClasses); % usually overfits
    [P1, T1]    = pcasvd(X,nPCs);
    X           = T1;
    nDVs        = nPCs;
    nVar        = size(X,2);
end 

for j = 1:nDVs
    sampleMean = mean(X);
    Sw         = zeros(nVar, nVar);
    Sb         = zeros(nVar, nVar);
    for i = 1:nClasses
        indcs       = (y == classLabel(i));
        nClassSmpls = sum(indcs);
        classMean   = mean(X(indcs,:));
        classMeanSw = classMean(ones(nClassSmpls,1),:);
        classprior  = nClassSmpls/nObs;
        Sw          = Sw + (1./nObs)*((X(indcs,:)-classMeanSw)'*(X(indcs,:)-classMeanSw));
        Sb          = Sb + classprior.*(classMean - sampleMean)'*(classMean - sampleMean);
    end   
    Sw         = (Sw + Sw')/2;
    Sb         = (Sb + Sb')/2;
    [w,D] = eigs(Sb,Sw,1,'la',struct('disp',0));
    if D<eps
        break;
    end
    w        = w./norm(w);
    T(:,j)   = X*w;
    p        = X'*T(:,j)./(T(:,j)'*T(:,j));
    X        = X - T(:,j)*p'; 
    [ign, X] = pcasvd(X);
    nVar     = size(X,2);
    P(:,j)   = Xorig'*T(:,j)./(T(:,j)'*T(:,j));
end

for iDV = 1:nDVs
    varDV(iDV) = (1- ssq(Xorig-T(:,iDV)*P(:,iDV)')./ssqX)*100;
end

return;