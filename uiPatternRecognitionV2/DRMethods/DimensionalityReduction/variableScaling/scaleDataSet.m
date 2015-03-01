function [X,meanX,scaleX] = scaleDataSet(X,center,scale)
%% centerScaleSet performs centering of variables to have zero
%% mean followed by univariate or pareto scaling
%         X       -  data set [samples x variables]
%         center  - {'yes' or 'no'} if 'yes', substracts the mean value from each variable
%         scale   - {'uv' or 'par'} divides each variable by its standard deviation {'uv'} 
%                                   or by the square root of its standard deviation {'par'}
%% Author: Kirill A. Veselkov, Imperial College 2011.

[nObs,nVar] = size(X);
if isnumeric(center)||isnumeric(scale)
    if ~isempty(center)
        if nVar == 1
            X = X - center;
        else
            X = X - center(ones(1,nObs),:);
        end
    end
    if ~isempty(scale)
        if nVar == 1
            X = X./scale;
        else
            X = X./scale(ones(1,nObs),:);
        end
    end
    return;
end

meanX  = [];
if strcmp(center,'yes')
    meanX = mean(X);
    if nVar == 1
        X = X - meanX;
    else
        X = X - meanX(ones(1,nObs),:);
    end
end
scaleX = [];
if strcmp(scale,'no')
    return;
else
    if strcmp(scale,'uv')
        scaleX = std(X);
    elseif strcmp(scale,'par')
        scaleX = sqrt(std(X));
    end
    if nVar == 1
        X = X./scaleX;
    else
        X = X./scaleX(ones(1,nObs),:);
    end
end
return;