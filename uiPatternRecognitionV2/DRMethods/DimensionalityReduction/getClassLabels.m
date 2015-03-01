function [yNumeric,classIds] = getClassLabels(y)
%% getClassLabels transforms a cell vector of class labels into a numeric
%% vector

%  Input:  y        [1xnSmpls]  - cell vector of class labels
%          cmprIds  [1xnCmprns] - identity vector for comparative
%          statistical analysis betweem various experimental conditions
%  Output: yNumeric [1xnSmpls]  - numeric vector of class labels

%% Author: Kirill Veselkov, Imperial College, 2011.

if isnumeric(y)
    y        = num2cell(y);
end

if ~iscellstr(y)
    nSmpls = length(y);
    for iSmpl = 1:nSmpls
        y{iSmpl}  = num2str(y{iSmpl});
    end
    yUnique  =  unique(y);
    nClasses = length(yUnique);
    for iClass = 1:nClasses
        numClassIds(iClass) = str2num(yUnique{iClass});
    end
    numClassIds = sort(numClassIds);
    classIds = cell(1,nClasses);
    for iClass = 1:nClasses
        classIds{iClass} = num2str(numClassIds(iClass));
    end
else
    classIds = unique(y);
    nClasses = length(classIds);
end


yNumeric = zeros(1,length(y));
for iClass = 1:nClasses
    cellIndcs          = strfind(y,classIds{iClass});
    numIndcs           = cellfun(@(x) isequal(x, 1),cellIndcs);
    yNumeric(numIndcs) = iClass;
end
return;