function DRdata = deleteDRObjects(DRdata)

if ishandle(DRdata.h.choosePCs)
    delete(DRdata.h.choosePCs)
end

%% Switch off All Buttons Related to Dimension Reduction Techniques
set(DRdata.h.PCALDA,'State','Off');
set(DRdata.h.MMCLDA,'State','Off');
set(DRdata.h.PLS,'State','Off');
set(DRdata.h.robustPCA,'State','Off');
set(DRdata.h.PCA,'State','Off');
set(DRdata.h.CV,'State','Off');
set(DRdata.h.rotatefactors,'State','Off');

%% Inactivate DR buttons
if strcmp(get(DRdata.h.showLoadingPlot,'State'),'on')
    set(DRdata.h.showLoadingPlot,'State','Off');
    % adjust button for sample reconstruction
    posFB = get(DRdata.h.swapBetweenImageLVorContLV,'Position');
    set(DRdata.h.swapBetweenXorRecXorRes,'Position',posFB);
    
    if ishandle(DRdata.h.swapBetweenLVtoVV)
        delete(DRdata.h.swapBetweenLVtoVV);
        DRdata.h.swapBetweenLVtoVV = [];
    end
    if ishandle(DRdata.h.swapBetweenImageLVorContLV)
        delete(DRdata.h.swapBetweenImageLVorContLV);
        DRdata.h.swapBetweenImageLVorContLV = [];
    end
    deleteColorbarDR(DRdata.subplot.h(5));
    set(DRdata.subplot.h(2),'XAxisLocation','Bottom');
    delete(DRdata.subplot.h(5:end));
    DRdata.subplot.h(5:end) = [];
    set(DRdata.h.LoadMapInScores,'Visible','off'); 
end

%% Rearrange sample profiles
DRdata = resetparamDR(DRdata);
DRdata = plotMetabolicMapDR(DRdata);
imageSampleIdsDR(DRdata);


set(DRdata.h.DRLocalTBOutMap,'Enable','Off');
set(DRdata.h.showLoadingPlot,'Enable','Off')
set(DRdata.h.rotatefactors,'Enable','Off');
if ishandle(DRdata.h.rotateFactorsButtonGroup)
    delete(DRdata.h.rotateFactorsButtonGroup);
end
set(DRdata.h.SpOrder,'Enable','Off');
set(DRdata.h.CV,'Enable','Off');

if ishandle(DRdata.cv.h.rotatecvlabels)
    delete(DRdata.cv.h.rotatecvlabels);
    DRdata.cv.h.rotatecvlabels = [];
end

%% Hide scatter plots buttons
set(DRdata.h.legendbutton,'Visible','Off');
set(DRdata.h.outliers,'Visible','Off');
set(DRdata.h.selsmpls,'Visible','Off');
set(DRdata.h.switchSampleIds,'Visible','Off');
set(DRdata.h.outliers,'Visible','Off');
set(DRdata.h.parallcoordbutton,'Visible','Off');

%% hide scatter plots buttons
set(DRdata.h.swapBetweenXorRecXorRes,'Visible','Off');
set(DRdata.h.RecPC,'Visible','Off');
set(DRdata.h.swapCovXyOrSp,'Enable','On');
set(DRdata.h.PeakPickedData,'Enable','On');
set(DRdata.h.pvalues,'Enable','On');
set(DRdata.h.qvalues,'Enable','On');
set(DRdata.h.rvalues,'Enable','On');

if ishandle(DRdata.PCplot.h.legend)
    delete(DRdata.PCplot.h.legend);
    DRdata.PCplot.h.legend = [];
end

%% Modify subplot positions
set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(1)); cla; set(DRdata.subplot.h(1),'Visible','Off')
posSP1 = get(DRdata.subplot.h(1),'Position');
posSP2 = get(DRdata.subplot.h(2),'Position');
posSP3 = get(DRdata.subplot.h(3),'Position');
posSP4 = get(DRdata.subplot.h(4),'Position');
posSP5 = get(DRdata.h.CBSubP2,'Position');

%delta  = posSP4([1,3]) - posSP2([1,3]);
% save positions
DRdata.pos.SP1     = posSP1; % scores
DRdata.pos.SP2     = posSP2; % spectra
DRdata.pos.SP3     = posSP3; % sample ids
DRdata.pos.SP4     = posSP4; % metabolic map
DRdata.pos.SBSubP2 = posSP5; % colorbar metabolic map

% Reset positions of sampleids
gap       = posSP4(1) - posSP3(1)- posSP3(3);
posSP3(1) = posSP1(1);
set(DRdata.subplot.h(3),'Position',posSP3);
outposSP3 = posSP3(1) + posSP3(3)+gap;
% Reset positions of metabolic map
posSP4(3) = posSP4(3) + (posSP4(1)-outposSP3) - posSP5(3);
posSP4(1) = posSP4(1) - (posSP4(1)-outposSP3); 
set(DRdata.subplot.h(4),'Position',posSP4);
% Reset positions of spectral plot
posSP2([1,3]) = posSP4([1,3]);
set(DRdata.subplot.h(2),'Position',posSP2);
delta                 = zeros(1,4);
delta(1)              = posSP5(3);

%% shift positions of pushbuttons for local PCA
DRdata.pos.pbLocalPC  = get(DRdata.h.doLocalPC,'Position');
DRdata.pos.pbdelRegPC = get(DRdata.h.deleteRegnsForLocalPC,'Position');
DRdata.pos.pbdefRegPC = get(DRdata.h.defineRegnsForLocalPC,'Position');
DRdata.pos.pbSTOCSY   = get(DRdata.h.STOCSY_PB,'Position');
set(DRdata.h.CBSubP2,'Position',DRdata.pos.SBSubP2 - delta);
set(DRdata.h.doLocalPC,'Position',DRdata.pos.pbLocalPC-delta);
set(DRdata.h.deleteRegnsForLocalPC,'Position',DRdata.pos.pbdelRegPC-delta);
set(DRdata.h.defineRegnsForLocalPC,'Position',DRdata.pos.pbdefRegPC-delta);
set(DRdata.h.plotPeakStat,'Position',DRdata.pos.plotPeakStat-delta);
set(DRdata.h.STOCSY_PB,'Position',DRdata.pos.pbSTOCSY-delta);