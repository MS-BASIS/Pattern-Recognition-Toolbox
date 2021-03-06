function uidoSTOCSY(hObject,h2)
%% doStocsy: user interface statistical total correlation spectroscopy (STOCSY)
%           Input: hObject - Figure Handle 
%% Author: Kirill A. Veselkov, Imperial College London 2010

DRdata    = guidata(hObject);
smplIndcs = get(DRdata.subplot.h(4),'YLim');
y         = ceil(smplIndcs(1)):floor(smplIndcs(2));
y(y<1)    = []; y(y>DRdata.nSmpls) = [];  
[peakID]  = ginput(1);
if ~isempty(DRdata.selsamples)
    selIndcs  = DRdata.selIndcs;
elseif ~isempty(DRdata.spsortindcs)
    selIndcs = DRdata.spsortindcs;
else
    selIndcs  = 1:size(DRdata.X,1);
end

if length(y) > 4
    [hSTOCSY,CovXy] = STOCSY(DRdata.Sp(selIndcs(y),:),DRdata.X(y,:),DRdata.ppm,DRdata.ppm(round(peakID(1))),...
        DRdata.stocsy.pThr,DRdata.stocsy.cc,DRdata.peakPickedData, DRdata);
else
    display('The sample size must no less than five to perform STOCSY analysis');
end
[xTickIndcs,xTickLbls] = getXTickMarks(gca,DRdata.ppm);
set(gca,'XTick',xTickIndcs);
set(gca,'XTickLabel',xTickLbls);
%set(gca,'Xdir','reverse');

hZoom = zoom(gca); set(hZoom,'Enable','on');
set(hZoom,'ActionPostCallback',{@zoomcallbackSTOCSY,DRdata.ppm,CovXy,...
        DRdata.SPplot.xreverse}); % set callback for zoom events

%function zoomcallbackSTOCSY(hSTOCSY,eventdata)
%ppm                    = guidata(hSTOCSY);
%[xTickIndcs,xTickLbls] = getXTickMarks(gca,ppm);
%set(gca,'XTick',xTickIndcs);
%set(gca,'XTickLabel',xTickLbls);