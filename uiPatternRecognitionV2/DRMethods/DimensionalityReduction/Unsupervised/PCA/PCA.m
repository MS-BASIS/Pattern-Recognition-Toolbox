function DRdata = PCA(DRdata,options)
%% PCA(X) performs principal components analysis on the data matrix via
%% SVD or NIPALS algorithms
%       Input: DRdata     - various parameters of DR toolbox objects
%              options - default parameters for PCA (number of PCs and method for computing PCs)
%%   Author: Kirill Veselkov, Imperial College 2011
if nargin < 2
    options = [];
end
if DRdata.options.setparam==1
    DRdata.options = getVarArgin(options);
end
DRdata.meanX      = mean(DRdata.X);
PCmethod          = DRdata.options.values{2};
nPCs              = DRdata.options.values{1};
tol               = DRdata.options.values{3};
if strcmp(PCmethod, 'SVD')
    [DRdata.loadings,DRdata.scores,DRdata.PCvar]  = pcasvd(getFoldChange(DRdata.X,DRdata.meanX),nPCs);
elseif strcmp(PCmethod, 'NIPALS')
    [DRdata.loadings,DRdata.scores,DRdata.PCvar] =...
        pcanipals(getFoldChange(DRdata.X,DRdata.meanX),nPCs,tol);
end
return;

function options = getVarArgin(options)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'Number of principal components';
    options.values{1} = '4';
    options.names{2}   = 'Method type (select NIPALS and SVD)';
    options.values{2} = 'NIPALS';
    options.names{3}   = 'Convergence constant';
    options.values{3} = '1e-6';
else
    options.values{3} = num2str(options.values{3});
    options.values{1} = num2str(options.values{1});
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'PCA Setup',1,options.values,options);
options.values{1}    = str2double(answer{1});
options.values{2}    = answer{2};
options.values{3}    = str2double(answer{3});