function DRdata = setupDRdefaults(ppm,Sp,X,groups)
%% setupDRdefaults sets various default parameters for dimension reduction toolbox
    % Input: ppm    - chemical shift scale
    %        Sp     - spectra of biological samples
    %        X      - variance stabilized spectra of biological samples
    %        groups - grouping variable for various classes
%% Author: Kirill Veselkov, Imperial College London 2011

load msicons;
DRdata.icons = msicons.patternrecogn;
%DRdata.icons = icons;
DRdata.NMR   = 0;

%% STOCSY defaults
DRdata.stocsy.cc          = 'spearman';
DRdata.stocsy.pThr        = 0.05; 
DRdata.ppm                = ppm;
DRdata.Sp                 = Sp;
DRdata.X                  = X;
DRdata.groups             = groups; 
DRdata.mainFig.backgroundcolor    = [1 1 1];

%% Figure defaults
%set(0,'Units','Pixels');
%fullscreen = get(0,'ScreenSize');
%[fullscreen,~,~] = getDefaultScreenSize();
DRdata.h.figure = figure(...
    'Units', 'normalized',...
    'OuterPosition',[0 0 1 1],'Menu','none',...
    'Color',DRdata.mainFig.backgroundcolor,'Visible','on');
updateFigTitleAndIconMS(DRdata.h.figure,'Pattern Recognition Explorer','MSINavigatorLogo.png');

%% Visualization defaults
DRdata.mainFig.nLines              = 66;     % overall number of lines
DRdata.mainFig.gapBetweenSubPlots  = 5;      % gap between spectra and their map (in lines)
DRdata.mainFig.verDivs             = 3;      % a number of sections into which the figure is vertically divided
DRdata.mainFig.horDivs             = 2.2;      % a number of sections into which the figure is horizontally divided
DRdata.showMarkers                 = 1;
DRdata.sortSelIndcs                = [];
DRdata.h.LoadMapInScores           = [];
DRdata.selsamples                  = [];
DRdata.spsortindcs                 = [];
DRdata.outliers                    = [];
[DRdata.nSmpls,DRdata.nVrbls]      = size(DRdata.Sp); 

