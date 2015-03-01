function zoomcallbackDR2(obj,axes)
%% zoomcallback: Synchronize zoom events of dimension reduction toolbox objects
%       Input: obj  - figure handle
%              axes - axes handle
%% Author: Kirill Veselkov, Imperial College London 2011
DRdata          = guidata(obj);
[nSmpls,nVrbls] = size(DRdata.Sp);
double_click    = strcmp(get(obj,'SelectionType'),'open');
SubPlotIndex    = find(DRdata.subplot.h==axes.Axes);

if (SubPlotIndex == 1)
    if (double_click==1)
        xlim(DRdata.PCplot.xlims);
        ylim(DRdata.PCplot.ylims);
    end
    
elseif(SubPlotIndex == 2)||(SubPlotIndex == 5)||(SubPlotIndex==6) %% i.e. spectral profile
 %  set(gcf,'Visible','on');
    if (double_click==1)
        xlims = [1 DRdata.nVrbls];
        set(DRdata.subplot.h(SubPlotIndex),'xlim',xlims);
    else
        xlims = get(DRdata.subplot.h(SubPlotIndex),'xlim');
    end
    % check if we need to change a resolution for plotting. If not, then we
    % can get away just with chaning limits for x and y axes
    [xlims]   = getSpAxisLimitsDR(DRdata,xlims);
    nDPs            = sum((DRdata.ppm<DRdata.ppm(xlims(2)))&(DRdata.ppm>DRdata.ppm(xlims(1))));
    redRatio        = dataRedRatio(nDPs); temp = DRdata.redRatio; 
    DRdata.redRatio = redRatio; redRatio = temp;
    [xlims,ylims]   = getSpAxisLimitsDR(DRdata,xlims);
    
    % axislims  = adjustAxisLimsDR(DRdata,DRdata.subplot.h(SubPlotIndex),...
    %    DRdata.subplot.h(4:end),'XLim');
    if DRdata.pos.showBR == 0 || strcmp(get(DRdata.h.swapCovXyOrSp,'State'),'on')
        %     if DRdata.redRatio ~=redRatio
        if redRatio==DRdata.redRatio;
            set(DRdata.subplot.h(2),'XLim',xlims,'YLim',ylims);
            DRdata = getAxisTickMarksDR(DRdata);
        else
            DRdata = plotSpectraRedDR(DRdata,xlims,ylims);
        end
        %    end
        updatePlotsDR(DRdata);
    else
        DRdata = updatePQRplot(DRdata,xlims);
    end
    if redRatio~=DRdata.redRatio;
        ylims  = get(DRdata.subplot.h(4),'ylim');
        DRdata = updateImagePlotsDR(DRdata,xlims,ylims);
    end
    set(DRdata.subplot.h(4),'XLim',xlims);
  %  set(gcf,'Visible','on');
  
    if (SubPlotIndex == 2)
        DRdata = updateLoadingPlotDR(DRdata,xlims);
    else
        set(DRdata.subplot.h(5:end),'XLim',xlims);
    end
elseif (SubPlotIndex == 4) %% i.e. metabolic map of samples
    
    if (double_click==1)
        xlims    = [1 nVrbls];
        ylimsMap = [1 nSmpls];     
    else        
        ylimsMap  = get(DRdata.subplot.h(4),'ylim');
        xlims     = get(DRdata.subplot.h(SubPlotIndex),'xlim');
    end
    [xlims]   = getSpAxisLimitsDR(DRdata,xlims);
    nDPs            = sum((DRdata.ppm<DRdata.ppm(xlims(2)))&(DRdata.ppm>DRdata.ppm(xlims(1))));
    redRatio        = dataRedRatio(nDPs,DRdata.subplot.h(2)); temp = DRdata.redRatio; 
    DRdata.redRatio = redRatio; redRatio = temp;
    [xlims,ylims]   = getSpAxisLimitsDR(DRdata,xlims);
    
    if DRdata.pos.showBR == 0 || strcmp(get(DRdata.h.swapCovXyOrSp,'State'),'on')
        if redRatio==DRdata.redRatio;
            set(DRdata.subplot.h(2),'XLim',xlims,'YLim',ylims);
            DRdata = getAxisTickMarksDR(DRdata);
        else
            DRdata = plotSpectraRedDR(DRdata,xlims,ylims);
        end
        updatePlotsDR(DRdata);
    else
        DRdata = updatePQRplot(DRdata,xlims);
    end
    if redRatio~=DRdata.redRatio;
        DRdata = updateImagePlotsDR(DRdata,xlims,ylimsMap);
    end
    set(DRdata.subplot.h(4),'XLim',xlims);
    imageSampleIdsDR(DRdata,ylimsMap);
    DRdata = updateLoadingPlotDR(DRdata,xlims);

    
elseif (SubPlotIndex == 3) %% i.e. map of sample identifiers
    
    if (double_click==1)
        ylims = [1 nSmpls];
    else
        ylims = get(DRdata.subplot.h(3),'ylim');
    end
    xlims    = get(DRdata.subplot.h(2),'xlim');
    DRdata = updateImagePlotsDR(DRdata,xlims,ylims);
    imageSampleIdsDR(DRdata,ylims);
    updatePlotsDR(DRdata);
end

guidata(DRdata.h.figure,DRdata);
return;