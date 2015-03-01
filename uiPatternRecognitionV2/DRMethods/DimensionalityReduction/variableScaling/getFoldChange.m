function X = getFoldChange(X,refX)
% get fold change
X = X - refX(ones(1,size(X,1)),:);
