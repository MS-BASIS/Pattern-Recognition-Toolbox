function selectSamplesDR(hAxis,eventdata)
%% select samples
%     hAxis - axis handle or figure
%% Author: Kirill A. Veselkov
DRdata = guidata(hAxis);
pan  off % swith off pan button
zoom off % swith off zoom button
%set(DRdata.h.LoadMapInScores,'ButtonDown',@selSamplesBoxDR);
set(DRdata.subplot.h(1),'ButtonDown',@selSamplesBoxDR);
return;
