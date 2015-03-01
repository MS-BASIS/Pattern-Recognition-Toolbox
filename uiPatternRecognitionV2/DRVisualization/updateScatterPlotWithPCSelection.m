function updateScatterPlotWithPCSelection(hMainFigDR,eventdata)
%% updateScatterPlotWithPCSelection updates scatter plot when different PCs
%%                                  are selected
%       Input:  hMainFigDR - a handle of the DR toolbox main figure
%% Author: Kirill A. Veselkov, Imperial College London, 2011

DRdata = guidata(hMainFigDR);
DRdata.PCplot.selPCs(1) = str2double(get(DRdata.h.choosePCs(3),'String'));
DRdata.PCplot.selPCs(2) = str2double(get(DRdata.h.choosePCs(4),'String'));
if length(DRdata.PCplot.selPCs)==3
    DRdata.PCplot.selPCs(3) = str2double(get(DRdata.h.choosePCs(6),'String'));
end
ncomp = size(DRdata.scores,2);
if length(unique(DRdata.PCplot.selPCs))~=length(DRdata.PCplot.selPCs)
    return;   
elseif any(DRdata.PCplot.selPCs>ncomp)
    return;   
end

DRdata.PCplot.selPCs    = sort(DRdata.PCplot.selPCs);
visible = get(DRdata.h.LoadMapInScores,'Visible');
if length(DRdata.PCplot.selPCs)==3
    DRdata = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2),...
        DRdata.PCplot.selPCs(3));
else
    DRdata = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
end
if ~isempty(visible)
    set(DRdata.h.LoadMapInScores,'Visible',visible);
end
swithSampleIdsDR(DRdata);
DRdata.PCplot.selPCsForRecs = [1 1];
set(DRdata.h.RecPC(1),'TooltipString',...
    ['Exclude Component #',num2str(DRdata.PCplot.selPCs(1)),' from profile reconstruction'],...
    'Value',1);
set(DRdata.h.RecPC(2),'TooltipString',...
    ['Exclude Component #',num2str(DRdata.PCplot.selPCs(2)),' from profile reconstruction'],...
    'Value',1);
DRdata = updateImagePlotsDR(DRdata);
DRdata = updateLoadingPlotDR(DRdata);
%DRdata = choosePCsDR(DRdata);
guidata(hMainFigDR,DRdata);
return;