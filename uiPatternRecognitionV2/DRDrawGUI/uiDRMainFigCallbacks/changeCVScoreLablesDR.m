function changeCVScoreLablesDR(hMainFigure,eventdata)
DRdata = guidata(hMainFigure);
DRdata.cv.state  = get(DRdata.h.switchSampleIds ,'Value');

if DRdata.cv.case == 1
    DRdata.cv.case = 2;
    switchCVSampleLabels(DRdata.cv,DRdata);
    set(DRdata.cv.h.rotatecvlabels, 'TooltipString',...
        'Show labels of all sample objects');
elseif DRdata.cv.case == 2
    DRdata.cv.case = 3;
    switchCVSampleLabels(DRdata.cv,DRdata);
    set(DRdata.cv.h.rotatecvlabels, 'TooltipString',...
        'Show sample labels highliting missclassified objects');   
elseif DRdata.cv.case == 3
    DRdata.cv.case = 1;
    switchCVSampleLabels(DRdata.cv,DRdata);
    set(DRdata.cv.h.rotatecvlabels, 'TooltipString',...
        'Show missclassified sample labels only');
end
guidata(hMainFigure,DRdata);
return;
