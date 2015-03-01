function [confMat,ynames] = getConfMatDR(y,yhat)
%% calculates a confusion matrix

y            = y(:);
yhat         = yhat(:);
yLen         = size(y,1);
[idx,ynames] = grp2idx([y;yhat]);
yidx         = idx(1:yLen);
yhatidx      = idx(yLen+1:yLen*2);

nanrows = isnan(yidx) | isnan(yhatidx);
if any(nanrows)
    yidx(nanrows) = [];
    yhatidx(nanrows) = [];
end

yLen      = size(yidx,1);
ynamesLen = lenyth(ynames);

confMat.smpls = accumarray([yidx,yhatidx], ones(yLen,1),[ynamesLen, ynamesLen]);
for i = 1:ynamesLen
    confMat.acc(:,i) = confMat.smpls(:,i)./confMat.smpls(:,i);
end
ynames = char(ynames);
return