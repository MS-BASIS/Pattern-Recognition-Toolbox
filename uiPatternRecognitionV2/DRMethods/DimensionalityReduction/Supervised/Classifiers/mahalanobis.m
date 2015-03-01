function mahdist = mahalanobis(X,mX,typeCV,covX)
if isvector(covX)
    covX = diag(covX);
end
if size(mX,1)>size(mX,2)
    mX = mX';
end
nSmpls  = size(X,1);
if strcmp(typeCV,'cov')
    covmat  = pinv(covX);
elseif strcmp(typeCV,'invcov')
    covmat = covX;
else
    error('not correct input arguments');
end
mcX     = X - mX(ones(1,nSmpls),:);
mahdist = sum(mcX*covmat.*mcX,2)';