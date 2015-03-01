function resRobPCA = RPCA(X,varargin)
%% RPCA performs robust principal component analysis of data matrix X [samples x variables]

%          Input: 
%           X         - data matrix [samples by variables]
%          'nPCs'     - the number of PCs
%          'mcdPCs'   - the number of PCs for the minimum covariance
%                       determinant estimator
%          'alpha'    - the percentage of outlying sample observations
%          'nRandDir' - the number of randomly selected directions for
%                       computing outlyingness

%  Please cite the following paper if you use this code Hubert, M., Rousseeuw, P.J., Vanden
%  Branden, K. (2005), ROBPCA: a new approach to robust principal components 
%  analysis, Technometrics, 47, 64-79.

% This code is a modification of functions written by Mia Hubert, Sabine Verboven, Karlien
% Vanden Branden, Sanne Engelen, Tim Verdonck as part of LIBRA toolbox for
% improved transparancy and efficiency.

%% Author: Kirill A. Veselkov, Imperial College 2011.


[nSmpls,nVrbls] = size(X);
options         = getVarArgin(varargin,nSmpls,nVrbls);

%% 1. Perform PCA to capture the space spanned by the observarations
[P1,T1,eigvals1,rankX1,mX1] = pcasvd(X); % mX - mean of X; mCenX - mean centered X;

%% Select n univariate directions at random
normUnivDirs = setUnivDirs(T1,options.nRandDir);
projT        = T1*normUnivDirs'; % project sample points onto the normalized univaraite directions

%% Calculate the outlyingness for each observation
nProj        = size(projT,2);
outlyingness = zeros(nSmpls,nProj);
for iProj = 1:nProj
    [tmcdi,smcdi,weights] = unimcd(projT(:,iProj),options.nonoutliers);
    if smcdi < eps
        r2 = rank(X(weights,:));
        if r2==1
            error(['At least ',num2str(sum(weights)),' obervations are identical.']);
        end
    else
        outlyingness(:,iProj)=abs(projT(:,iProj)-tmcdi)/smcdi;
    end
end
outlyingness = max(outlyingness,[],2);  %% options.mcdPCs = min([nInfPCs,options.mcdPCs]);

%% 2. Calculate non-outlying observations 
[sortVals,sortIndcs]        = sort(outlyingness);
Toutexcl                    = T1(sortIndcs(1:options.nonoutliers),:); %PC scores with excluded outliers
[P2,T2,eigvals2,rankX2,mX2] = pcasvd(Toutexcl);
options.nPCs                = min(options.nPCs,rankX2);
options.mcdPCs              = min(options.mcdPCs,rankX2);
outlierset.ind1             = sortIndcs(1:options.nonoutliers);

%% 3. Refined of outliers via orthogonal distances to the space spanned by PCs
if options.nPCs<=rankX1
    mcX                         = T1 - mX2(ones(1,nSmpls),:);
    Xrec                        = mcX*P2(:,1:options.nPCs)*P2(:,1:options.nPCs)';
    Xres                        = mcX - Xrec;
    OrtDist                     = sqrt(sum(Xres.^2,2));
    [m,s]                       = unimcd(OrtDist.^(2/3),options.nonoutliers);
    cutoffOrtDist               = sqrt(norminv(options.cutoff,m,s).^3);
    outlierset.ind2             = find(OrtDist<=cutoffOrtDist)';
    [P3,T3,eigvals3,rankX3,mX3] = pcasvd(T1(outlierset.ind2,:));
    options.nPCs                = min(options.nPCs,rankX3);
    options.mcdPCs              = min(options.mcdPCs,rankX3);
end
mX = mX1+mX3*P1';
P  = P1*P3(:,1:options.nPCs);
T  = (T1-mX3(ones(1,nSmpls),:))*P3;

mcdPCA   = projMCD(T,eigvals3,options.nPCs,options.nonoutliers,options.niter,...
    P,P1,P3,mX,options.cutoff);
outliers = getOutliers(X,mcdPCA.mX,mcdPCA.T,mcdPCA.P,zeros(1,options.nPCs),mcdPCA.eigvals,...
    options.nonoutliers,options.cutoff);

[P,T,eigvals,rankX,meanX] = pcasvd(X(outliers.od.flag,:));

resRobPCA.PCvar    = eigvals(1:options.nPCs)./sum(eigvals); 
mcX                = X - meanX(ones(1,nSmpls),:);
resRobPCA.loadings = P(:,1:options.nPCs);
resRobPCA.scores   = mcX*resRobPCA.loadings;
resRobPCA.meanX    = meanX;        
resRobPCA.outliers = outliers;
return;

function options = getVarArgin(argsin,nSmpls,nVrbls)
% options.alpha       - the percentage of outlying sample observations
% options.nonoutliers - the number of non-otlying sample observations e.g. (1-options.alpha)*nSmpls
% options.nPCs        - the number of PCs
% options.mcdPCs      - the number of PCs used in the MCD estimator
% options.nRandDir    - the number of randomly selected directions for outlyingness
%% Author: Kirill A. Veselkov, Imperial College London 2011.

options.alpha    = 0.25;
options.nPCs     = 4;
options.mcdPCs   = 10;
options.cutoff   = 0.975; 
options.nRandDir = 250;     % constant
options.niter    = 100;     % constant
nArgs            = length(argsin);
for i=1:2:nArgs
    if  strcmp('alpha',argsin{i})
        options.alpha        = argsin{i+1};
    elseif strcmp('nPCs',argsin{i})
        options.nPCs   = argsin{i+1};
    elseif strcmp('mcdPCs',argsin{i})
        options.mcdPCs = argsin{i+1};
    elseif strcmp('nRandDir',argsin{i})
        options.nRandDir = argsin{i+1};
    end
end
options.mcdPCs      = min(options.mcdPCs,floor(nSmpls/2));
options.nonoutliers = min(ceil((1 - options.alpha)*nSmpls),(nSmpls+nVrbls+1)/2);
return;

function [P,T,eigvals,rankX,meanX,X] =  pcasvd(X,nPCs)
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