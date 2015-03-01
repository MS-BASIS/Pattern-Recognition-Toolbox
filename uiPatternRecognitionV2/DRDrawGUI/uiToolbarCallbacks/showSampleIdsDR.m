function showSampleIdsDR(hToggleButton,eventdata)
%% showSampleIds switches on or off the visualisation of sample identifiers
%       Input: hToggleButton - toggle button handle
%% Author: Kirill A. Veselkov, Imperial College London

if ~ishandle(hToggleButton)
    DRdata      = hToggleButton;
    hToggleButton = DRdata.h.showSampleIDs;
else
    DRdata      = guidata(hToggleButton);
end
showSampleIDs = get(hToggleButton,'State');
nSmpls        = size(DRdata.Sp,1);
if strcmp(showSampleIDs,'on');
    set(DRdata.subplot.h(3),'YTick',1:nSmpls);
    set(DRdata.subplot.h(3),'YTickLabel',DRdata.sampleIDs);
    set(hToggleButton,'TooltipString','Hide sample identifiers');
    set(DRdata.subplot.h(3),'FontSize',DRdata.fontsize.sampleIds);
else
    ylims = get(DRdata.subplot.h(3),'ylim');
    if ylims(1)<1
        ylims(1) = 1;
    end
    if ylims(2)>nSmpls
        ylims(2)=nSmpls;
    end
    set(DRdata.subplot.h(3),'ylim',ylims);
    [yTickIndcs]       = getXTickMarks(DRdata.subplot.h(3),1:nSmpls,0);
    set(DRdata.subplot.h(3),'YTick',yTickIndcs);
    set(DRdata.subplot.h(3),'YTickLabel',yTickIndcs);
    ylabel(DRdata.subplot.h(3),'Spectra','FontSize',DRdata.fontsize.axislabel);
    set(hToggleButton,'TooltipString','Show sample identifiers'); 
    set(DRdata.subplot.h(3),'FontSize',DRdata.fontsize.axis);
end
return;