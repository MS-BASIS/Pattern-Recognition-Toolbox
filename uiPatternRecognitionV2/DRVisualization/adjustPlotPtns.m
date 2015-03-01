function delta = adjustPlotPtns(ax1,ax2)
%% Re-adjust the 1-st axis width to match the 2-nd axis width

posAx1    = get(ax1,'Position');
posAx2    = get(ax2,'Position');
posAx1(1) = posAx2(1);
delta     = posAx2(3) - posAx1(3);
posAx1(3) = posAx2(3);
set(ax1,'Position',posAx1);