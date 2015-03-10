function DRdata = setupDRtoolbars(DRdata)
%%    setupDRtoolbars configures push and toggle buttons for visualization 
%% of results obtained from various dimension reduction methods
%% Input: DRdata -  GUI parameters 
%% Author: Kirill Veselkov, Imperial College 2011

%DRdata = customizeMainTB(DRdata);
setSTOCSYmenus();
DRdata = setupDRTB(DRdata);
DRdata = setupDRLocalTB(DRdata);

function DRdata = customizeMainTB(DRdata)
%% The function customizes the main figure toolbars 
%     Input: DRdata -  GUI parameters 
set(DRdata.h.figure,'ToolBar','figure');
DRdata.h.MainTB = findall(DRdata.h.figure,'tag','FigureToolBar');
set(DRdata.h.MainTB,'tag','FigureModToolBar');
hMainTBButtons    = findall(DRdata.h.MainTB );
delete(hMainTBButtons([14:17 6:8]));
hMainTBButtons    = findall(DRdata.h.MainTB);
set(hMainTBButtons(end-3),'Separator','on'); 
hButton           = uipushtool(DRdata.h.MainTB);     
set(hButton,'Enable','off');

%uipushtool(DRdata.h.MainTB,'CData',DRdata.icons.stocsy,'ClickedCallback',...
%    {@uidoSTOCSY},'TooltipString','STOCSY it','tag','STOCSY');
%hButton  = uipushtool(DRdata.h.MainTB);     
%set(hButton,'Enable','off');

function DRdata = setupDRTB(DRdata)
%% setupDRTB installs a toolbar used for GUI of dimension reduction methods
%% Author: Kirill Veselkov, Imperial College London
set(DRdata.h.figure,'ToolBar','figure');
DRdata.h.MainTB = findall(DRdata.h.figure,'tag','FigureToolBar');
hZoomin    = findall( DRdata.h.figure,'Tag','Exploration.ZoomIn');
hZoomout   = findall( DRdata.h.figure,'Tag','Exploration.ZoomOut');


DRdata.h.DRMethodsTB = uitoolbar(DRdata.h.figure,'tag','DRMethodsToolBar'); 
copyobj([hZoomout,hZoomin],DRdata.h.DRMethodsTB ); delete(DRdata.h.MainTB);
icons                = DRdata.icons;

%% Upload MS data
%DRdata.h.uploadMSdata = uipushtool(DRdata.h.DRMethodsTB,'CData',...
%    icons.uploaddata,'ClickedCallback',{@uiUploadMSDataForClassificationDR},'TooltipString',...
%    'Upload CDF profile for classification',...
%    'tag','SpOrder');
hButton  = uipushtool(DRdata.h.DRMethodsTB);
set(hButton,'Enable','off');

%% Switch between spectral profiles and reconstucted spectral profiles
DRdata.h.showSampleIDs = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
     DRdata.icons.sampleIDs,'ClickedCallback',{@showSampleIdsDR},...
     'TooltipString','Show sample identifiers','tag','showSampleIds');
DRdata.h.showLoadingPlot = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.loadings,'ClickedCallback',{@swapSpOrRecSpDR},'ClickedCallback',{@showLoadingsDR},...
     'TooltipString','Show factor loadings','tag','show component loadings');
 
hButton  = uipushtool(DRdata.h.DRMethodsTB);
set(hButton,'Enable','off')

%% Various types of DR methodologies

% PCA:Principal Component Analysis
DRdata.h.PCA = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.PCA1,'ClickedCallback',{@uidoDR},'State','On','TooltipString','PCA','tag','PCA');
DRdata.h.selDRmethod = DRdata.h.PCA;
DRdata.h.robustPCA = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.PCA2,'ClickedCallback',{@uidoDR},'State','Off','TooltipString','Robust PCA','tag','RobPCA');
DRdata.h.rotatefactors = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.rotateloadings,'ClickedCallback',{@rotatefactorsStateDR},'State','Off','TooltipString','Rotate Factors','tag','RotateFactors','Separator','on');
hButton  = uipushtool(DRdata.h.DRMethodsTB);
set(hButton,'Enable','off');

% NMF:Non-negative Matrix Factorisation
DRdata.h.PCALDA = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.LDPCA,'ClickedCallback',{@uidoDR},'State','Off','TooltipString','Discriminating feature exctraction via PCA+LDA','tag','PCALDA','Separator','on');
DRdata.h.MMCLDA = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.LDMMC,'ClickedCallback',{@uidoDR},'State','Off','TooltipString','Discriminating Feature Exctraction via maximum margin criterion','tag','LDAMMC','Separator','on');
DRdata.h.PLS = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.PLS,'ClickedCallback',{@uidoDR},'State','Off','TooltipString','Discriminating Feature Exctraction via PLS','tag','PLS','Separator','on');

