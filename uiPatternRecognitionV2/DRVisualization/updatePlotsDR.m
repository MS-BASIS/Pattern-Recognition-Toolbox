function DRdata = updatePlotsDR(DRdata,doubleclick)
%% updatePlotsDR updates score and spectra plot objects
%     Input: DRdata      - data objects of dimension reduction toolbox
%            doubleclick - if yes, double click was initiated
%% Author: Kirill Veselkov, Imperial College London, 2011.

if nargin<2
    doubleclick = 0;
end

if ~isempty(DRdata.selsamples)
    selsamples = getSelectedSpectra(DRdata);
    nonselsamples = ones(1,length(DRdata.h.spectra));
    nonselsamples(selsamples) = 0;
    xlims   = get(DRdata.subplot.h(2),'Xlim');
    if doubleclick ==1
        set(DRdata.h.markers,'markerSize',DRdata.PCplot.marker.size);
        fontSizeMarker = get(DRdata.h.text(1,selsamples(1)),'FontSize');
        set(DRdata.h.text(:,selsamples),'FontWeight','normal');
        set(DRdata.h.text(:),'FontSize',fontSizeMarker-DRdata.PCplot.marker.zoomMarSizeIncrease);
        DRdata.selsamples = [];
        DRdata = plotSpectraRedDR(DRdata,xlims);
        if DRdata.PCplot.CVScores==1
            DRdata = updateIncorrectlyClassScoresDR(DRdata);
            DRdata.cv.state  = get(DRdata.h.switchSampleIds ,'Value');
            switchCVSampleLabels(DRdata.cv,DRdata);
        end
    else
        DRdata = plotSpectraRedDR(DRdata,xlims);
        set(DRdata.h.markers(selsamples),'markerSize',DRdata.PCplot.marker.size...
            + DRdata.PCplot.marker.zoomMarSizeIncrease);
        set(DRdata.h.markers(nonselsamples==1),'markerSize',DRdata.PCplot.marker.size...
            - DRdata.PCplot.marker.zoomMarSizeIncrease);
        set(DRdata.h.text(:,selsamples),'FontWeight','bold', ...
            'FontSize',DRdata.PCplot.marker.fontsize+DRdata.PCplot.marker.zoomMarSizeIncrease);
        set(DRdata.h.text(:,nonselsamples==1),'FontSize',DRdata.PCplot.marker.fontsize-DRdata.PCplot.marker.zoomMarSizeIncrease);
        %set(DRdata.h.spectra(selsamples),'LineWidth', DRdata.SPplot.linewidth...
       %     + DRdata.SPplot.linewitdthIncrease);
    end
end
if ~isempty(DRdata.PCplot.h.legend)
   % set(DRdata.PCplot.h.legobj(1:3:end),'MarkerSize',DRdata.PCplot.marker.size); 
end
return;