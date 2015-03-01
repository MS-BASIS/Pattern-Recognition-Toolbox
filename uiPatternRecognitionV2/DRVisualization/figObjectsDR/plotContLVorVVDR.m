function plotContLVorVVDR(DRdata,values,showVarExplByPCs,xlims,ylims)
%% plotGradLoadMap creates a lineplot object of loadings
%%                 values or PCs-based explained variances of individual
%%                 variables
%                  Input: DRdata - data of dimension reduction objects
%                         values - loadings or explained variable variances
%                         if showVarExpByPCs = 0, then loadings are visualized
%                         xlims  - limits of x axes
%                         ylims  - limits of y axes
%% Author: Kirill A. Veselkov, Imperial College London 2011. 

plot(1:length(DRdata.ppm),values,'LineWidth',DRdata.PCplot.marker.linewidth);
PCs = DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1);
set(DRdata.subplot.h(5),'XLim',xlims);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(5:end),'Xdir','reverse');
else
    set(DRdata.subplot.h(5:end),'Xdir','normal');
end
set(DRdata.subplot.h(5),'XTick',[]);
if length(PCs)<2
    if showVarExplByPCs ==1
        h = legend({sprintf('variable''s variance \n explained by Comp #%s',num2str(PCs(1)))});
    else
        h = legend({['Loadings Comp # ',num2str(PCs(1))]});
    end
else
    if showVarExplByPCs ==1
        h = legend({sprintf('variable''s variance \n explained by Comp \n #%s and #%s',num2str(PCs(1)),...
            num2str(PCs(2)))});
    else
        h = legend({['Loadings Comp # ',num2str(PCs(1))],['Loadings Comp # ',num2str(PCs(2))]});
    end
end
hPos = get(h,'Position');
set(h,'FontSize',DRdata.fontsize.axis-4);
LoadPos = DRdata.LPlot.Pos;
CBPos   = get(DRdata.h.CBSubP2,'Position');
hPos(1) = CBPos(1);
hPos(2) = hPos(2) + LoadPos(4)./3;
set(h,'Position',hPos);

if nargin<5
    ylim(ylims);
end

[nCmpns,cmpndim] = min(size(values));
if nCmpns == 1
    ylims(1) = min(values(xlims(1):xlims(2)));
    ylims(2) = max(values(xlims(1):xlims(2)));
else
    if cmpndim~=2
        values = values';
    end
    ylims(1) = min(min(values(xlims(1):xlims(2),:)));
    ylims(2) = max(max(values(xlims(1):xlims(2),:)));
end
deltay   = (ylims(2)-ylims(1))*0.05;
ylim([ylims(1)-deltay ylims(2)+deltay]);
return;