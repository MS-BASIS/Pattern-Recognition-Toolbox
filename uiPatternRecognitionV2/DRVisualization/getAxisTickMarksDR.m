function DRdata = getAxisTickMarksDR(DRdata)
[xTickIndcs,xTickLbls]  = getXTickMarks(DRdata.subplot.h(2),DRdata.ppm);
set(DRdata.subplot.h(2),'XTick',xTickIndcs); set(DRdata.subplot.h(2),'XTickLabel',xTickLbls);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(2),'Xdir','reverse');
else
    set(DRdata.subplot.h(2),'Xdir','normal');
end
set(DRdata.subplot.h(2),'YTickLabel',[]);
ylabel(DRdata.subplot.h(2),'Intensity (a. u.)','FontSize',DRdata.fontsize.axislabel);
%set(gca,'YAxisLocation','Right'); %set(gca,'xAxisLocation','Top');
set(gca,'FontSize',DRdata.fontsize.axis);
return;