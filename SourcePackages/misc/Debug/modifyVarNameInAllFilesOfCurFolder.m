function modifyVarNameInAllFilesOfCurFolder(curvarnames,newvarnames)

filenames = dir();
nFiles    = length(filenames);
nVars     = length(curvarnames);
for iFile = 3:nFiles
    filename = filenames(iFile).name;
    for jVar = 1:nVars
        modifyVarNameInMCode(filename,curvarnames{jVar},newvarnames{jVar});
    end
    disp(sprintf('%s has been processed...',filename));
end
return