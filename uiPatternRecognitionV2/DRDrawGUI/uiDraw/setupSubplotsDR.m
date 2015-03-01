function DRdata = setupSubplotsDR(DRdata)
%% setSubplotsDR draws sub-plots for dimension reduction toolbox
%   Input: DRdata -   metadata for dimensionality reduction toolbox
%                    (see variableDescription.txt)
%% Author: Kirill Veselkov, Imperial College London, 2011


%% Subplot for DR scores
set(DRdata.h.figure,'Visible','off');
nSq          = DRdata.mainFig.nLines;
nHorLines    = floor(nSq./DRdata.mainFig.horDivs);
nVerLines    = floor(nSq/DRdata.mainFig.verDivs);
subplotIndcs = [];
for i = 1:nVerLines
    subplotIndcs = [subplotIndcs i:nSq:nSq*nHorLines];
end
DRdata.subplot.indcs{1}                         = subplotIndcs;
DRdata.subplot.h(1)                             = subplot(nSq,nSq,DRdata.subplot.indcs{1}); % temporary indices

DRdata.X                 = arrangedata(DRdata.X, DRdata.groups);   %arrange all matrices according to classes
DRdata.Sp                = arrangedata(DRdata.Sp, DRdata.groups);
DRdata.groupdata         = arrangedata(DRdata.groups, DRdata.groups);
if ~isempty(DRdata.replicates)
    DRdata.replicates        = arrangedata(DRdata.replicates, DRdata.groups);
end
DRdata.sampleIDs         = arrangedata(DRdata.sampleIDs, DRdata.groups);
DRdata.groups            = DRdata.groupdata;
DRdata.PCplot.selPCs     = [1 2];
DRdata.PCScoreGraphics   = 1;
DRdata.options.setparam  = 0;
if DRdata.nVrbls > (DRdata.nSmpls - 1)
    % this looseless compression procedure is only necessary 
    % if the number of variables exceeds the number of components
    DRdata.options.values{2} = 'SVD';
    DRdata.options.values{1} = DRdata.nSmpls - 1;
    DRdata.options.values{3} = 10.^-5;
    DRdata.object            = 'Unsupervised';
    DRdata                   = PCA(DRdata);
    DRdata.pca.T             = DRdata.scores;
    DRdata.pca.P             = DRdata.loadings;
else
    % otherwise use NIPALS algorithm
    DRdata.options.values{2} = 'NIPALS';
    DRdata.options.values{1} = 4;
    DRdata.options.values{3} = 10.^-5;
    DRdata.object            = 'Unsupervised';
    DRdata                   = PCA(DRdata);
end

%% Subplot for spectral profiles
for i = nVerLines+1:nVerLines+DRdata.mainFig.gapBetweenSubPlots
    subplotIndcs = [subplotIndcs i:nSq:nSq*nHorLines];
end
DRdata.subplot.indcs{2} = setdiff(1:nSq*nHorLines,subplotIndcs);
DRdata.subplot.h(2)     = subplot(nSq,nSq,DRdata.subplot.indcs{2});
set(DRdata.subplot.h(2),'units','normalized');
xlims                 = getSpAxisLimitsDR(DRdata);
nDPs                  = sum((DRdata.ppm<DRdata.ppm(xlims(2)))&(DRdata.ppm>DRdata.ppm(xlims(1))));
DRdata.redRatio       = dataRedRatio(nDPs);
DRdata.PCplot.spIndcs = getDataPointsFor2DScatter(DRdata);
[xlims,ylims]         = getSpAxisLimitsDR(DRdata);

%% Subplot for spectral map
mapStartPos  = 1 + (nHorLines+DRdata.mainFig.gapBetweenSubPlots)*nSq;
subplotIndcs = [];
for i = mapStartPos:mapStartPos+nVerLines
    subplotIndcs = [subplotIndcs i:nSq:nSq^2];
end
DRdata.subplot.indcs{3} = mapStartPos+nVerLines+1:nSq:nSq^2; % subplot for sample identifiers
DRdata.subplot.h(3)     = subplot(nSq,nSq,DRdata.subplot.indcs{3});

