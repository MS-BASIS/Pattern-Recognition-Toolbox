function [X,mz] = reduceSpResolutionDR(X,nTimes,mz)
%% Extremely fast integration 
%% Author: Kirill A.Veselkov

[nSmpls,nVrbls] = size(X);
nDPrem      = rem(nVrbls,nTimes);
X(:,nDPrem) = [];
X           = X'; 
nVrbls      = (nVrbls-nDPrem)/nTimes;
X           = reshape(X,nTimes,nVrbls,nSmpls);
X           = sum(X,1); X = squeeze(X)';
if nargin>2
    mzres       = min(diff(mz))*nTimes;
    mz          = mz(1)+mzres/2:mzres:mz(end);
end

