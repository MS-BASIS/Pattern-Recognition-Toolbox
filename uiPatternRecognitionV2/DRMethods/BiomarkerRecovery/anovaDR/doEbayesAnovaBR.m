function DRdata = doEbayesAnovaBR(DRdata,options)
%% doEbayesAnovaBR performs univariate comparative statistical analysis using
%% the moderated Ebayes tests in R

[status,msg] = openR;
if status ~= 1
    disp(['Problem connecting to R: ' msg]);
    return;
end
if nargin < 2
    options = [];
end
DRdata.options   = getVarArgin(options); 
DRdata.BR.method  = DRdata.options.values{1};
DRdata.BR.alpha   = DRdata.options.values{2};
DRdata.BR.corrstr = DRdata.options.values{3};
DRdata.BR.pThr    = DRdata.options.values{4};
%% Set the current working directory in R
CDir                    = pwd;
CDir                    = [CDir,'\BiomarkerRecovery\ANOVAInR'];
CDir(strfind(CDir,'\')) ='/';
putRdata('CDir',CDir);
evalR('workingdir = CDir');
evalR('setwd(workingdir)');

if size(DRdata.groups,1)>size(DRdata.groups,2)
    DRdata.groups = DRdata.groups';
end    
%% Load all the required packages and data in R
evalR('source("sourceFilesForTTest")');
putRdata('X',DRdata.X);          % Import X data into the R environment
putRdata('group',DRdata.groups);      % Import y data into the R environment
evalR('groups              <- factor(t(group))');
evalR('design              <- model.matrix(~0+groups)');
evalR('fit                 <- lmFit(t(X), design)');
evalR('contr.mat           <- contr.helmert(levels(groups))');
%evalR('contr.mat           <- contr.poly(levels(groups))');
evalR('rownames(contr.mat) <- colnames(design)');
evalR('fit2                <- contrasts.fit(fit, contr.mat)');
evalR('fit2                <- eBayes(fit2)');
evalR('pvalues             <- fit2$F.p.value');
DRdata.BR.pvalues = getRdata('pvalues');
return;

function options = getVarArgin(options)
%% get default input arguments
if isempty(options)
    options.names{1}   = 'Method type';
    options.values{1} = 'Ebayes ANOVA';
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
answer              = inputdlg(options.names,'Empirical Bayes Anova Setup',1,options.values,options);
options.values{1}   = answer{1};
options.values{2}   = str2double(answer{2});
options.values{3}   = answer{3};
options.values{4}   = str2double(answer{4});