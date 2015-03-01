function uiGetOutlierMap(hMainFig,hObjects)
%% uiGetOutlierMap calculates an outlier map
%   Input: hMainFigDR - figure handle
%          DRdata     - properties and parameter values
%                       of dimension reduction toolbox objects
%% Author: Kirill A. Veselkov, Imperial College 2011. 

DRdata        = guidata(hMainFig);
stateOM       = get(hMainFig,'State');

if strcmp(stateOM,'on')
    DRdata.PCplot.stateOM  = 1;
    if length(DRdata.subplot.h)>4;
        set(DRdata.subplot.h(2),'XAxisLocation','Bottom');
        posFB = get(DRdata.h.swapBetweenImageLVorContLV,'Position');
        set(DRdata.h.swapBetweenXorRecXorRes,'Position',posFB);
        delete(DRdata.h.swapBetweenLVtoVV,DRdata.h.swapBetweenImageLVorContLV);
        deleteColorbarDR(DRdata.subplot.h(5));
        delete(DRdata.subplot.h(5:end));
        DRdata.subplot.h(5:end) = [];
        set(DRdata.h.LoadMapInScores,'Visible','off');
        set(DRdata.h.showLoadingPlot,'State','off');
    end
    %% Perform calculation of robust location and scale via the MCD estimator
    if isempty(DRdata.outliers)
        options             = setOptions();
        options.nonoutliers = min(ceil((1 - options.values{1})*DRdata.nSmpls),(DRdata.nSmpls+DRdata.nVrbls+1)/2);
        DRdata.outliers     = getOutliers(DRdata.X,DRdata.meanX,...
            DRdata.scores,DRdata.loadings,[],[],options.nonoutliers,options.values{3},options.values{2});
    end   
else
    DRdata.PCplot.stateOM  = 0;
end

%% do visualization and back up the data
DRdata        = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
xlims         = get(DRdata.subplot.h(4),'xlim');
ylims         = get(DRdata.subplot.h(4),'ylim');
DRdata        = plotMetabolicMapDR(DRdata,xlims,ylims);
DRdata        = updatePlotsDR(DRdata);
DRdata        = choosePCsDR(DRdata);
guidata(hMainFig,DRdata);
return;

function options = setOptions()
%% get default input arguments 
options.names{1}  = 'The fraction of outlying observation';
options.values{1} = '0.25';
options.names{2}  = 'The number of random resampling operations';
options.values{2} = '250';
options.names{3}  = 'Distribution cutoff';
options.values{3} = '0.975';
answer            = inputdlg(options.names,'Outlier Map Setup',1,options.values);
options.values{1} = str2double(answer{1});
options.values{2} = str2double(answer{2});   
options.values{3} = str2double(answer{3});   