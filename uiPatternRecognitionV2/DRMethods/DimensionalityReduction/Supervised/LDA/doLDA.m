function [DRdata,validity] = doLDA(DRdata,options)
%% LDA(X) performs  Linear discriminant analysis
%       Input: DRdata     - various parameters of DR toolbox objects
%              options - default parameters
%%   Author: Ottmar Golf, Kirill Veselkov, Imperial College 2014
if nargin < 2
    options = [];
end
if DRdata.options.setparam==1
    DRdata.options = getVarArgin(options,length(unique(DRdata.groupdata)));
end
method       = DRdata.options.values{1};

%% Mean centering
DRdata.Xorig = DRdata.X;
DRdata.meanX = mean(DRdata.X);
DRdata.X     = DRdata.X - DRdata.meanX(ones(1,size(DRdata.X,1)),:); 

%% LDA analysis
model = fitcdiscr(DRdata.Xorig,DRdata.groupdata,'DiscrimType','pseudoLinear');
W = LDA(DRdata.X,DRdata.groupdata);
% DRdata.loadings = model.Y;
DRdata.weights  = W(:,2:end)';
DRdata.scores   = [ones(size(DRdata.X,1),1) DRdata.X]*W';

end

function options = getVarArgin(options)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'LDA Discriminant Type';
    options.values{1} = 'linear';
else
    options.values{1} = options.values{1};
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'LDA Setup',1,options.values,options);
options.values{1}    = answer{1};
end