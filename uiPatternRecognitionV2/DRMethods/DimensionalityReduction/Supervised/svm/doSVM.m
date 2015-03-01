function DRdata = doSVM(DRdata,options)
%% SVM: Support Vector Machine analysis using LIBSVM
%
% Ottmar Golf, Kirill Veslekov 2014
if nargin < 2
    options = [];
end
if DRdata.options.setparam==1
    DRdata.options = getVarArgin(options,length(unique(DRdata.groupdata)));
end

%% Mean centering
DRdata.Xorig = DRdata.X;
DRdata.meanX = mean(DRdata.X);
DRdata.X     = DRdata.X - DRdata.meanX(ones(1,size(DRdata.X,1)),:); 

%% Automated parameter selection
if strcmp(DRdata.options.values{2},'Yes') && ~strcmp(DRdata.options.values{1},'0')...
        && ~isfield(DRdata,'bestcv');
    bestcv = 0;
    for log2c = -5:8,
        for log2g = -8:4,
            cmd = ['-q -v 5 -t ' num2str(DRdata.options.values{1}) ' -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
            cv = svmtrain(DRdata.groupdata,DRdata.X, cmd);
            if (cv >= bestcv),
                DRdata.bestcv = cv; DRdata.bestc = 2^log2c; DRdata.bestg = 2^log2g;
            end
            % fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
        end
    end
    cmd = ['-q -t ' num2str(DRdata.options.values{1}) ' -c ', num2str(DRdata.bestc), ' -g ', num2str(DRdata.bestg)];
elseif isfield(DRdata,'bestcv')
    cmd = ['-q -t ' num2str(DRdata.options.values{1}) ' -c ', num2str(DRdata.bestc), ' -g ', num2str(DRdata.bestg)];
else
    cmd = ['-q -t ' num2str(DRdata.options.values{1})];
end

%% SVM analysis
model          = svmtrain(DRdata.groupdata,DRdata.X,cmd);
DRdata.weights = (model.sv_coef'*full(model.SVs))';
DRdata.scores  = DRdata.X*DRdata.weights;
end

function options = getVarArgin(options)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'Kernel Type: Linear (0), Polynomial (1), Radial basis function (2) or sigmoid (3)';
    options.values{1} = num2str(2);
    options.names{2}  = 'Automated parameter selection: Yes or No';
    options.values{2} = 'No';
else
    options.values{1} = num2str(options.values{1});
    options.values{2} = options.values{2};
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'SVM Setup',1,options.values,options);
options.values{1}   = str2double(answer{1});
options.values{2}   = str2double(answer{2});
end