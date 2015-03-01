function hrec = drawRectangleDR(DRdata)

selRegns = DRdata.SPplot.regions.bndrs;
if isempty(selRegns)
    hrec = [];
    return;
end

ylims    = get(DRdata.subplot.h(2),'YLim');
delta    = (ylims(2)-ylims(1))*0.05;
ylims(1) = ylims(1) + delta;
ylims(2) = ylims(2) - delta;
nSegs    = size(selRegns,2);
if strcmp(get(DRdata.h.figure,'Renderer'),'OpenGL')
    for iSeg = 1:nSegs
        hrec(iSeg) = rectangle('Position',[selRegns(1,iSeg) ylims(1) selRegns(2,iSeg)-selRegns(1,iSeg) ylims(2)-ylims(1)],...
            'FaceColor',DRdata.SPplot.regions.color);
    end
else
    for iSeg = 1:nSegs
        hrec(iSeg) = rectangle('Position',[selRegns(1,iSeg) ylims(1) selRegns(2,iSeg)-selRegns(1,iSeg) ylims(2)-ylims(1)],...
            'LineStyle','--','LineWidth',DRdata.SPplot.linewidth+DRdata.SPplot.linewitdthIncrease,...
            'EdgeColor',DRdata.SPplot.regions.color,'FaceColor','none');
    end
end
return;