function DRdata = updateImagePlotsDR(DRdata,xlims,ylims)
%% updateImagePlotsDR after actions performed on a figure

% get all required parameters from the current image object
clims    = DRdata.image.clims;
if nargin<2
    xlims    = get(DRdata.subplot.h(2),'XLim');
end
if nargin<3
    ylims    = get(DRdata.subplot.h(3),'YLim');
end

DRdata      = plotMetabolicMapDR(DRdata,xlims,ylims);
set(DRdata.subplot.h(4),'CLim',clims);

return;