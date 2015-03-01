function DRdata = doanovaBR(DRdata,options)
%% doPLS  computes partial least squares using simpls or nipals algorithm
%       Input: DRdata     - various parameters of DR toolbox objects
%              options - default parameters
%%   Author: Kirill Veselkov, Imperial College 2012
if nargin < 2
    options = [];
end
%if DRdata.options.setparam==1
DRdata.options = getVarArgin(options);
%end
DRdata.meanX      = mean(DRdata.X);
DRdata.BR.method  = DRdata.options.values{1};
DRdata.BR.alpha   = DRdata.options.values{2};
DRdata.BR.corrstr = DRdata.options.values{3};
DRdata.BR.pThr    = DRdata.options.values{4};

if strcmp(DRdata.BR.method, 'ANOVA')
    DRdata.BR.pvalues = onewayanovaBR(DRdata.X,DRdata.groupdata,DRdata.BR.method);
elseif strcmp(DRdata.BR.method, 'Welch ANOVA')
    DRdata.BR.pvalues = onewayanovaBR(DRdata.X,DRdata.groupdata,DRdata.BR.method);
end
return;

function options = getVarArgin(options)
%% get default input arguments
if isempty(options)
    options.names{1}   = 'Method type: ANOVA or Welch-ANOVA';
    options.values{1} = 'ANOVA';
    options.names{2}   = 'FDR alpha';
    options.values{2} = '0.05';
    options.names{3}   = 'correlation structure (pos or any)';
    options.values{3} = 'any';
    options.names{4}   = 'p-value threshold';
    options.values{4} = '';
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'Anova Setup',1,options.values,options);
options.values{1}   = answer{1};
options.values{2}   = str2double(answer{2});
options.values{3}   = answer{3};
options.values{4}   = str2double(answer{4});