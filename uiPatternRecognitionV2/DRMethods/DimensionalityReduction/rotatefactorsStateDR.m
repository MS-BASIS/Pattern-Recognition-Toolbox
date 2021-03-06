function rotatefactorsStateDR(hMainFigure,eventdata)
%% rotatefactorsStateDR creates menu for factor rotation
%% Author: Kirill A. Veselkov, Imperial College 2011. Prototype of pattern
%% recognisition toolbox. 

DRdata = guidata(hMainFigure);
if strcmp(get(hMainFigure,'State'),'on');
    posPCPlot = get(DRdata.subplot.h(1),'Position');
    DRdata.h.rotateFactorsButtonGroup(1) =...
        uibuttongroup('Parent',DRdata.h.figure,'Title','Rotate Factors',...
        'Position',[0,0,posPCPlot(3)./2,posPCPlot(4)],'FontSize',...
        DRdata.fontsize.axislabel-4,'BackgroundColor',...
        DRdata.mainFig.backgroundcolor,'SelectionChangeFcn',{@uirotatefactorsDR},...
        'visible','off');
    DRdata.h.rotateFactorsButtonGroup(2) = uicontrol(DRdata.h.rotateFactorsButtonGroup(1),...
        'Style','radiobutton','KeyPressFcn',{@uirotatefactorsDR},...
        'String','no rotation', 'Units','normalized','FontSize',...
        DRdata.fontsize.axis-2,'Position',[.1 .8 0.8 .2],'BackgroundColor',...
        DRdata.mainFig.backgroundcolor);
    DRdata.h.rotateFactorsButtonGroup(3) = uicontrol(DRdata.h.rotateFactorsButtonGroup(1),...
        'Style','radiobutton',...
        'String','varimax', 'Units','normalized','FontSize',...
        DRdata.fontsize.axis-2,...
        'Position',[.1 .6 0.8 .2],'BackgroundColor',...
        DRdata.mainFig.backgroundcolor);
    DRdata.h.rotateFactorsButtonGroup(4) = uicontrol(DRdata.h.rotateFactorsButtonGroup(1),...
        'Style','radiobutton',...
        'String','quartimax','Units','normalized','FontSize',...
        DRdata.fontsize.axis-2,...
        'Position',[.1 .4 0.8 .2],...
        'BackgroundColor',DRdata.mainFig.backgroundcolor);
    DRdata.h.rotateFactorsButtonGroup(5)  = uicontrol(DRdata.h.rotateFactorsButtonGroup(1),...
        'Style','radiobutton',...
        'String','equamax','Units','normalized','FontSize',...
        DRdata.fontsize.axis-2,...
        'Position',[.1 .2 0.8 0.2],...
        'BackgroundColor',DRdata.mainFig.backgroundcolor);
    DRdata.h.rotateFactorsButtonGroup(6)  = uicontrol(DRdata.h.rotateFactorsButtonGroup(1),...
        'Style','radiobutton',...
        'String','promax','Units','normalized','FontSize',...
        DRdata.fontsize.axis-2,...
        'Position',[.1 0 0.8 0.2],...
        'BackgroundColor',DRdata.mainFig.backgroundcolor);
    posPCPlot       = get(DRdata.subplot.h(1),'OuterPosition');
    posButtonGroup  = get(DRdata.h.rotateFactorsButtonGroup(1),'Position');
    set(DRdata.h.rotateFactorsButtonGroup(1),'Position',...
        [posPCPlot(1) posPCPlot(2)-posButtonGroup(4)*1.2 posButtonGroup(3:4)],...
        'visible','on');
    DRdata.nonrot_loadings = DRdata.loadings;
    DRdata.nonrot_scores   = DRdata.scores;
    DRdata.nonrot_PCvar    = DRdata.PCvar ;
else
    delete(DRdata.h.rotateFactorsButtonGroup);
    DRdata.loadings = DRdata.nonrot_loadings;
    DRdata.scores   = DRdata.nonrot_scores;
    DRdata.PCvar    = DRdata.nonrot_PCvar;
end
guidata(hMainFigure,DRdata);
return;