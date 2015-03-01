function [yOut,sampleIds] = mergeClassesDR(y,yNewIds)
%% merge classes

if iscell(y)
    [yNum,yIds] = getNumClassLabels(y);
    yNumNewIds            = getMergedClassLabels(yIds,yNewIds);
else
    yNum       = y;
    yNumNewIds = yNewIds;
end

nGrps = length(yNumNewIds); % number of merged groups
yOut   = zeros(1,length(yNum));
index  = 1;

for i = 1:nGrps
    nSubGr = length(yNumNewIds{i});
    for j =1:nSubGr
        yOut(yNum==yNumNewIds{i}(j))=index;
    end
    index = index +1;
end
return;    
    
function [yNumeric,classIds,yCell] = getNumClassLabels(y)
%% getClassLabels transforms a cell vector of class labels into a numeric
%% vector
%  Input:  y        [1xnSmpls]  - cell vector of class labels
%  Output: yNumeric [1xnSmpls]  - numeric vector of class labels
%% Author: Kirill Veselkov, Imperial College, 2010.

if isnumeric(y)
    yNumeric = y;
    return;
end

if ~iscellstr(y)
    nSmpls = length(y);
    for iSmpl = 1:nSmpls
        y{iSmpl}  = num2str(y{iSmpl});
    end
end

classIds  = unique(y);
nClasses  = length(classIds);
yNumeric  = zeros(1,length(y));
yCell     = cell(size(y));
index     = 0;
for iClass = 1:nClasses
    cellIndcs          = strfind(y,classIds{iClass});
    numIndcs           = cellfun(@(x) isequal(x, 1),cellIndcs);
    yNumeric(numIndcs) = iClass;
    nIndcs             = sum(numIndcs);
    yCell(index+1:index+nIndcs)  = y(numIndcs);
    index = index + sum(numIndcs);
end
return;

function yNumIds = getMergedClassLabels(yIds,yNewIds)
nGrps   = size(yNewIds,2);
for i = 1:nGrps
    indcs = strfind(yNewIds{i},' ');
    if ~isempty(indcs)
        nSubGr = length(indcs)+1;
        indcs  = [0 indcs length(yNewIds{i})+1];
    else
        nSubGr = 1;
        indcs  = [0 2];
    end
    
    for j =1:nSubGr
        yid         = yNewIds{i}(indcs(j)+1:indcs(j+1)-1);
        cellindex   = strfind(yIds,yid);
        yNumIds{i}(j) = find(cellfun(@(x) isequal(x, 1),cellindex));
    end
end 
return;