function [confMat,ynames] = getConfMatDR(y,yhat)
%% getConfMatDR calculates a confusion matrix
%   Input: y    - class labels
%          yhat - predicted class labels
%% Author: Kirill A.Veselkov, Imperial College London, 2011

y            = y(:);
yhat         = yhat(:);
yLen         = size(y,1);
[idx,ynames] = grp2idx([y;yhat]);
yidx         = idx(1:yLen);
yhatidx      = idx(yLen+1:yLen*2);
yLen         = size(yidx,1);
ynamesLen    = length(ynames);

confMat.smpls = accumarray([yidx,yhatidx], ones(yLen,1),[ynamesLen, ynamesLen]);
for i = 1:ynamesLen
    confMat.acc(i,:) = 100*confMat.smpls(i,:)./sum(confMat.smpls(i,:));
end
ynames = char(ynames);
return;