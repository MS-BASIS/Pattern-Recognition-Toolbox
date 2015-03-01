function uidoCV(hMainFig,eventdata)
%% uidoDR sets a dimension reduction method
%    Input: hMainFig - handle of the main figure of DR toolbox
%% Author: Kirill A. Veselkov, Imperial College London, 2011.



DRdata = guidata(hMainFig);
if strcmp(get(hMainFig,'State'),'off')
    DRdata.PCplot.CVScores = 0;
    DRdata.selsamples    = [];
    DRdata.spsortindcs   = [];
    if ~isempty(DRdata.sortSelIndcs)
        DRdata.X              = DRdata.X(DRdata.sortSelIndcs,:);
        DRdata.groupdata      = DRdata.groupdata(DRdata.sortSelIndcs);
        DRdata.sampleIDs      = DRdata.sampleIDs(DRdata.sortSelIndcs);
        DRdata.sortSelIndcs   = [];
    end
    if ~isempty(DRdata.cv.h.rotatecvlabels)
        delete(DRdata.cv.h.rotatecvlabels);
        DRdata.cv.h.rotatecvlabels = [];
    end
    DRdata = updateAllSubPlots(DRdata);
else
    switch DRdata.object
        case 'Supervised'
            uiCVMenuSupervised(hMainFig)
        case 'Unsupervised'
            DRdata = uiBiCrossValidation(DRdata);
    end
end
guidata(hMainFig,DRdata);
return;