function deleteColorbarDR(hCB)
% delete axis specific colobar depending on the matlab version

matver = version;
% if matlab version R2014b or older the colormap can be specific to axes
if str2num(matver(1:3))>=8.4
    nObjects = length(hCB);
    for iObj = 1:nObjects
        if ishandle(hCB(iObj))
            if strcmp(get(hCB(iObj),'type'),'colorbar');
                delete(hCB);
            end
        end
    end    
else
    cbfreeze(hCB,'del')
end
return;