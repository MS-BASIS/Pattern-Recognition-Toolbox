function temp = getClassIndcs(y,classids);
nClasses = length(classids);
temp    = []; 
for i = 1:nClasses
    indcs = find(y==classids(i));
    temp = [temp indcs];
end

    