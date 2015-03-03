function modifyVarNameInMCode(filename,curvar,newvar)
%% import file
datafile = importdatafile(filename);
nLines   = length(datafile);

%% change variable name
curVarLength = length(curvar);
newVarLength = length(newvar);
for iLine = 1:nLines
    curstring = datafile{iLine};
    indices     = strfind(curstring,curvar);
    while ~isempty(indices)
        index      = indices(1);
        if ~isempty(index)
            lengthcurstr = length(curstring);
            curstring(index:index+curVarLength-1) = []; %% delete a current variable name
            if index==1
                curstring = [newvar curstring]; % variable in the beginning of the line code
            elseif index+curVarLength-1==lengthcurstr; 
                curstring = [curstring newvar]; % variable in the end of the line code
            else
                curstring = [curstring(1:index-1) newvar curstring(index:end)];
            end
        end
        indices      = strfind(curstring,curvar);
    end
    datafile{iLine} =curstring;
end
exportdatafile(datafile,filename);
return;

%% Exctract matlab code from a file
function datafile = importdatafile(filename)
%  importdatafile(filename) loads data from file into the workspace.

fid   = fopen(filename);
tline = fgetl(fid);

index = 1;
while ischar(tline)
    datafile{index} = tline;
    tline           = fgetl(fid);
    index           = index+1;
end
fclose(fid);
return;

%% Save modified code into a file
function exportdatafile(data,filename)
% exportdatafile(data,filename) saves modified matlab code saved in the workspace
% into a file
fid    = fopen(filename,'w');
nLines = length(data);

for iLine =1:nLines-1
    fprintf(fid, '%s\n', data{iLine});
end
fprintf(fid, '%s', data{nLines});
fclose(fid);