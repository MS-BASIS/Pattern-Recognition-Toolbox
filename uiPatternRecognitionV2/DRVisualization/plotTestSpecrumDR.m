function plotTestSpecrumDR(DRdata,updateScatter,updateLinePlot,xlims)
if nargin<3
    updateLinePlot = 0;
end

if updateScatter == 1
    set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(1));
    if length(DRdata.PCplot.selPCs)==3
        hold on;
        DRdata.test.h = line(DRdata.test.scores(DRdata.PCplot.selPCs(1)),DRdata.test.scores(DRdata.PCplot.selPCs(2)),...
            DRdata.test.scores(DRdata.PCplot.selPCs(3)),'Color', [0 0 0], 'Marker','p','LineStyle','none','markerSize',...
            DRdata.PCplot.marker.size + DRdata.PCplot.marker.zoomMarSizeIncrease+4,'MarkerFaceColor',...
            DRdata.spcolors(DRdata.test.class,:));
        hold off;
    else
        hold on;
        DRdata.test.h = line(DRdata.test.scores(DRdata.PCplot.selPCs(1)),DRdata.test.scores(DRdata.PCplot.selPCs(2)),...
            'Color', [0 0 0], 'Marker','p','LineStyle','none','markerSize',...
            DRdata.PCplot.marker.size+ DRdata.PCplot.marker.zoomMarSizeIncrease+4,...
            'MarkerFaceColor',DRdata.spcolors(DRdata.test.class,:));
        hold off;
    end    
end

if updateLinePlot == 1
    set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(2));
    nDPs = sum((DRdata.ppm<DRdata.ppm(xlims(2)))&(DRdata.ppm>DRdata.ppm(xlims(1))));
    if nDPs>DRdata.ppmresolution/(abs(DRdata.ppm(1)-DRdata.ppm(2)))
        selIndBins = (DRdata.indBins>=xlims(1)&DRdata.indBins<=xlims(2));
        DRdata.test.hSp = line(single(DRdata.indBins(selIndBins)),...
            single(DRdata.test.SpRed(selIndBins)), ...
            'Color',DRdata.spcolors(DRdata.test.class,:),...
            'LineWidth',DRdata.SPplot.linewidth+ DRdata.SPplot.zoomLinewidthIncrease+2);
    else
        DRdata.test.hSp = line(single(xlims(1):xlims(2)),...
            single(DRdata.test.Sp(xlims(1):xlims(2))), ...
            'Color', DRdata.spcolors(DRdata.test.class,:),...
            'LineWidth',DRdata.SPplot.linewidth+ DRdata.SPplot.zoomLinewidthIncrease+2);
    end
    h = legend(DRdata.test.hSp,[DRdata.test.FileName, ' classified into ',DRdata.groupIds{DRdata.test.class}],...
        'FontSize',DRdata.fontsize.title,'Location','NorthWest', 'Box', 'off');
    set(h,'Interpreter', 'none')
    legend boxoff;
    set(DRdata.h.spectra(DRdata.selsamples),'LineWidth',DRdata.SPplot.linewidth);
end