%% ColorMaps
DRdata.colormap.loadingsPCA = [0,1,1;0,0.933333337306976,1;0,0.866666674613953,1;0,0.800000011920929,1;0,0.733333349227905,1;0,0.666666686534882,1;0,0.600000023841858,1;0,0.533333361148834,1;0,0.466666668653488,1;0,0.400000005960465,1;0,0.333333343267441,1;0,0.266666680574417,1;0,0.200000002980232,1;0,0.133333340287209,1;0,0.0666666701436043,1;0,0,1;0,0,0.937500000000000;0,0,0.875000000000000;0,0,0.812500000000000;0,0,0.750000000000000;0,0,0.687500000000000;0,0,0.625000000000000;0,0,0.562500000000000;0,0,0.500000000000000;0,0,0.437500000000000;0,0,0.375000000000000;0,0,0.312500000000000;0,0,0.250000000000000;0,0,0.187500000000000;0,0,0.125000000000000;0,0,0.0625000000000000;0,0,0;0.0434782616794109,0.0260869581252337,0.0173913054168224;0.0869565233588219,0.0521739162504673,0.0347826108336449;0.130434781312943,0.0782608762383461,0.0521739125251770;0.173913046717644,0.104347832500935,0.0695652216672897;0.217391297221184,0.130434781312943,0.0869565233588219;0.260869562625885,0.156521752476692,0.104347825050354;0.304347813129425,0.182608708739281,0.121739134192467;0.347826093435288,0.208695665001869,0.139130443334579;0.391304343938828,0.234782621264458,0.156521737575531;0.434782594442368,0.260869562625885,0.173913046717644;0.478260874748230,0.286956518888474,0.191304355859756;0.521739125251770,0.313043504953384,0.208695650100708;0.565217375755310,0.339130461215973,0.226086959242821;0.608695626258850,0.365217417478561,0.243478268384933;0.652173936367035,0.391304373741150,0.260869562625885;0.695652186870575,0.417391330003738,0.278260886669159;0.739130437374115,0.443478286266327,0.295652180910111;0.782608687877655,0.469565242528915,0.313043475151062;0.826086938381195,0.495652198791504,0.330434799194336;0.869565188884735,0.521739125251770,0.347826093435288;0.913043498992920,0.547826111316681,0.365217387676239;0.956521749496460,0.573913037776947,0.382608711719513;1,0.600000023841858,0.400000005960465;1,0.644444465637207,0.355555564165115;1,0.688888907432556,0.311111122369766;1,0.733333349227905,0.266666680574417;1,0.777777791023254,0.222222223877907;1,0.822222232818604,0.177777782082558;1,0.866666674613953,0.133333340287209;1,0.911111116409302,0.0888888910412788;1,0.955555558204651,0.0444444455206394;1,1,0;];
DRdata.colormap.loadingsNMF = [0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0.0434782616794109,0.0260869581252337,0.0173913054168224;0.0869565233588219,0.0521739162504673,0.0347826108336449;0.130434781312943,0.0782608762383461,0.0521739125251770;0.173913046717644,0.104347832500935,0.0695652216672897;0.217391297221184,0.130434781312943,0.0869565233588219;0.260869562625885,0.156521752476692,0.104347825050354;0.304347813129425,0.182608708739281,0.121739134192467;0.347826093435288,0.208695665001869,0.139130443334579;0.391304343938828,0.234782621264458,0.156521737575531;0.434782594442368,0.260869562625885,0.173913046717644;0.478260874748230,0.286956518888474,0.191304355859756;0.521739125251770,0.313043504953384,0.208695650100708;0.565217375755310,0.339130461215973,0.226086959242821;0.608695626258850,0.365217417478561,0.243478268384933;0.652173936367035,0.391304373741150,0.260869562625885;0.695652186870575,0.417391330003738,0.278260886669159;0.739130437374115,0.443478286266327,0.295652180910111;0.782608687877655,0.469565242528915,0.313043475151062;0.826086938381195,0.495652198791504,0.330434799194336;0.869565188884735,0.521739125251770,0.347826093435288;0.913043498992920,0.547826111316681,0.365217387676239;0.956521749496460,0.573913037776947,0.382608711719513;1,0.600000023841858,0.400000005960465;1,0.644444465637207,0.355555564165115;1,0.688888907432556,0.311111122369766;1,0.733333349227905,0.266666680574417;1,0.777777791023254,0.222222223877907;1,0.822222232818604,0.177777782082558;1,0.866666674613953,0.133333340287209;1,0.911111116409302,0.0888888910412788;1,0.955555558204651,0.0444444455206394;1,1,0;];

%%
loadDefaultsFromFile                = isFileWithDefaults();
if (loadDefaultsFromFile)
    load('msidefaults.mat')
     defaults              = defaults.PatternRecognition;
     DRdata.marker         = defaults.marker;
     DRdata.fontsize       = defaults.fontsize;
     DRdata.SPplot         = defaults.SPplot;
     DRdata.PCplot         = defaults.PCplot;
     DRdata.spcolors       = defaults.spcolors;
     DRdata.spcolor        = defaults.spcolor;
     DRdata.renderer       = defaults.renderer;
     DRdata.peakPickedData = defaults.peakPickedData;
     if DRdata.NMR==1
         DRdata.SPplot.xreverse                 = 1;
         DRdata.SPplot.xlabel                   = '1H ppm';
         %% Bucketted data         
     else
         DRdata.SPplot.xreverse                 = 0;
         DRdata.SPplot.xlabel                   = 'MZ';
     end
 %else
 %   DRdata.PCplot.marker.type                = {'o','d','>','s','p','<','^'};
 %   DRdata.marker.color                      = {'b','r','k','m','c','g','y'};
 %   DRdata.fontsize.axis                     = 14;
 %   DRdata.fontsize.sampleIds                = 10;
 %   DRdata.fontsize.title                    = 24;
 %   DRdata.fontsize.axislabel                = 18;
 %   DRdata.PCplot.marker.size                = 8;
 %   DRdata.PCplot.marker.linewidth           = 2;
 %   DRdata.PCplot.marker.selcolor            = [1 1 1];
 %   DRdata.PCplot.marker.zoomMarSizeIncrease = 2;
 %   DRdata.SPplot.linewitdthIncrease         = 2;
 %   DRdata.SPplot.linewidth                  = 1;
 %   DRdata.ppmresolution                     = 1200;
 %   DRdata.SPplot.xreverse                   = 0;
 %   DRdata.SPplot.xlabel                     = 'MZ';
 %   DRdata.PCplot.maxNumPoints      = 1000;
 %   DRdata.PCplot.minNumClassPoints = 50;
 end
    
