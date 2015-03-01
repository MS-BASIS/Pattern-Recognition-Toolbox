function DRdata = doPLS(DRdata,options)
%% doPLS  computes partial least squares using simpls or nipals algorithm
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
method            = DRdata.options.values{2};
nDFs              = max(2,length(unique(DRdata.groupdata))-1); %DRdata.options.values{1}; Ottmar
if strcmp(method, 'simpls')
    [DRdata.loadings,DRdata.scores,DRdata.weights, DRdata.PCvar] = plssimpls(getFoldChange(DRdata.X,DRdata.meanX),getDummyY(DRdata.groupdata,'yes'),nDFs);
elseif strcmp(method, 'nipals')
   [DRdata.scores,DRdata.loadings,DRdata.weights,DRdata.PCvar] = pls2nipals(getFoldChange(DRdata.X,DRdata.meanX),getDummyY(DRdata.groupdata,'yes'),nDFs);
end
return;

function options = getVarArgin(options,nClasses)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'Number of discriminant factors (e.g. number of classes - 1)';
    options.values{1} = num2str(max(2,nClasses-1));
    options.names{2}   = 'Method type: simpls or nipals';
    options.values{2} = 'simpls';
else
    options.values{1} = num2str(options.values{1});
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'PLS Setup',1,options.values,options);
options.values{1}   = str2double(answer{1});
options.values{2}   = answer{2};