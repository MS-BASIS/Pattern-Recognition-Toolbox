function swithSampleIdsDR(hMainFigDR,eventdata)
%% swithSampleIdsDR swaps between text and marker labels of sample scores
%              Input: hMainFigDR - a handle of the DR toolbox main figure
%% Author: Kirill Veselkov, Imperial College 2011
if ishandle(hMainFigDR)
    DRdata = guidata(hMainFigDR);
else
    DRdata = hMainFigDR;
end
xlims    = get(DRdata.subplot.h(1),'XLim');
ylims    = get(DRdata.subplot.h(1),'YLim');
state    = get(DRdata.h.switchSampleIds ,'Value');

if state == 1
    set(DRdata.h.switchSampleIds,'TooltipString','Show text labels');
    set(DRdata.h.text,'Visible','on');
    set(DRdata.h.markers,'Visible','off');
    if ~isempty(DRdata.h.misclass)
        DRdata.cv.state = state;
        DRdata = switchCVSampleLabels(DRdata.cv,DRdata);
    end
else
    set(DRdata.h.switchSampleIds,'TooltipString','Show marker labels');
    set(DRdata.h.markers,'Visible','on');
    set(DRdata.h.text,'Visible','off');
    if ~isempty(DRdata.h.misclass)
        DRdata.cv.state = state;
        DRdata = switchCVSampleLabels(DRdata.cv,DRdata);
    end   
end
set(DRdata.subplot.h(1),'XLim',xlims);
set(DRdata.subplot.h(1),'YLim',ylims);
%updatePlotsDR(DRdata);