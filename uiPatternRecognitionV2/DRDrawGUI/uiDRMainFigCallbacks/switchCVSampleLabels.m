function DRdata = switchCVSampleLabels(cv,DRdata)
%% missclassified only
if ~isempty(DRdata.PCplot.spIndcs)
    % only select maximum allowable spectra for visualization
    groupdata = DRdata.groups(DRdata.PCplot.spIndcs);
    predclass = DRdata.cv.predclass(DRdata.PCplot.spIndcs);
else
    groupdata = DRdata.groups;
    predclass = DRdata.cv.predclass;
end

if cv.case == 2 %% missclassified samples
    set(DRdata.h.text,'Visible','off');
    set(DRdata.h.markers,'Visible','off');
    if cv.state==0
        set(DRdata.h.misclass,'Visible','on');
        set(DRdata.h.markers(predclass~=groupdata'),'Visible','on');
    else
        set(DRdata.h.text(:,predclass~=groupdata'),'Visible','on');
        set(DRdata.h.misclass,'Visible','off');
    end
elseif cv.case == 3 %% all samples
    set(DRdata.h.misclass,'Visible','off');
    if cv.state==0
        set(DRdata.h.markers,'Visible','on');
        set(DRdata.h.text,'Visible','off');
    else
        set(DRdata.h.text,'Visible','on');
        set(DRdata.h.misclass,'Visible','off');
        set(DRdata.h.markers,'Visible','off');
    end
    set(DRdata.h.markers,'MarkerSize',...
        DRdata.PCplot.marker.size);
    set(DRdata.h.text,'FontSize',...
        DRdata.PCplot.marker.fontsize);
elseif cv.case == 1 %% all samples 
    set(DRdata.h.markers(predclass==groupdata'),'markerSize',...
        DRdata.PCplot.marker.size-DRdata.PCplot.marker.zoomMarSizeIncrease);
    set(DRdata.h.text(:,predclass==groupdata'),'FontSize',...
        DRdata.PCplot.marker.fontsize-DRdata.PCplot.marker.zoomMarSizeIncrease);
    if cv.state==0
        set(DRdata.h.markers,'Visible','on');
        set(DRdata.h.text,'Visible','off');
        set(DRdata.h.markers(predclass~=groupdata'),'MarkerSize',...
        DRdata.PCplot.marker.size);
        set(DRdata.h.misclass,'Visible','on');
    else
        set(DRdata.h.markers,'Visible','off');
        set(DRdata.h.text,'Visible','on');
        set(DRdata.h.misclass,'Visible','off');
    end    
end
if ~isempty(DRdata.PCplot.h.legend)
    set(DRdata.PCplot.h.legobj(1:3:end),'MarkerSize',DRdata.PCplot.marker.size); 
end
DRdata = updatePlotsDR(DRdata);
return