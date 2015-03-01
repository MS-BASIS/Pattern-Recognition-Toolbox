function DRdata = plotqvaluesBR(DRdata,xlims)
%% plotqvaluesPWCA gives a surface plot of CovXy colourcoded by the vector
%% of q-values
%%   Input: 
%          DRdata - various parameters of comparative statistical analysis
%% Author: Kirill A. Veselkov, Imperial College London
set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(2)); cla;
nVrbls   = length(DRdata.ppm);
if nargin<2
    xlims(1) = 1;
    xlims(2) = nVrbls;
else
    if xlims(1)<1
        xlims(1) = 1;
    end
    if xlims(2)>nVrbls
        xlims(2) = nVrbls;
    end
end
if ishandle(DRdata.h.CBSubP1)
    deleteColorbarDR(DRdata.h.CBSubP1);
end

%% Visualise the surface plot
[ignore,DRdata.h.CBSubP1,DRdata.CB.YTick,DRdata.CB.YTickLbls] = ...
    plotPValues(1:DRdata.nVrbls, DRdata.BR.CovXy',DRdata.BR.qvals,...
    1-DRdata.BR.alpha*1.4,1,[],DRdata.peakPickedData); 

set(DRdata.subplot.h(1),'XLim',xlims);
maxCovXy = max(DRdata.BR.CovXy(xlims(1):xlims(2)));
minCovXy = min(DRdata.BR.CovXy(xlims(1):xlims(2)));
range    = maxCovXy - minCovXy;
ylim([minCovXy-0.1*range maxCovXy+0.1*range]);
xlim(xlims);
[xTickIndcs,xTickLbls]  = getXTickMarks(DRdata.subplot.h(2),DRdata.ppm);
set(gca,'XTick',xTickIndcs);
set(gca,'XTickLabel',xTickLbls);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(2),'Xdir','reverse');
else
    set(DRdata.subplot.h(2),'Xdir','normal');
end
set(gca,'YTickLabel',[]);
ylabel('Covaraince(X,y)','FontSize',DRdata.fontsize.axislabel);
set(gca,'FontSize',DRdata.fontsize.axis);

%% Clean up the colorbar YTick indices and labels
index = find(DRdata.CB.YTick == 1-DRdata.BR.alpha);
if ~isempty(index)
    DRdata.CB.YTick(index)= [];
    DRdata.CB.YTickLbls(index) = [];
end
[ignore,index]               = min(abs(DRdata.CB.YTick - (1-DRdata.BR.alpha))); %#ok<ASGLU>
if index ~= 1
    DRdata.CB.YTick(index)     = [];
    DRdata.CB.YTickLbls(index) = [];
end
YTicks                       = [DRdata.CB.YTick,1-DRdata.BR.alpha];
YTicks(1-YTicks==0)=[];
YTicks                       = sort(YTicks);
YTickLabels                  = getDAandFP(1-YTicks,DRdata.BR.qvals);
set(DRdata.h.CBSubP1,'YTick',YTicks);
set(DRdata.h.CBSubP1,'YTickLabel',YTickLabels,'FontSize',DRdata.fontsize.axis -2);
box on;
set(get(DRdata.h.CBSubP1,'ylabel'),'String', sprintf('FDR q-values'),'FontSize',DRdata.fontsize.axislabel);
%% adjust plot positions
adjustPlotPtns(DRdata.subplot.h(2),DRdata.subplot.h(4));
posCBSubP1 = get(DRdata.h.CBSubP1,'Position');
posCBSubP2 = get(DRdata.h.CBSubP2,'Position');
posCBSubP1(1) = posCBSubP2(1);
set(DRdata.h.CBSubP1,'Position',posCBSubP1);


function YTickLabels = getDAandFP(YTicks,qPeakVls)
nTicks      = length(YTicks);
YTickLabels = cell(1,nTicks);
for iTick = 2:nTicks
    nDE = length(qPeakVls(qPeakVls<=YTicks(iTick)));
    nFP = nDE*YTicks(iTick);
    if nFP <0.01
        YTickLabels{iTick} = sprintf(['q=',num2str(YTicks(iTick)),'(nDE=',num2str(nDE),'; nFP<<',num2str(ceil(nFP))],')');
    else
        if ceil(nFP)==nFP
            YTickLabels{iTick} = sprintf(['q=',num2str(YTicks(iTick)),'(nDE=',num2str(nDE),'; nFP=',num2str(nFP)],')');
        else
            YTickLabels{iTick} = sprintf(['q=',num2str(YTicks(iTick)),'(nDE=',num2str(nDE),'; nFP<',num2str(ceil(nFP)),')']);
        end
    end
end
if YTicks(1)~=YTicks(2)
    YTickLabels{1} = sprintf(['q>',num2str(YTicks(1))]);
end
return;