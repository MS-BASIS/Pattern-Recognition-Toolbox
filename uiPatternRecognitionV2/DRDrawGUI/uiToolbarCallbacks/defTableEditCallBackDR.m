function defTableEditCallBackDR(hTable,eventdata)
%% defTableEditCallBackDR updates properties of DR objects
%    Input: hTable - a table handle
%% Author: Kirill A. Veselkov, Imperial College 2011.

DRdata     = guidata(get(hTable,'Parent'));
tag        = get(hTable,'Tag');
table1data = get(DRdata.h.Def.Table1,'Data');
table2data = get(DRdata.h.Def.Table2,'Data');
if strcmp(tag,'MarkerSettings')
    iGrp                            = eventdata.Indices(1);
    DRdata.spcolors(iGrp,:)         = str2num(table1data{iGrp,2});
    DRdata.marker.color{iGrp}       = str2num(table1data{iGrp,2});
    DRdata.PCplot.marker.fill{iGrp} = table1data{iGrp,3};
    DRdata.PCplot.marker.type{iGrp} = table1data{iGrp,4};
    DRdata.groupIds{iGrp}           = table1data{iGrp,1};
    if ~isempty(DRdata.PCplot.spIndcs)
        spindcs = DRdata.PCplot.spIndcs;
    else
        spindcs = 1:length(DRdata.groupdata);
    end
    if ~isempty(DRdata.selsamples)
        DRdata = redrawallplots(DRdata);
    end
    
    if eventdata.Indices(2)==2;     % update spectra
        %DRdata = scatter2D(DRdata,DRdata.PCplot.selPCs(1),DRdata.PCplot.selPCs(2));
        ylims  = get(DRdata.subplot.h(3),'YLim');
        imageSampleIdsDR(DRdata,ylims);
        set(DRdata.h.spectra(DRdata.groups(spindcs)==iGrp),...
            'Color', DRdata.marker.color{iGrp});
    elseif eventdata.Indices(2)==5 % re-group samples
        if ~isempty(DRdata.selsamples)
            disp('Samples need not to be seletected...');
            return;
        end
        nGrps = length(DRdata.groupIds);
        order = zeros(1,nGrps);
        for iGrp = 1:nGrps
            order(iGrp) = str2num(table1data{iGrp,5});
        end
        if length(unique(order))~=nGrps
            return;
        else
            [a,order] = sort(order);
            DRdata = sortGroupsDR(DRdata,order);
            xlims  = get(DRdata.subplot.h(2),'XLim');
            ylims  = get(DRdata.subplot.h(3),'YLim');
            imageSampleIdsDR(DRdata,ylims);
            DRdata = updateImagePlotsDR(DRdata,xlims,ylims);
            delete(DRdata.h.Def.Table1,DRdata.h.Def.Table2,...
                DRdata.h.Def.PB1,DRdata.h.Def.PB2);
            DRdata = uiDRchangeFigDefaults(DRdata);
        end
        guidata(DRdata.h.figure,DRdata);
        return;
    end
    
    %% update PC score plot
    if DRdata.PCplot.marker.fill{iGrp}==1
        set(DRdata.h.markers(DRdata.groupdata(spindcs)==iGrp),...
            'Marker', DRdata.PCplot.marker.type{iGrp},...
            'Color', [0 0 0],...
            'MarkerFaceColor',DRdata.marker.color{iGrp},...
            'MarkerSize', DRdata.PCplot.marker.size,...
            'LineWidth',max(DRdata.PCplot.marker.linewidth-1,1));
    else
        set(DRdata.h.markers(DRdata.groupdata(spindcs)==iGrp),...
            'Marker', DRdata.PCplot.marker.type{iGrp},...
            'Color', DRdata.marker.color{iGrp},...
            'MarkerFaceColor',[1 1 1],...
            'MarkerSize', DRdata.PCplot.marker.size,...
        'LineWidth',DRdata.PCplot.marker.linewidth);
    end
    
    set(DRdata.h.text(DRdata.groupdata(spindcs)==iGrp),...
        'Color', DRdata.marker.color{iGrp});
    updatePlotsDR(DRdata);
