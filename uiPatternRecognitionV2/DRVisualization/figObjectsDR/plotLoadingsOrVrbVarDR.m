function DRdata = plotLoadingsOrVrbVarDR(DRdata,showVarExplByPCs)
%% plotLoadingsOrVrbVarDR creates image or line objects of PC loagins 
%% or individual variable variances explained by the PCs
%       Input: DRdata - data of DR toolbox objects
%% Author: Kirill A. Veselkov, Imperial College London 2011

%%
LoadPos = DRdata.LPlot.Pos; 
PCs     = DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1);

if nargin<2
    showVarExplByPCs =0;
end
classicPlot = get(DRdata.h.swapBetweenImageLVorContLV,'Value');
xlims       = get(DRdata.subplot.h(4),'XLim');

%% Get an image plot of PC loadings or variable variances explained by PCs
if showVarExplByPCs==1 %% visualize variance explained by the PCs
    DRdata.subplot.h(5)  = axes('Position',LoadPos);
    varValues = getVrblVrnsDR(DRdata);
    if classicPlot==1
        plotContLVorVVDR(DRdata,varValues,showVarExplByPCs,xlims,[0 1]);
        return
    else
        imagesc(varValues);
    end
else %% visualize PC loadings
    if classicPlot==1
        DRdata.subplot.h(5) = axes('Position',LoadPos);
        plotContLVorVVDR(DRdata,DRdata.loadings(:,PCs)',showVarExplByPCs,xlims,[0 1]);
        return;
    end
    if length(PCs) < 2
        DRdata.subplot.h(5) = axes('Position',LoadPos);
        imagesc(DRdata.loadings(:,PCs)');
    else
        LoadPos(4)            = LoadPos(4)./2;
        DRdata.subplot.h(6) = axes('Position',LoadPos);
        imagesc(DRdata.loadings(:,PCs(2))');
        LoadPos(2)            = LoadPos(2)+LoadPos(4);
        DRdata.subplot.h(5) = axes('Position',LoadPos);
        imagesc(DRdata.loadings(:,PCs(1))');
    end
    varValues              = DRdata.loadings(:,PCs);
end
maxL                  = max(abs(varValues(:)));

if any(varValues(:)<0)
    set(DRdata.subplot.h(5:end),'CLim',[-maxL maxL])
    colorMap = DRdata.colormap.loadingsPCA;
else
    if showVarExplByPCs==1
        set(DRdata.subplot.h(5:end),'CLim',[0 1]);
    else
        set(DRdata.subplot.h(5:end),'CLim',[0 maxL]);
    end
    colorMap = DRdata.colormap.loadingsNMF;
end

setUniqAxesMap(DRdata.subplot.h(5),colorMap);
 
if length(DRdata.subplot.h(5:end)) == 2
    setUniqAxesMap(DRdata.subplot.h(6),colorMap);
end
CBLoadPos           = getCBPosDR(DRdata);
DRdata.h.CBLoadings = setUniqAxesMap(DRdata.subplot.h(5),colorMap,1,CBLoadPos);
set(DRdata.h.CBLoadings,'FontSize',DRdata.fontsize.axis-2);

if showVarExplByPCs==1
    if length(PCs)<2
        set(get(DRdata.h.CBLoadings,'ylabel'),'String',...
            sprintf('variable variance explained \n by component #%s',num2str(PCs(1))),...
            'FontSize',DRdata.fontsize.axislabel-4);
    else
        set(get(DRdata.h.CBLoadings,'ylabel'),'String',...
            sprintf('variable variance explained \n by components #%s and #%s',num2str(PCs(1)),...
            num2str(PCs(2))),'FontSize',DRdata.fontsize.axislabel-4);
    end
else
    set(get(DRdata.h.CBLoadings,'ylabel'),'String',...
        sprintf('Loadings'),'FontSize',DRdata.fontsize.axislabel-4);
end
set(DRdata.subplot.h(5:end),'XLim',xlims);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(5:end),'Xdir','reverse');
else
    set(DRdata.subplot.h(5:end),'Xdir','normal');
end

set(DRdata.subplot.h(5:end),'XTick',[]);

if showVarExplByPCs==1
    set(DRdata.subplot.h(5:end),'YTick',[]);
else    
    set(DRdata.subplot.h(5),'YTick',1);
    set(DRdata.subplot.h(5),'YTickLabel',['Component #',num2str(PCs(1))],'FontSize',DRdata.fontsize.axislabel-4);
    set(DRdata.subplot.h(5),'YAxisLocation','Right');
    if length(PCs) == 2
        set(DRdata.subplot.h(6),'YTick',1);
        set(DRdata.subplot.h(6),'YTickLabel',['Component #',num2str(PCs(2))],'FontSize',DRdata.fontsize.axislabel-4);
        set(DRdata.subplot.h(6),'YAxisLocation','Right');
    end
end
return;

function CBLoadPos = getCBPosDR(DRdata)
CBSubP2Pos   = get(DRdata.h.CBSubP2,'Position');
SpPos        = get(DRdata.subplot.h(2),'Position');
CBLoadPos(1) = CBSubP2Pos(1);
CBLoadPos(2) = DRdata.LPlot.Pos(2)+DRdata.LPlot.Pos(4)+ SpPos(4)./9;
CBLoadPos(3) = CBSubP2Pos(3)./2;
CBLoadPos(4) = 2.*SpPos(4)./3;