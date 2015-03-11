function imageSampleIdsDR(DRdata,ylims)
%% plotGradLoadMap creates an image object of sample types
%                  Input: DRdata - data of dimension reduction objects
%                         ylims  - limits of y axes
%% Author: Kirill A. Veselkov, Imperial College London 2011. 

set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(3)); cla;
nSmpls = size(DRdata.X,1);
if nargin<2
     ylims = ([1,nSmpls]);
else
    if ylims(1)<1
        ylims(1) = 1;
    end
    if ylims(2)>nSmpls
        ylims(2) = nSmpls;
    end
end
imagesc(DRdata.groupdata');
ylims = floor(ylims);
set(DRdata.subplot.h(3),'ylim',[ylims(1),ylims(2)]);
set(DRdata.subplot.h(3),'XTick',[]);
set(DRdata.subplot.h(3),'XTickLabel',[]);
showSampleIdsDR(DRdata);
set(DRdata.subplot.h(3),'ylim',[ylims(1)-0.5,ylims(2)+0.5]);
xlims = get(DRdata.subplot.h(3),'XLim');
if ~isempty(DRdata.selsamples)
    nSelSmpls = length(DRdata.selsamples);
    line(xlims, [nSelSmpls+1  nSelSmpls+1],...
            'LineStyle','--','LineWidth',DRdata.SPplot.linewidth+1,...
            'Color',[1 1 1]);
end
setUniqAxesMap(DRdata.subplot.h(3), DRdata.spcolors);