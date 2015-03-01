function uishow3DplotDR(hParCoordButton,eventdata)
%% showSampleIds switches on or off the visualisation of sample identifiers
%       Input: hToggleButton - toggle button handle
%% Author: Kirill A. Veselkov, Imperial College London

DRdata      = guidata(hParCoordButton);

if DRdata.PCplot.plot3D == 0
    DRdata.PCplot.plot3D = 1;
    DRdata.PCplot.selPCs(1) = 1;
    DRdata.PCplot.selPCs(2) = 2;
    DRdata.PCplot.selPCs(3) = 3;
else
    DRdata.PCplot.plot3D = 0;
    DRdata.PCplot.selPCs(1) = 1;
    DRdata.PCplot.selPCs(2) = 2;
    DRdata.PCplot.selPCs(3) = [];
end
DRdata = scatter2D(DRdata);
DRdata = choosePCsDR(DRdata);
swithSampleIdsDR(DRdata);
guidata(hParCoordButton,DRdata);