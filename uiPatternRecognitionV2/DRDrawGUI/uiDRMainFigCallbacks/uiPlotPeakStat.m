function uiPlotPeakStat(hObject,eventdata)
%% 
DRdata        = guidata(hObject);
peakID        = ginput(1);
peakID        = round(peakID);

plotparam.fontsize = DRdata.fontsize;
plotparam.xlabel   = DRdata.SPplot.xlabel;
plotparam.grpIds   = DRdata.groupIds;
if ~any(strcmp(fieldnames(DRdata),'BR'));
    plotPeakStatDR(DRdata.X(:,peakID(1)),DRdata.groupdata, [], DRdata.ppm(peakID(1)),...
        DRdata.spcolors,DRdata.PCplot.marker,plotparam);
else
    plotPeakStatDR(DRdata.X(:,peakID(1)),DRdata.groupdata, DRdata.BR.pvalues(peakID(1)), DRdata.ppm(peakID(1)),...
        DRdata.spcolors,DRdata.PCplot.marker,plotparam,DRdata.BR.method);
end
return;    