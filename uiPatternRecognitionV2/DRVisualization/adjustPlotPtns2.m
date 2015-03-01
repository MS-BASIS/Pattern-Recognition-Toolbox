function adjustPlotPtns2(ax1,ax2)
%% Re-adjust the 1-st axis width to match the 2-nd axis width

posAx1    = get(ax1,'Position');
posAx2    = get(ax2,'Position');
posAx1(2) = posAx2(2);
posAx1(4) = posAx2(4);
set(ax1,'Position',posAx1);