if ~isfield(DRdata.PCplot.marker,'fill')
   DRdata.PCplot.marker.fill = DRdata.marker.color;
end

DRdata.renderer = defaults.renderer;
matver = version;
% if matlab version R2014b or older the colormap can be specific to axes
if str2num(matver(1:3))>=8.4
    DRdata.renderer = 'opengl';
else
    DRdata.renderer = 'zbuffer';
end
%DRdata.fontsize.choosePCs             = 16;
%DRdata.fontsize.sampleLabels          = 10;
DRdata.icon.size                       = 30;
%DRdata.SPplot.regions.color          = [.8 .8 .8];
%DRdata.SPplot.regions.transparency   = 0.4;
DRdata.h.CBSubP1                = [];
DRdata.PCplot.CVScores          = 0;
DRdata.test                     = [];
DRdata.PCplot.selPCsForRecs     = [1 1];
DRdata.PCplot.selPCs            = [1 2];
DRdata.PCplot.stateOM           = 0;
DRdata.PCplot.parallelCoord     = 0; 
DRdata.PCplot.h.legend          = [];
DRdata.PCplot.plot3D            = 0;

DRdata.cv.h.rotatecvlabels         = [];
DRdata.h.choosePCs                 = [];
DRdata.SPplot.regions.bndrs        = [];
DRdata.h.PCregions                 = [];
DRdata.h.SelSamplesMetMapRectangle = [];
DRdata.h.rotateFactorsButtonGroup  = [];
[DRdata.groups,DRdata.groupIds]    = getClassLabels(DRdata.groups);
nGrps                              = length(DRdata.groupIds);
nMarkers                           = length(DRdata.marker.color);
if nGrps>nMarkers
    markerTypes = cell(1,nGrps);
    for iGrp = 1:nGrps
        markerTypes{iGrp} = 'o';
    end
    colours                             = hsv(nGrps);  
    for iGrp = 1:nGrps
        DRdata.PCplot.marker.type{iGrp}  = markerTypes{iGrp};
        if iscell(colours)
            DRdata.marker.color{iGrp} = colours{iGrp};
        else
            DRdata.marker.color{iGrp} = colours(iGrp,:);
        end
        DRdata.PCplot.marker.fill{iGrp}  = 0;
    end
end
% Check if we work with peak picked data
diffppm = diff(ppm);
if all(diffppm >= diffppm(1)-10.^-6 & diffppm <= diffppm(1)+10.^-6)
    DRdata.peakPickedData = 0;
end

DRdata.groupOrder = 1:nGrps;
return;

function loadDefaultsFromFile = isFileWithDefaults()
filenames            = what;
nFiles               = length(filenames.mat);
loadDefaultsFromFile = 0;
for iFile = 1:nFiles
    if strcmp(filenames.mat{iFile},'msidefaults.mat');
        loadDefaultsFromFile =1;
        break;
    end
end
return;