%% Image plot: Spectral map
DRdata.subplot.indcs{4}          = setdiff(mapStartPos:nSq^2,[subplotIndcs,DRdata.subplot.indcs{3}]); %subplot for metabolic map
DRdata.subplot.h(4)              = subplot(nSq,nSq,DRdata.subplot.indcs{4});
DRdata.h.CBSubP2                 = [];
DRdata.image.clims               = [];
DRdata.h.swapBetweenXorRecXorRes = [];
DRdata.h.CBSubP2                 = colorbar;

%% Plot all neccessary objects:
adjustPlotPtns(DRdata.subplot.h(2),DRdata.subplot.h(4));
% User interface
DRdata = drawDRuibuttons(DRdata);
% Scatter plot 
DRdata = scatter2D(DRdata);
DRdata = choosePCsDR(DRdata);
% Spectral profiles
DRdata = plotSpectraRedDR(DRdata,xlims,ylims);
% Sample identifiers
imageSampleIdsDR(DRdata);
% Metabolic Map
DRdata = plotMetabolicMapDR(DRdata);

%SBSubP2    = get(DRdata.h.CBSubP2,'Position');
%SBSubP2(3) = SBSubP2(3)./2; SBSubP2(1) = SBSubP2(1) + SBSubP2(3)./2;
%set(DRdata.h.CBSubP2,'Position',SBSubP2);
%PosSP4     = get(DRdata.subplot.h(4),'Position');  
%PosSP4(1)  = PosSP4(1) + SBSubP2(3)./2;
%set(DRdata.subplot.h(4),'Position',PosSP4);
%PosSP2     = get(DRdata.subplot.h(2),'Position');  
%PosSP2(1)  = PosSP2(1) + SBSubP2(3)./2;
%set(DRdata.subplot.h(2),'Position',PosSP2);
%PostSP3    = get(DRdata.subplot.h(3),'Position');
%PostSP3(3) = PostSP3(3) + SBSubP2(3)./2;
%set(DRdata.subplot.h(3),'Position',PostSP3);


% Get plot positions 
DRdata.pos.SP1          = get(DRdata.subplot.h(1),'Position');
DRdata.pos.SP2          = get(DRdata.subplot.h(2),'Position');
DRdata.pos.SP3          = get(DRdata.subplot.h(3),'Position');
DRdata.pos.SP4          = get(DRdata.subplot.h(4),'Position');
DRdata.pos.SBSubP2      = get(DRdata.h.CBSubP2,'Position');
DRdata.pos.pbLocalPC    = get(DRdata.h.doLocalPC,'Position');
DRdata.pos.pbdelRegPC   = get(DRdata.h.deleteRegnsForLocalPC,'Position');
DRdata.pos.pbdefRegPC   = get(DRdata.h.defineRegnsForLocalPC,'Position');
DRdata.pos.pbSTOCSY     = get(DRdata.h.STOCSY_PB,'Position');
DRdata.pos.plotPeakStat = get(DRdata.h.plotPeakStat,'Position');


DRdata.pos.showDR = 1; 
DRdata.pos.showBR = 0; 
DRdata            = deleteBRObjects(DRdata);

set(DRdata.h.figure,'OuterPosition',[0 0 1 1]);
set(DRdata.h.figure,'Visible','on');
return;

function grdata = arrangedata(data, groups, selsmpls)
%% Re-arranging data matrix according to grouping variable
%   data     - [samples x observations]
%   groups   - group identifiers [e.g. 1 if a given sample belongs to the first group]
%   selsmpls - samples selected by the user
%% Author: Kirill A, Veselkov, Imperial College 2011.

groupsIds  = unique(groups);
nGroups    = length(groupsIds);
grdata     = data;
if all(size(grdata)>1)
    indexStart = 1;
    for iGrp = 1:nGroups
        iGrpIndcs                       = groups==groupsIds(iGrp);
        indexEnd                        = indexStart+sum(iGrpIndcs)-1;
        grdata(indexStart:indexEnd,:)   = data(iGrpIndcs,:);
        indexStart                      = indexEnd+1;
    end
else
    indexStart = 1;
    for iGrp = 1:nGroups
        iGrpIndcs                       = groups==groupsIds(iGrp);
        indexEnd                        = indexStart+sum(iGrpIndcs)-1;
        grdata(indexStart:indexEnd)     = data(iGrpIndcs);
        indexStart                      = indexEnd+1;
    end
end

if nargin>2 && ~isempty(selsmpls)
    grdata = arrangedata(grdata, selsmpls);
end
return;