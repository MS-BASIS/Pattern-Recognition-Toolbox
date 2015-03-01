function uidoDR(hMainFig,eventdata)
%% uidoDR sets a dimension reduction method 
%    Input: hMainFig - handle of the main figure of DR toolbox
%% Author: Kirill A. Veselkov, Imperial College London, 2011.

DRdata = guidata(hMainFig);
set(DRdata.h.CV,'State','Off');
%% delete all sample ids
if ishandle(DRdata.cv.h.rotatecvlabels)
    delete(DRdata.cv.h.rotatecvlabels);
    DRdata.cv.h.rotatecvlabels = [];
end
if DRdata.pos.showDR == 0
    DRdata            = deleteBRObjects(DRdata);
    DRdata.pos.showBR = 0; 
    DRdata.pos.showDR = 1;
end


DRdata.PCplot.CVScores = 0;
DRdata.PCplot.parallelCoord = 0;
DRdata.method = get(hMainFig,'Tag');
DRdata.test   = [];
if  any(strcmp(DRdata.method,{'PLS','PCALDA','LDAMMC'}))
    if length(DRdata.groupIds) == 1
        display('Error: More than group needs to be specified for supervised dimensionality reduction');
        set(DRdata.h.selDRmethod,'State','on');
        set(hMainFig,'State','off');
        return;
    end
end
if hMainFig~=DRdata.h.selDRmethod
    set(DRdata.h.selDRmethod,'State','off');
    DRdata.h.selDRmethod = hMainFig;    
else
    set(DRdata.h.selDRmethod,'State','on');
end

DRdata = resetparamDR(DRdata);
if strcmp(get(DRdata.h.rotatefactors,'State'),'on')
    delete(DRdata.h.rotateFactorsButtonGroup);
    DRdata.loadings = DRdata.nonrot_loadings;
    DRdata.scores   = DRdata.nonrot_scores;
    DRdata.PCvar    = DRdata.nonrot_PCvar;
    set(DRdata.h.rotatefactors,'State','Off');
end

DRdata.options.setparam = 1;
DRdata = doDR(DRdata);
DRdata = updateAllSubPlots(DRdata);

%% re-adjust PC score plot
guidata(hMainFig,DRdata);