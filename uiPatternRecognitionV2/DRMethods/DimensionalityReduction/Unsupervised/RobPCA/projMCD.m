function resMCD = projMCD(T,eigvals,nPCs,nNonOutls,niter,rot,P1,P2,meanX,cutoff)
% this function performs the last part of ROBPCA when nPCs is determined.

% input : 
%   T         : the projected data
%   eigvals   : the matrix of the eigenvalues
%   nPCs      : the number of components
%   nNonOutls : lower bound for regular observations
%   niter     : the number of iterations
%   rot       : the rotation matrix
%   P1, P2    : the different eigenvector matrices after each transformation
%   meanX     : the mean of X

T       = T(:,1:nPCs);
nSmpls  = size(T,1);
rot     = rot(:,1:nPCs);
% first apply c-step with nNonOutls points from first step,i.e. those that
% determine the covariance matrix after the c-steps have converged.
mahDist = mahalanobis(T,zeros(size(T,2),1),'cov',eigvals(1:nPCs));
oldobj  = prod(eigvals(1:nPCs));
P4      = eye(nPCs); 
korig   = nPCs;
for j=1:niter
    [sortVals,sortIndcs]       = sort(mahDist);
    Toutexcl                   = T(sortIndcs(1:nNonOutls),:);
    [P,Toutexcl,eigvals,r3,mT] = robpcasvd(Toutexcl);
    obj                        = prod(eigvals);
    T                          = (T-mT(ones(1,nSmpls),:))*P;
    meanX                      = meanX+mT*rot';
    rot                        = rot*P;
    mahDist                    = mahalanobis(T,zeros(size(T,2),1),'cov',diag(eigvals));
    P4                         = P4*P;
    if ((r3==nPCs) && (abs(oldobj-obj) < 1.e-12))
        break;
    else
        oldobj=obj;
        j = j+1;
        if r3 < nPCs
            j=1;
            nPCs=r3;
        end
    end
end

[zres,zraw] = mcdcov(T,'plots',0,'ntrial',250,'h',nNonOutls);
out.resMCD  = zres;
if zraw.objective < obj
    z = zres;
    out.Hsubsets.H1 = zres.Hsubsets.Hopt;
else
    sortmah = sort(mahDist);
    if nNonOutls==nSmpls
        factor=1;
    else
        factor = sortmah(nNonOutls)/chi2inv(nNonOutls/nSmpls,nPCs);
    end
    mahDist                  = mahDist/factor;
    weights                  = mahDist <= chi2inv(cutoff,nPCs);
    [center_noMCD,cov_noMCD] = weightmecov(T,weights);
    mahDist                  = mahalanobis(T,center_noMCD,'cov',cov_noMCD);
    z.flag                   = (mahDist <= chi2inv(cutoff,nPCs));
    z.center                 = center_noMCD;
    z.cov                    = cov_noMCD;
    out.Hsubsets.H1          = sortIndcs(1:nNonOutls);
end
covf             = z.cov;
centerf          = z.center;
[P6,eigvals]     = eig(covf);
[eigvals,I]      = sort(diag(real(eigvals)),'descend');
P6               = P6(:,I);
resMCD.T         = (T-repmat(centerf,nSmpls,1))*P6;
P                = P1*P2;
resMCD.P         = P(:,1:korig)*P4*P6;
centerfp         = meanX+centerf*rot';
resMCD.mX        = centerfp;
resMCD.eigvals   = eigvals';
resMCD.nPCs      = nPCs;
resMCD.nNonOutls = nNonOutls;

% creation of Hfreq
resMCD.Hsubsets.Hfreq = zres.Hsubsets.Hfreq(1:nNonOutls);  
return 

function [wmean,wcov]=weightmecov(data,weights)

if size(weights,1)==1
   weights=weights';
end

%Using sparse matrix; the expression is valid even for non-double data type
q     = find(weights);
wmean = sum(spdiags(double(weights/sum(weights)),0,length(weights),length(weights))*double(data));
wcov  = (data(q,:)-repmat(wmean,length(q),1))'*(data(q,:)-repmat(wmean,length(q),1))/(sum(weights.^2)-1);