elseif strcmp(tag,'ImageSettings')
    DRdata.PCplot.marker.selcolor            = str2num(table2data{1,2});
    DRdata.SPplot.linewidth                  = str2num(table2data{2,2});
    DRdata.SPplot.linewitdthIncrease         = str2num(table2data{3,2});
    DRdata.fontsize.sampleIds                = str2num(table2data{4,2});
    DRdata.fontsize.axis                     = str2num(table2data{5,2});
    DRdata.fontsize.axislabel                = str2num(table2data{6,2});
    DRdata.fontsize.title                    = str2num(table2data{7,2});
    DRdata.PCplot.marker.linewidth           = str2num(table2data{8,2});
    DRdata.PCplot.marker.size                = str2num(table2data{9,2});
    DRdata.PCplot.marker.zoomMarSizeIncrease = str2num(table2data{10,2});
    DRdata.SPplot.regions.color              = str2num(table2data{11,2});
    DRdata.renderer                          = table2data{12,2};
    DRdata.peakPickedData                    = str2num(table2data{13,2});
    DRdata.SPplot.xlabel                     = table2data{14,2};
    DRdata.SPplot.xreverse                   = table2data{15,2};
    DRdata.PCplot.maxNumPoints               = table2data{16,2};
    DRdata.PCplot.minNumClassPoints          = table2data{17,2};
   
    set(DRdata.h.figure,'renderer',DRdata.renderer);
    if strcmp(DRdata.renderer,'OpenGL')
    %    opengl hardware;
    %    opengl('OpenGLDockingBug',1);
    %    opengl('OpenGLBitmapZbufferBug',1);
    %    opengl('OpenGLWobbleTesselatorBug',1);
    %    opengl('OpenGLEraseModeBug',1);
    %    opengl('OpenGLClippedImageBug',1);
    %    opengl('OpenGLLineSmoothingBug',1);
    end
    DRdata = redrawallplots(DRdata);
   % updatePlotsDR(DRdata);
elseif strcmp(tag,'OK')
    delete([DRdata.h.Def.Table1,DRdata.h.Def.Table2,...
        DRdata.h.Def.PB1,DRdata.h.Def.PB2]);
    return;
elseif strcmp(tag,'Make as defaults')
    defaults.marker                         = DRdata.marker;
    defaults.SPplot                         = DRdata.SPplot;
    defaults.PCplot                         = DRdata.PCplot;
    defaults.marker.selcolor                   = str2num(table2data{1,2});
    defaults.SPplot.linewidth                  = str2num(table2data{2,2});
    defaults.SPplot.zoomLinewidthIncrease      = str2num(table2data{3,2});
    defaults.fontsize.sampleIds                = str2num(table2data{4,2});
    defaults.fontsize.axis                     = str2num(table2data{5,2});
    defaults.fontsize.axislabel                = str2num(table2data{6,2});
    defaults.fontsize.title                    = str2num(table2data{7,2});
    defaults.PCplot.marker.linewidth           = str2num(table2data{8,2});
    defaults.PCplot.marker.size                = str2num(table2data{9,2});
    defaults.PCplot.marker.zoomMarSizeIncrease = str2num(table2data{10,2});
    defaults.SPplot.regions.color              = str2num(table2data{11,2});
    defaults.renderer                          = table2data{12,2};
    defaults.peakPickedData                    = str2num(table2data{13,2});
    defaults.xlabel                            = table2data{14,2};
    defaults.xreverse                          = table2data{15,2};
    defaults.maxNumPoints                      = table2data{16,2};
    defaults.minNumClassPoints                 = table2data{17,2};
    
    nGrps                  = size(table1data,1);
    defaults.marker.colors = ones(nGrps,3);
    for iGrp = 1:nGrps
        defaults.spcolors(iGrp,:) = str2num(table1data{iGrp,2});
        defaults.spcolor{iGrp}    = str2num(table1data{iGrp,2});
        defaults.PCplot.marker.fill{iGrp}     = table1data{iGrp,3};
        defaults.PCplot.marker.type{iGrp}     = table1data{iGrp,4};
    end
    delete([DRdata.h.Def.Table1,DRdata.h.Def.Table2,...
        DRdata.h.Def.PB1,DRdata.h.Def.PB2]);
    defaultsPR = defaults;
    load([DRdata.currentFolder,'\msidefaults.mat']);
    defaults.PatternRecognition = defaultsPR;
    save msidefaults defaults
    return;
end
guidata(DRdata.h.figure,DRdata);