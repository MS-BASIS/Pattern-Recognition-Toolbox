function selPCsForRecDR(hSelCheckBox,eventdata)
%% selPCsForRecDR select specific components for reconstructing sample
%% profiles
%% Author: Kirill Veselkov, Imperial College 2011.

DRdata = guidata(hSelCheckBox);

checkBox1State = get(DRdata.h.RecPC(1),'Value');
checkBox2State = get(DRdata.h.RecPC(2),'Value');

if checkBox1State==1&&checkBox2State==1
    DRdata.PCplot.selPCsForRecs = [1 1];
    set(DRdata.h.RecPC(1),'TooltipString',...
        ['Exclude Component #',num2str(DRdata.PCplot.selPCs(1)),' from profile reconstruction'],...
        'Value',1);
    set(DRdata.h.RecPC(2),'TooltipString',...
        ['Exclude Component #',num2str(DRdata.PCplot.selPCs(2)),' from profile reconstruction'],...
        'Value',1);
else
    DRdata.PCplot.selPCsForRecs = ~(DRdata.h.RecPC==hSelCheckBox);
    set(DRdata.h.RecPC(DRdata.PCplot.selPCsForRecs==1),'TooltipString',...
        ['Exclude Component #',num2str(DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1)),' from profile reconstruction'],...
        'Value',1);
    set(DRdata.h.RecPC(DRdata.PCplot.selPCsForRecs==0),'TooltipString',...
        ['Include Component #',num2str(DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==0)),' from profile reconstruction'],...
        'Value',0);
end
DRdata  = updateImagePlotsDR(DRdata);
DRdata  = updateLoadingPlotDR(DRdata);
visible = get(DRdata.h.LoadMapInScores,'Visible');
DRdata  = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
set(DRdata.h.LoadMapInScores,'Visible',visible);
guidata(hSelCheckBox,DRdata);
return;