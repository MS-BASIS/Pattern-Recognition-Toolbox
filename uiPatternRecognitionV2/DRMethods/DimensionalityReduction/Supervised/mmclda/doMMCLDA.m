function [DRdata,validity] = doMMCLDA(DRdata,options)
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
DRdata.meanX = mean(DRdata.X);
method       = DRdata.options.values{2};
nDFs         = DRdata.options.values{1};
if strcmp(method, 'UF')
    [DRdata.loadings,DRdata.scores,DRdata.PCvar,DRdata.weights]  = ...
        recursiveMmcLda(getFoldChange(DRdata.X,DRdata.meanX),DRdata.groupdata,nDFs);
    
elseif strcmp(method, 'OL')
    [DRdata.loadings,DRdata.scores,DRdata.weights] =...
        mmclda(getFoldChange(DRdata.X,DRdata.meanX),DRdata.groupdata,nDFs);
    DRdata.PCvar   = [];
end
return;

function options = getVarArgin(options,nClasses)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'Number of discriminant factors)';
    options.values{1} = num2str(max(2,nClasses-1));
    options.names{2}   = 'Method type: UncorrelatedFactors (UF) or OrthogonalLoadings (OL)';
    options.values{2} = 'UF';
else
    options.values{1} = num2str(options.values{1});
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'MMCLDA Setup',1,options.values,options);
options.values{1}    = str2double(answer{1});
options.values{2}    = answer{2};