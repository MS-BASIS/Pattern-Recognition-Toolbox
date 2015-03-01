function DRdata = doPCALDA(DRdata,options)
%% PCA(X) performs  Linear discriminant vectors exctraction based on
%% maximum margin criterion 
%       uncorrelated features - recursiveMmcLDA.m
%       orthogonal loadings   - mmclda.m
%       Input: DRdata     - various parameters of DR toolbox objects
%              options - default parameters
%%   Author: Kirill Veselkov, Imperial College 2012
if nargin < 2
    options = [];
end
if DRdata.options.setparam==1
    DRdata.options = getVarArgin(options,length(unique(DRdata.groupdata)));
end
DRdata.meanX      = mean(DRdata.X);
nDFs              = DRdata.options.values{1};
nPCs              = DRdata.options.values{2};
[DRdata.loadings,DRdata.scores,DRdata.PCvar,DRdata.weights]  = pcaLda(getFoldChange(DRdata.X,DRdata.meanX),DRdata.groupdata,nPCs,nDFs);
return;

function options = getVarArgin(options,nClasses)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'Number of discriminating features';
    options.values{1} = num2str(max(2,nClasses-1));
    options.names{2}  = 'Number of principal components (use CV to estimate the number of PCs)';
    options.values{2} = num2str(10);
else
    options.values{1} = num2str(options.values{1});
    options.values{2} = num2str(options.values{2});
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'PCALDA Setup',1,options.values,options);
options.values{1}   = str2double(answer{1});
options.values{2}   = str2double(answer{2});