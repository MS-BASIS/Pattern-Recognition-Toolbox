function uiDefineRegnsForLocalPC(hMainFigure,eventdata)
%% uiDefineRegnsForLocalPC sets regions for local PCA
% Input: 
%                   hMainFigre - the figure handle 
%% Author: Kirill A. Veselkov, Imperial College London 2011

DRdata      = guidata(hMainFigure);
[x,y]       = ginput(2);
currbndrs   = sort(x); %% get user selected regions
if ~isempty(DRdata.SPplot.regions.bndrs)
    currbndrs                   = checkRegBndrs(DRdata.SPplot.regions.bndrs,currbndrs);
    if isempty(currbndrs)
        return;
    end
end
DRdata.SPplot.regions.bndrs = currbndrs;
if ishandle(DRdata.h.PCregions)
    delete(DRdata.h.PCregions);
    DRdata.h.PCregions=[];
else
    DRdata.h.PCregions=[];
end
DRdata.h.PCregions = drawRectangleDR(DRdata);
guidata(hMainFigure,DRdata);

function bndrs = checkRegBndrs(bndrs,currbndrs)
nRegs = size(bndrs,2); % overall number of regions
segDelidcs =[];
for iReg = 1:nRegs
    if currbndrs(1)<bndrs(1,iReg)&&currbndrs(2)>bndrs(2,iReg)
        segDelidcs = [segDelidcs iReg];
    end
end
if ~isempty(segDelidcs)
    bndrs(:,segDelidcs)=[];
end

if ~isempty(bndrs)
    nRegs = size(bndrs,2); % overall number of regions after deletion
    for iReg = 1:nRegs
        %% Re-adjust: the segment left border is a part of the other segment
        if (bndrs(1,iReg)<currbndrs(1))&&(bndrs(2,iReg)>currbndrs(1))
            if currbndrs(2)> bndrs(2,iReg)
                bndrs(2,iReg) = currbndrs(2);
                return;
            else
                bndrs = [];
                return
            end
        end
        %% Re-adjust: the segment right border is a part of the other segment
        if (bndrs(1,iReg)<currbndrs(2))&&(bndrs(2,iReg)>currbndrs(2))
            if currbndrs(1)< bndrs(1,iReg)
                bndrs(1,iReg) = currbndrs(1);
                return;
            else
                bndrs = [];
                return
            end
        end
    end
end
    
bndrs = [bndrs currbndrs];
return;