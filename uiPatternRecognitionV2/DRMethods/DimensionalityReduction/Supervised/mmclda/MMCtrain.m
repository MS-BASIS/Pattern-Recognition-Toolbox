function [W,B,meanX] = MMCtrain(X,y)
%% performs  Linear discriminant vectors exctraction based on
%% maximum margin criterion
%       uncorrelated features - recursiveMmcLDA.m
%       orthogonal loadings   - mmclda.m
%       Input: hmainfig  - figure object of ms imaging toolboox
%% Author: Kirill Veselkov, Imperial College 2012

nClasses = length(unique(y));
%options = getVarArgin(options,nClasses);

oneToAll              = 1;%options.values{3};
method                = 'OL';%options.values{2};
nDFs                  = nClasses-1;%options.values{1};
[h,w,nVrbls]          = size(X);

meanX = mean(X);
if oneToAll==1
    W   = zeros(w,nDFs);
    yid = unique(y');
    for i = yid
        yi = y==i;
        if strcmp(method, 'UF')
            [P,T,PCvar,Wi] = recursiveMmcLda(X,yi,1);
        elseif strcmp(method, 'OL')
            [P,T,Wi]  = mmclda(X,yi,1);
            PCvar     = [];
        end
        R = corrcoef([T(:,1),yi]);
        if R(1,2)<0
            W(:,i) = -Wi(:,1);
        else
            W(:,i) = Wi(:,1);
        end
        T(:,1) = X*W(:,i);
        B{i} = glmfit(T(:,1),yi, 'binomial', 'link', 'logit');
    end
else
    if strcmp(method, 'UF')
        [P,T,PCvar,W] = recursiveMmcLda(X,y,nDFs);
    elseif strcmp(method, 'OL')
        [P,T,W]       = mmclda(X,y,nDFs);
        PCvar         = [];
    end
    B= 0 ;
end


return;

function options = getVarArgin(options,nClasses)
%% get default input arguments
if isempty(options)
    options.names{1}  = 'Number of discriminant factors)';
    options.values{1} = num2str(nClasses-1);
    options.names{2}   = 'Method type: UncorrelatedFactors (UF) or OrthogonalLoadings (OL)';
    options.values{2} = 'UF';
    options.names{3}   = 'One againts all';
    options.values{3} = '1';
else
    options.values{1} = num2str(options.values{1});
end
options.Resize      = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
answer              = inputdlg(options.names,'MMCLDA Setup',1,options.values,options);
options.values{1}   = str2double(answer{1});
options.values{2}   = answer{2};
options.values{3}   = str2double(answer{3});