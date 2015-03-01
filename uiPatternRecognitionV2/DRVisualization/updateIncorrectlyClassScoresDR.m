function DRdata = updateIncorrectlyClassScoresDR(DRdata)

if ~isempty(DRdata.PCplot.spIndcs)
    % only select maximum allowable spectra for visualization
    groupdata = DRdata.groups(DRdata.PCplot.spIndcs);
    predclass = DRdata.cv.predclass(DRdata.PCplot.spIndcs);
else
    groupdata = DRdata.groups;
    predclass = DRdata.cv.predclass;
end

missClassIndcs = find(predclass~=groupdata');
missClasses  = unique(predclass(missClassIndcs))';
index = 1;
ilegindex = 1;
for iClass = missClasses
    iMissClassIndcs = (predclass(missClassIndcs) == iClass);
    targIndcs       = missClassIndcs(iMissClassIndcs)';
    for scoreIndex = targIndcs
        XData   = get(DRdata.h.markers(:,scoreIndex),'XData');
        YData   = get(DRdata.h.markers(:,scoreIndex),'YData');
        hold on;
        DRdata.h.misclass(index) = line(XData,YData,'Marker',DRdata.PCplot.marker.type{iClass},...
            'MarkerEdgeColor',DRdata.marker.color{iClass},'LineStyle','none',...
            'MarkerSize',DRdata.PCplot.marker.size +DRdata.PCplot.marker.sizeIncrease+1);
        index = index+1;
    end
    DRdata.PCplot.h.mislegend(ilegindex)  = DRdata.h.misclass(index-1);
    DRdata.PCplot.mislegendids{ilegindex} = strcat(['Incorrectly classified into ',DRdata.groupIds{iClass},' group']);
    ilegindex = ilegindex + 1; 
    set(DRdata.h.text(:,targIndcs),'EdgeColor',DRdata.marker.color{iClass});
end
%hold off
%set(DRdata.h.markers(predclass~=DRdata.groupdata'),'markerSize',...
%    DRdata.PCplot.marker.fontsize+DRdata.PCplot.marker.zoomMarSizeIncrease);
set(DRdata.h.markers(:,predclass==groupdata'),'markerSize',...
    DRdata.PCplot.marker.fontsize-DRdata.PCplot.marker.zoomMarSizeIncrease);
set(DRdata.h.text(:,predclass==groupdata'),'FontSize',...
    DRdata.PCplot.marker.fontsize-DRdata.PCplot.marker.zoomMarSizeIncrease);
return;