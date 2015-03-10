function uiDimensionReduction(ppm,Sp,X,groups,varargin)
%% Unsupervised and Supervised dimension reduction toolbox
%% for interactive explorative analysis and predictive modelling
%% of metabolic data sets
%  Input:  Sp     - peak intensity data matrix [observation x variables]
%          X      - log-transformed peak intensity matrix
%          ppm    - ppm values
%          groups - grouping variable
%          Properties: 'sampleIDs', samplematrix;
%% Author: Kirill Veselkov, Imperial College 2011,
%% Updated in 01/02/2015 to accomodate the analysis of large datasets and 
%% visualization issues with Matlab 2014b (8.4) 

warning off all; 
currentFolder = fileparts(mfilename('fullpath')); cd(currentFolder);
addpath(genpath(currentFolder));

if nargin<3 || isempty(groups)||length(groups)==1; 
    groups = ones(1,size(Sp,1)); 
end

if ppm(1)>ppm(2)
   [ppm, sortIndcs] = sort(ppm);
   Sp = Sp(:,sortIndcs);  X = X(:,sortIndcs);
end

DRdata = setupDRdefaults(ppm,Sp,X,groups); % setup figure parameters (lineWidth,FontSize,sampleIDs etc.)
DRdata = getVarArgin(varargin,DRdata);     % get marker types and colors
DRdata.currentFolder = currentFolder;
%% Zoom and Rotate buttons
hZoom = zoom(DRdata.h.figure); 
set(hZoom,'ActionPostCallback',@zoomcallbackDR); % set callback for zoom events
set(hZoom,'Enable','on');
hRotate = rotate3d(DRdata.h.figure); 
set(hRotate,'ActionPreCallback',@nofunction); set(hRotate,'ActionPostCallback',@nofunction)
set(hRotate,'ButtonDownFilter',@nofunction);

DRdata = setupDRtoolbars(DRdata);          % setup all toolbars
DRdata = setupSubplotsDR(DRdata);          % divide the figure into subplots
% container = com.mathworks.mde.desk.MLDesktop.getInstance.getMainFrame; 
%pos = fix(getpixelposition(container,1)); 
%drawnow update; pause(0.01);
%roundbuttonborder(DRdata.h.selsmpls);
%roundbuttonborder(DRdata.h.legendbutton);
%pos = get(DRdata.h.figure,'Position');
%set(DRdata.h.figure, 'Position',pos-[5000,5000,0,0], 'Visible','on');


%set(DRdata.h.figure, 'Visible','on');
%drawnow; pause(0.01);
%set(DRdata.h.figure, 'Visible','off');
set(DRdata.h.figure, 'Visible','on');
if ismac
    objhandles = findobj(gcf,'-not',{'Type','uitoolbar'},'-not',{'type','figure'});
    set(objhandles, 'Visible','off');
    drawnow; pause(0.05);
    set(objhandles, 'Visible','on'); set(DRdata.h.text,'Visible','off');
end
guidata(DRdata.h.figure,DRdata)

function [DRdata] = getVarArgin(argsin,DRdata)
%% get default arguments (colors and types of sample markers)
nSmpls  = size(DRdata.Sp,1);
for iSmpl = 1:nSmpls
    DRdata.sampleIDs{iSmpl}   = num2str(iSmpl);
end
DRdata.replicates = [];

nArgs = length(argsin);
for i=1:2:nArgs
    if  strcmp('markerInfo',argsin{i})
        DRdata.marker        = argsin{i+1};
    elseif strcmp('markerType',argsin{i})
        DRdata.PCplot.marker.type   = argsin{i+1};
    elseif strcmp('markerFill',argsin{i})
        DRdata.PCplot.marker.fill   = argsin{i+1};
    elseif strcmp('colors',argsin{i})
        DRdata.marker.color = argsin{i+1};
    elseif strcmp('sampleIDs',argsin{i})
        DRdata.sampleIDs     = argsin{i+1};
    elseif strcmp('groupIDs',argsin{i})
        DRdata.groupIds = argsin{i+1};
    elseif strcmp('replicates',argsin{i})
        DRdata.replicates = argsin{i+1};
    elseif strcmp('nmr',argsin{i})
        DRdata.NMR = argsin{i+1};       
    end
end

if ~isempty(DRdata.replicates)
    DRdata.replicates = grp2idx(DRdata.replicates);
end

if size(DRdata.groupIds,1)<size(DRdata.groupIds,2)
    DRdata.groupIds = DRdata.groupIds';
end

nGrps                  = length(DRdata.groupIds);
if iscell(DRdata.marker.color)   
    if ~isnumeric(DRdata.marker.color{1})
        DRdata.marker.color = getNumClrs(DRdata.marker.color);
    end
    DRdata.spcolors = zeros(nGrps,3);
    for iGrp = 1:nGrps
        DRdata.spcolors(iGrp,:) = DRdata.marker.color{iGrp};
    end
else
    DRdata.spcolors =DRdata.marker.color;
    DRdata.marker.color  = cell(1,nGrps);
    for iGrp = 1:nGrps
        DRdata.marker.color{iGrp} = DRdata.spcolors(iGrp,:);
    end
end

if isnumeric(DRdata.sampleIDs)
    y = DRdata.sampleIDs;
    DRdata.sampleIDs = cell(1,nSmpls);
    for iSmpl = 1:nSmpls
        DRdata.sampleIDs{iSmpl}   = num2str(y(iSmpl));
    end
end


return;

function colors = getNumClrs(colors)
nGrps = length(colors);
for i = 1:nGrps
    if strcmp(colors{i},'y')
        colors{i} = [1 1 0];
    elseif strcmp(colors{i},'m')
        colors{i} = [1 0 1];
    elseif strcmp(colors{i},'c')
        colors{i} = [0 1 1];
    elseif strcmp(colors{i},'r')
        colors{i} = [1 0 0];
    elseif strcmp(colors{i},'g')
        colors{i} = [0 1 0];
    elseif strcmp(colors{i},'b')
        colors{i} = [0 0 1];
    elseif strcmp(colors{i},'k')
        colors{i} = [0 0 0];
    end
end
return;