hButton  = uipushtool(DRdata.h.DRMethodsTB);
set(hButton,'Enable','off');
%DRdata.h.SpOrder = uipushtool(DRdata.h.DRMethodsTB,'CData',...
%    icons.DR,'ClickedCallback',{@uidoSpOrderDR},'TooltipString',...
%    'Order similar profiles based on pair-wise similarities of scores via spectral algorithm ',...
%    'tag','SpOrder');
DRdata.h.DRLocalTBOutMap = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.DR3Dplane,'ClickedCallback',{@uiGetOutlierMap},...
    'TooltipString','Get outlier map','tag','OutlierMap',...
    'State','Off');
DRdata.h.CV = uitoggletool(DRdata.h.DRMethodsTB,'CData',...
    icons.CV,'ClickedCallback',{@uidoCV},'State','Off','TooltipString','Model cross validation','tag','CV','Separator','on');

hButton  = uipushtool(DRdata.h.DRMethodsTB);
set(hButton,'Enable','off');
hButton  = uipushtool(DRdata.h.DRMethodsTB);
set(hButton,'Enable','off');


uipushtool(DRdata.h.DRMethodsTB,'CData',DRdata.icons.defaults,'ClickedCallback',...
    {@uiDRchangeFigDefaults},'TooltipString','Change figure defaults','tag','uiDRchangeFigDefaults','Separator','on');
uipushtool(DRdata.h.DRMethodsTB,'CData',DRdata.icons.SavAas1,'ClickedCallback',...
    {@uiDRexporData},'TooltipString','save results in a matlab environmnet','tag','uiDRsaveas');

%% workarounds for 2014b release with zoom in and zoom out functionalities
hZoomin   = double(findall(DRdata.h.figure,'Tag','Exploration.ZoomIn'));
if ishandle(hZoomin)
    clbfun = get(hZoomin,'ClickedCallback');
    if isempty(clbfun)
        set(hZoomin,'ClickedCallback','putdowntext(''zoomin'',gcbo)');
    end
end
hZoomout   = double(findall( DRdata.h.figure,'Tag','Exploration.ZoomOut'));
if ishandle(hZoomout)
    clbfun = get(hZoomout,'ClickedCallback');
    if isempty(clbfun)
        set(hZoomout,'ClickedCallback','putdowntext(''zoomout'',gcbo)');
    end
end
return;

function DRdata = setupDRLocalTB(DRdata)
%% setupDRTB installs a toolbar used for GUI of dimension reduction methods
%% Author: Kirill Veselkov, Imperial College London
DRdata.h.PairWiseDiffTB = uitoolbar(DRdata.h.figure,'tag','DRLocalToolBar'); 
icons                   = DRdata.icons;

%% Switch between spectral profiles and differential plot
PWCAButtons  = uipushtool(DRdata.h.PairWiseDiffTB);
set(PWCAButtons,'Enable','off')
DRdata.h.swapCovXyOrSp  = uitoggletool(DRdata.h.PairWiseDiffTB,'CData',...
    icons.RedDownArrow,'ClickedCallback',{@swapCovXyOrSpectraBR},'TooltipString','Show spectral profiles');
PWCAButtons  = uipushtool(DRdata.h.PairWiseDiffTB);
set(PWCAButtons,'Enable','off')

%% Toggle buttons for the selection of a test statistic...
DRdata.h.ANOVA  = uitoggletool(DRdata.h.PairWiseDiffTB,'CData',...
    icons.anova,'ClickedCallback',{@uidoANOVA},'State','Off','TooltipString',...
    'Conventional ANOVA test');
DRdata.h.BayesANOVA  = uitoggletool(DRdata.h.PairWiseDiffTB,'CData',...
    icons.anova1,'ClickedCallback',{@uidoANOVA},'State','Off','TooltipString',...
    'Emprical bayes ANOVA-test');
DRdata.h.PeakPickedData  = uitoggletool(DRdata.h.PairWiseDiffTB,'CData',...
    icons.pointer,'ClickedCallback',{@getPeakPickedStatsPWCA},'State','Off','Separator','On',...
    'TooltipString','Use peak picked data');
PWCAButtons  = uipushtool(DRdata.h.PairWiseDiffTB);
set(PWCAButtons,'Enable','off')

%% Additional functional push buttons...
DRdata.h.pvalues  = uitoggletool(DRdata.h.PairWiseDiffTB,...
    'CData',icons.pvalues,'ClickedCallback',{@swap_pqrBR},...
    'State','Off','TooltipString',sprintf('p-values'),...
    'Tag','pvalues');
DRdata.h.qvalues  = uitoggletool(DRdata.h.PairWiseDiffTB,...
    'CData',icons.qvalues ,'ClickedCallback',{@swap_pqrBR},...
    'State','Off','TooltipString',sprintf('q-values'),...
    'Tag','qvalues');
DRdata.h.rvalues = uitoggletool(DRdata.h.PairWiseDiffTB,...
    'CData',icons.rvalues ,'ClickedCallback',{@swap_pqrBR},...
    'State','Off','TooltipString',sprintf('rank values'),...
    'Tag','rvalues');
PWCAButtons  = uipushtool(DRdata.h.PairWiseDiffTB);
set(PWCAButtons,'Enable','off')
return;