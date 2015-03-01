function uishowParCoordDR(hParCoordButton,eventdata)
%% showSampleIds switches on or off the visualisation of sample identifiers
%       Input: hToggleButton - toggle button handle
%% Author: Kirill A. Veselkov, Imperial College London

DRdata      = guidata(hParCoordButton);

if DRdata.PCplot.parallelCoord == 0
    DRdata.PCplot.parallelCoord = 1;
    DRdata.PCplot.selPCs(1) = 1;
    DRdata.PCplot.selPCs(2) = min(size(DRdata.scores,2),4);
else
    DRdata.PCplot.parallelCoord = 0;
    DRdata.PCplot.selPCs(1) = 1;
    DRdata.PCplot.selPCs(2) = 2;
end
DRdata = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
DRdata = choosePCsDR(DRdata);
swithSampleIdsDR(DRdata);
guidata(hParCoordButton,DRdata);