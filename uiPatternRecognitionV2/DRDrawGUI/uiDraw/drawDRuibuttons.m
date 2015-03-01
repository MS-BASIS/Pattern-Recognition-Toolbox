function DRdata = drawDRuibuttons(DRdata)
% draws various ui interface for dimensionality reduction techniqyes and spectral
% datasets

%% Push Buttons: Sample selection & Outlier Removal & Swap between sample identifiers
set(DRdata.subplot.h(1),'units','pixels');
ax1Ptns               = get(DRdata.subplot.h(1),'Position');          % get subplot position
selSmplsTogButPtns(1) = ax1Ptns(1)+ ax1Ptns(3) - 2*DRdata.icon.size;  % adjust positions
selSmplsTogButPtns(2) = ax1Ptns(2)+ ax1Ptns(4) + DRdata.icon.size*0.2;
selSmplsTogButPtns(3) = DRdata.icon.size;
selSmplsTogButPtns(4) = DRdata.icon.size;
DRdata.h.selsmpls     = uicontrol('style', 'pushbutton','CData',...             % sample selection
    DRdata.icons.selSampleIds,'units','pixels','Position',selSmplsTogButPtns,...
    'Callback', @selectSamplesDR, 'TooltipString','Select samples');%,...
    %'BackgroundColor',DRdata.mainFig.backgroundcolor);
selSmplsTogButPtns(1)      = selSmplsTogButPtns(1) + DRdata.icon.size;
DRdata.h.outliers          = uicontrol('style', 'pushbutton','CData',...             % sample selection
    DRdata.icons.StopRed,'units','pixels','Position',selSmplsTogButPtns,...
    'Callback', @uiRemoveOutliers, 'TooltipString','Remove selected samples');%,...
    %'BackgroundColor',DRdata.mainFig.backgroundcolor);
checkBoxPtns               = selSmplsTogButPtns;
checkBoxPtns(1)            = checkBoxPtns(1) + DRdata.icon.size;
DRdata.h.legendbutton = uicontrol('style', 'togglebutton','CData',...             % sample selection
    DRdata.icons.legenedids,'units','pixels','Position',checkBoxPtns,...
    'Callback', @uiGetLegends, 'TooltipString','Insert Class Legends');%,...

checkBoxPtns(1)            = checkBoxPtns(1) + DRdata.icon.size;
DRdata.h.switchSampleIds = uicontrol('style', 'checkbox',...                       % swap between sample identifiers
    'fontsize',12,'units','pixels','Position',checkBoxPtns,'Callback', @swithSampleIdsDR,...
    'TooltipString','Show sample identifiers','BackgroundColor',DRdata.mainFig.backgroundcolor);%,
    %'BackgroundColor',DRdata.mainFig.backgroundcolor);
checkBoxPtns(1)            = ax1Ptns(1);
DRdata.h.parallcoordbutton = uicontrol('style', 'togglebutton','CData',...             % sample selection
    DRdata.icons.defaults2,'units','pixels','Position',checkBoxPtns,...
    'Callback', @uishow3DplotDR, 'TooltipString','show 3D plot');%,...
    %'BackgroundColor',DRdata.mainFig.backgroundcolor);

%% User interface for mining of spectral orofiles 
set(DRdata.subplot.h(2),'units','pixels'); 
ax2Ptns              = get(DRdata.subplot.h(2),'Position'); 
localPCPtns(1)       = ax2Ptns(1)+ ax2Ptns(3) - 5.3*DRdata.icon.size;
localPCPtns(2)       = ax2Ptns(2)+ ax2Ptns(4) - 1*DRdata.icon.size;
localPCPtns(3)       = DRdata.icon.size;
localPCPtns(4)       = DRdata.icon.size;
DRdata.h.STOCSY_PB   = uicontrol('style','pushbutton','CData',DRdata.icons.stocsy,'units','pixels',...
    'Position',localPCPtns,'Callback',{@uidoSTOCSY},'TooltipString','STOCSY it');

localPCPtns(1)        = ax2Ptns(1)+ ax2Ptns(3) - 4.3*DRdata.icon.size;
DRdata.h.plotPeakStat = uicontrol('style', 'pushbutton','CData',...
    DRdata.icons.BulletRed,'units','pixels','Position',localPCPtns,...
    'Callback', @uiPlotPeakStat, 'TooltipString','Get Peak Statistics');

% Push Buttons: Local Principal component analysis
set(DRdata.subplot.h(2),'units','pixels');
localPCPtns(1)       = ax2Ptns(1)+ ax2Ptns(3) - 3*DRdata.icon.size;
DRdata.h.defineRegnsForLocalPC  = uicontrol('style', 'pushbutton','CData',...
    DRdata.icons.defineRegions,'units','pixels','Position',localPCPtns,...
    'Callback', @uiDefineRegnsForLocalPC, 'TooltipString','Define regions');
