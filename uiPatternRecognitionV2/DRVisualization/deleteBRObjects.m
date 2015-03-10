function DRdata = deleteBRObjects(DRdata)

%% Inactivate DR buttons
set(DRdata.h.DRLocalTBOutMap,'Enable','On');
set(DRdata.h.showLoadingPlot,'Enable','On')
set(DRdata.h.rotatefactors,'Enable','On');
%set(DRdata.h.SpOrder,'Enable','On');
set(DRdata.h.CV,'Enable','On');
if ishandle(DRdata.h.CBSubP1)
    delete(DRdata.h.CBSubP1);
    DRdata.h.CBSubP1 = [];
end

%% Hide scatter plots buttons
set(DRdata.h.legendbutton,'Visible','On');
set(DRdata.h.outliers,'Visible','On');
set(DRdata.h.selsmpls,'Visible','On');
set(DRdata.h.switchSampleIds,'Visible','On');
set(DRdata.h.parallcoordbutton,'Visible','On');


%% hide scatter plots buttons
set(DRdata.h.swapBetweenXorRecXorRes,'Visible','On');
set(DRdata.h.RecPC,'Visible','On');
set(DRdata.subplot.h(1),'Visible','On');
set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(2)); title('');

%% Modify subplot positions
set(DRdata.subplot.h(1),'Position',DRdata.pos.SP1);
set(DRdata.subplot.h(2),'Position',DRdata.pos.SP2);
set(DRdata.subplot.h(3),'Position',DRdata.pos.SP3);
set(DRdata.subplot.h(4),'Position',DRdata.pos.SP4);
if ishandle(DRdata.h.CBSubP2)
    set(DRdata.h.CBSubP2,'Position',DRdata.pos.SBSubP2);
    set(DRdata.h.doLocalPC,'Position',DRdata.pos.pbLocalPC);
    set(DRdata.h.deleteRegnsForLocalPC,'Position',DRdata.pos.pbdelRegPC);
    set(DRdata.h.defineRegnsForLocalPC,'Position',DRdata.pos.pbdefRegPC);
    set(DRdata.h.STOCSY_PB,'Position',DRdata.pos.pbSTOCSY);
    set(DRdata.h.plotPeakStat,'Position',DRdata.pos.plotPeakStat);    
end
set(DRdata.h.swapCovXyOrSp,'Enable','Off');
set(DRdata.h.PeakPickedData,'Enable','Off');
set(DRdata.h.pvalues,'Enable','Off');
set(DRdata.h.qvalues,'Enable','Off');
set(DRdata.h.rvalues,'Enable','Off');
set(DRdata.h.ANOVA,'State','Off');
set(DRdata.h.BayesANOVA,'State','Off');