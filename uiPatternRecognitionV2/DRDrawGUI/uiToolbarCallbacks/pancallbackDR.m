function pancallbackDR(obj,axes)
%% pancallback: Synchronize pan events of DR objects
%       Input: obj  - figure handle
%              axes - axes handle
%% Author: Kirill Veselkov, Imperial College London 2011

DRdata        = guidata(obj);
SubPlotIndex    = find(DRdata.subplot.h==axes.Axes);
if (SubPlotIndex == 2)
    xlims = get(DRdata.subplot.h(2),'xlim');
    plotSpectraDR(DRdata,xlims);
    imageSampleIdsDR(DRdata,xlims);
elseif (SubPlotIndex == 4)
    xlims = get(DRdata.subplot.h(4),'xlim');
    ylims = get(DRdata.subplot.h(4),'ylim');
    plotSpectraDR(DRdata,xlims);
    plotMetabolicMapDR(DRdata,xlims,ylims);
    imageSampleIdsDR(DRdata,ylims);
end

[xTickIndcs,ppmTicks] = getXTickMarks(DRdata.subplot.h(2),DRdata.ppm);
set(DRdata.subplot.h(2),'XTick',[]);           
set(DRdata.subplot.h(2),'XTick',xTickIndcs);
set(DRdata.subplot.h(2),'XTickLabel',ppmTicks);
set(DRdata.subplot.h(4),'XTick',[]);
set(DRdata.subplot.h(4),'XTick',xTickIndcs);