localPCPtns(1)       = localPCPtns(1) + DRdata.icon.size;%+0.05*DRdata.icon.size;
DRdata.h.deleteRegnsForLocalPC = uicontrol('style', 'pushbutton','CData',...
    DRdata.icons.removeRegions,'units','pixels','Position',localPCPtns,...
    'Callback', @uiRemoveRegnsForLocalPC, 'TooltipString','Remove previously selected regions');
localPCPtns(1)       = localPCPtns(1) + DRdata.icon.size;%+0.05*DRdata.icon.size;
DRdata.h.doLocalPC = uicontrol('style', 'pushbutton','CData',...
    DRdata.icons.doLocalPCA2,'units','pixels','Position',localPCPtns,...
    'Callback', @uiDoLocalPC, 'TooltipString','Do dimension reduction analysis on selected regions');

%% User interface for metabolic map
set(DRdata.subplot.h(4),'units','pixels');
ax4Ptns                      = get(DRdata.subplot.h(4),'Position');              % get subplot position
swapBetweenXorRecXorResPB(1) = ax4Ptns(1)+ ax4Ptns(3) - DRdata.icon.size; % adjust positions
swapBetweenXorRecXorResPB(2) = ax4Ptns(2)+ ax4Ptns(4) - DRdata.icon.size;
swapBetweenXorRecXorResPB(3) = DRdata.icon.size;
swapBetweenXorRecXorResPB(4) = DRdata.icon.size;
DRdata.h.swapBetweenXorRecXorRes       = uicontrol('style', 'pushbutton','CData',...             % sample selection
    DRdata.icons.Arrow3,'units','pixels','Position',swapBetweenXorRecXorResPB,...
    'Callback', @swapBetweenXorRecXorRes, 'TooltipString','Show Reconstructed Sample Profiles');
swapBetweenXorRecXorResPB(1) = swapBetweenXorRecXorResPB(1) - DRdata.icon.size;
swapBetweenXorRecXorResPB(2) = swapBetweenXorRecXorResPB(2) - DRdata.icon.size;
DRdata.h.RecPC(1) = uicontrol('style', 'checkbox',...                       % swap between sample identifiers
    'fontsize',12,'units','pixels','Position',swapBetweenXorRecXorResPB,'Callback', @selPCsForRecDR,'Value',1,...
    'TooltipString',['Exclude Component #',num2str(DRdata.PCplot.selPCs(1)),' from profile reconstruction'],'BackgroundColor',[0 0 0]);
swapBetweenXorRecXorResPB(1) = swapBetweenXorRecXorResPB(1) + DRdata.icon.size;
%swapBetweenXorRecXorResPB(2) = swapBetweenXorRecXorResPB(2) + DRdata.icon.size;
DRdata.h.RecPC(2) = uicontrol('style', 'checkbox',...                       % swap between sample identifiers
    'fontsize',12,'units','pixels','Position',swapBetweenXorRecXorResPB,'Callback', @selPCsForRecDR,'Value',1,...
    'TooltipString',['Exclude Component #',num2str(DRdata.PCplot.selPCs(2)),' from profile reconstruction'],'BackgroundColor',[0 0 0]);

% convert plot units to normalized values
set(DRdata.subplot.h(1:4),'Units','normalized');
set(DRdata.subplot.h(1:4), 'DrawMode','fast');
set(DRdata.h.legendbutton,'Selected','off');
set(DRdata.h.selsmpls,'units','normalized');
set(DRdata.h.outliers,'units','normalized');
set(DRdata.h.legendbutton,'units','normalized');
set(DRdata.h.switchSampleIds,'units','normalized');
set(DRdata.h.parallcoordbutton,'units','normalized');
set(DRdata.h.defineRegnsForLocalPC,'units','normalized');
set(DRdata.h.deleteRegnsForLocalPC,'units','normalized');
set(DRdata.h.doLocalPC,'units','normalized');
set(DRdata.h.STOCSY_PB,'units','normalized');
set(DRdata.h.plotPeakStat,'units','normalized');
set(DRdata.h.swapBetweenXorRecXorRes,'units','normalized');
set(DRdata.h.RecPC,'units','normalized');

set(DRdata.h.figure,'renderer',DRdata.renderer);
if strcmp(DRdata.renderer,'OpenGL')
  %  opengl hardware;
  %  opengl('OpenGLDockingBug',1);
  %  opengl('OpenGLBitmapZbufferBug',1);
  %  opengl('OpenGLWobbleTesselatorBug',1);
  %  opengl('OpenGLEraseModeBug',1);
  %  opengl('OpenGLClippedImageBug',1);
  %  opengl('OpenGLLineSmoothingBug',1);
end
return;