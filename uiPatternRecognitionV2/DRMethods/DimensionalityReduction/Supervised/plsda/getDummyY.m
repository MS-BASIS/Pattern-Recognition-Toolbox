function ydummy = getDummyY(y,center)

nObs     = length(y);
classIds = unique(y);
nClasses = length(classIds);
ydummy   = zeros(nObs,nClasses);

for i = 1:nClasses
    classinds           =  y == classIds(i);
    ydummy(classinds,i) = 1;  
end

if strcmp(center,'yes')
    ydummy = scaleDataSet(ydummy,'yes','no');
end
return; 