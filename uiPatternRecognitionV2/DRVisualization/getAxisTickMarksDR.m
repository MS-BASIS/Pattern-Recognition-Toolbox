function DRdata = getAxisTickMarksDR(DRdata)
[xTickIndcs,xTickLbls]  = getXTickMarks(DRdata.subplot.h(2),DRdata.ppm);
set(gca,'XTick',xTickIndcs); set(gca,'XTickLabel',xTickLbls);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(2),'Xdir','reverse');
else
    set(DRdata.subplot.h(2),'Xdir','normal');
end
set(gca,'YTickLabel',[]);
ylabel('Intensity (a. u.)','FontSize',DRdata.fontsize.axislabel);
%set(gca,'YAxisLocation','Right'); %set(gca,'xAxisLocation','Top');
set(gca,'FontSize',DRdata.fontsize.axis);
return;