function DRdata = choosePCsDR(DRdata)
%% choosePCsDR sets "PCs selection title" on the score plot
%              DRdata - objects of DR toolbox
%% Author: Kirill A. Veselkov, Imperial College London 2011.
if DRdata.PCplot.stateOM == 0
    title(DRdata.subplot.h(1),'');
    if ishandle(DRdata.h.choosePCs)
        delete(DRdata.h.choosePCs)
        DRdata.h.choosePCs = [];
    end
    if DRdata.PCplot.CVScores==1
       DRdata.h.choosePCs(1) = uicontrol('Style', 'text', 'String',...
            'Cross Validated Component ','units','normalized','FontSize',DRdata.fontsize.title+1,...
            'Visible','off','BackgroundColor',DRdata.mainFig.backgroundcolor);
    else
        DRdata.h.choosePCs(1) = uicontrol('Style', 'text', 'String',...
            'Component ','units','normalized','FontSize',DRdata.fontsize.title+1,...
            'Visible','off','BackgroundColor',DRdata.mainFig.backgroundcolor);
    end
    if DRdata.PCplot.parallelCoord == 0
        DRdata.h.choosePCs(2) = uicontrol('Style', 'text', 'String',...
            ' VS ','units','normalized','FontSize',DRdata.fontsize.title-2,...
            'Visible','off','BackgroundColor',DRdata.mainFig.backgroundcolor);
    elseif DRdata.PCplot.parallelCoord
        DRdata.h.choosePCs(2) = uicontrol('Style', 'text', 'String',...
            ' TO ','units','normalized','FontSize',DRdata.fontsize.title-2,...
            'Visible','off','BackgroundColor',DRdata.mainFig.backgroundcolor);
    end
    posText1      = get(DRdata.h.choosePCs(1),'Extent');
    posText2      = get(DRdata.h.choosePCs(2),'Extent');
    posSB1        = get(DRdata.subplot.h(1),'Position');
    posText1(1)   = posSB1(1);
    posText1(2)   = posSB1(2)+posSB1(4)+posText2(4)+0.2*posText2(4);
    set(DRdata.h.choosePCs(1),'Position',posText1,'Visible','on');
    
    posText2(1) = posSB1(1) + posText2(3);
    posText2(2) = posSB1(2) + posSB1(4)+0.2*posText2(4);
    set(DRdata.h.choosePCs(2),'Position',posText2,'Visible','on');
    
    posEdit1    = posText2;
    posEdit1(1) = posEdit1(1) - posText2(3);
    DRdata.h.choosePCs(3) = uicontrol('Style', 'Edit', 'String',...
        num2str(DRdata.PCplot.selPCs(1)),'units','normalized','FontSize',DRdata.fontsize.title-1,...
        'Position',posEdit1,'Visible','on','BackgroundColor',DRdata.mainFig.backgroundcolor,...
        'CallBack',@updateScatterPlotWithPCSelection);
    
    posEdit2    = posText2;
    posEdit2(1) = posEdit2(1) + posText2(3);
    DRdata.h.choosePCs(4) = uicontrol('Style', 'Edit', 'String',...
        num2str(DRdata.PCplot.selPCs(2)),'units','normalized','FontSize',DRdata.fontsize.title-1,...
        'Position',posEdit2,'Visible','on','BackgroundColor',DRdata.mainFig.backgroundcolor,...
        'CallBack',@updateScatterPlotWithPCSelection);
    
    delta1 = posSB1(3) - (posEdit2(1)+posEdit2(3)-posEdit1(1));    
    %% if 3D plot add additional button:
    if DRdata.PCplot.plot3D == 1
        posText3 = posText2; posText3(1) = posEdit2(1) + posEdit2(3);
        DRdata.h.choosePCs(5) = uicontrol('Style', 'text', 'String',...
            ' VS ','units','normalized','FontSize',DRdata.fontsize.title-2,...
            'Visible','off','BackgroundColor',DRdata.mainFig.backgroundcolor,'Position',posText2);
        set(DRdata.h.choosePCs(5),'Position',posText3,'Visible','on');
        
        posEdit3 = posText3; posEdit3(1) = posText3(1) + posText3(3);
        DRdata.h.choosePCs(6) = uicontrol('Style', 'Edit', 'String',...
            num2str(DRdata.PCplot.selPCs(3)),'units','normalized','FontSize',DRdata.fontsize.title-1,...
            'Position',posEdit2,'Visible','on','BackgroundColor',DRdata.mainFig.backgroundcolor,...
            'CallBack',@updateScatterPlotWithPCSelection);
        set(DRdata.h.choosePCs(6),'Position',posEdit3,'Visible','on');       
        delta1 = posSB1(3) - (posEdit3(1)+posEdit3(3)-posEdit1(1));
    end
    
    if delta1 > 0
        delta1 = delta1/2;
    end
    delta2 = posSB1(3)-posText1(3);
    if delta2 > 0
        delta2 = delta2/2;
    end
    
    posText1(1) = posText1(1) + delta2;
    posText2(1) = posText2(1) + delta1;
    posEdit1(1) = posEdit1(1) + delta1;
    posEdit2(1) = posEdit2(1) + delta1;
    set(DRdata.h.choosePCs(1),'Position',posText1);
    set(DRdata.h.choosePCs(2),'Position',posText2);
    set(DRdata.h.choosePCs(3),'Position',posEdit1);
    set(DRdata.h.choosePCs(4),'Position',posEdit2);
    if DRdata.PCplot.plot3D == 1
        posText3(1) = posText3(1) + delta1;
        posEdit3(1) = posEdit3(1) + delta1;
        set(DRdata.h.choosePCs(5),'Position',posText3);
        set(DRdata.h.choosePCs(6),'Position',posEdit3);
    end
        
else
    if ishandle(DRdata.h.choosePCs)
        delete(DRdata.h.choosePCs)
        DRdata.h.choosePCs  = [];
    end    
    outPos1        = get(DRdata.subplot.h(1),'Position');
    outPos2        = get(DRdata.subplot.h(2),'Position');
    outPos1([2,4]) = outPos2([2,4]);
    title(DRdata.subplot.h(1),'Outlier Map','FontSize',DRdata.fontsize.title);
    set(DRdata.subplot.h(1),'Position',outPos1);
end