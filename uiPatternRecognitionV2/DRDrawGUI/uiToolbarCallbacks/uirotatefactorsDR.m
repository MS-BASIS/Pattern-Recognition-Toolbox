function uirotatefactorsDR(hMainFigure,eventdata)
%% uirotatefactorsDR prepares data to rotate factor loadings
%   Input: hMainFigDR - figure handle
%          DRdata     - properties and parameter values
%                       of dimension reduction toolbox objects
%% Author: Kirill A. Veselkov, 2011. Prototype of pattern recognition
%% toolboz

DRdata    = guidata(hMainFigure);
RBhandles = get(hMainFigure,'children');
DRdata    = resetparamDR(DRdata);
method    = get(RBhandles(cellfun(@(x) isequal(x, 1),...
    get(RBhandles,'Value'))),'String');

if ~strcmp(method,'no rotation')
    DRdata.loadings = rotatefactorsDR(DRdata.nonrot_loadings,...
        'Method',method);
    X             = bsxfun(@minus, DRdata.X, DRdata.meanX);
    DRdata.scores = X* DRdata.loadings;
    nPCs          = size(DRdata.scores,2);
    if strcmp(get(DRdata.h.robustPCA,'State'),'on')
        sampleIndcs = DRdata.outliers.od.vals<=DRdata.outliers.od.cutoff;
    else
        sampleIndcs = 1:DRdata.nSmpls;
    end
    ssqX = sum(sum((X(sampleIndcs,:).^2)));
    for iPC = 1:nPCs
        ssqPC = sum(sum((X(sampleIndcs,:) - ...
            DRdata.scores(sampleIndcs,iPC)*DRdata.loadings(:,iPC)').^2));
        PCvar(iPC) = 100*(1-ssqPC./ssqX);
    end
    [DRdata.PCvar,sortIndcs] = sort(PCvar,'descend');
    DRdata.scores            = DRdata.scores(:,sortIndcs);
    DRdata.loadings          = DRdata.loadings(:,sortIndcs);
    if strcmp(method,'promax')
        DRdata.PCvar = [];
    end
else 
    DRdata.loadings = DRdata.nonrot_loadings;
    DRdata.scores   = DRdata.nonrot_scores;
    DRdata.PCvar    = DRdata.nonrot_PCvar;
end

%% update scores plot
DRdata.PCplot.selPCs = [1 2];
visible = get(DRdata.h.LoadMapInScores,'Visible');
DRdata  = scatter2D(DRdata);
if ~isempty(visible)
    set(DRdata.h.LoadMapInScores,'Visible',visible);
end
%% update spectral plot, metabolic map, loadings and sample IDs images 
xlims                 = get(DRdata.subplot.h(2),'xlim');
ylims                 = get(DRdata.subplot.h(4),'ylim');
DRdata                = choosePCsDR(DRdata);
DRdata                = plotSpectraRedDR(DRdata,xlims);
DRdata                = updateLoadingPlotDR(DRdata);
imageSampleIdsDR(DRdata,ylims);
DRdata                = updateImagePlotsDR(DRdata,xlims,ylims);
updatePlotsDR(DRdata,1);
guidata(hMainFigure,DRdata);
return;