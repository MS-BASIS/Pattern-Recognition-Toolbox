function selSamplesBoxDR(hAxis,eventdata)

DRdata = guidata(hAxis);
if DRdata.subplot.h(1)~=hAxis&&DRdata.h.LoadMapInScores~=hAxis
    return;
end

doubleclick = strcmp(get(DRdata.h.figure,'SelectionType'),'open');
if doubleclick==1
    DRdata = guidata(hAxis);
    if ~isempty(DRdata.selsamples)||~isempty(DRdata.spsortindcs)
        DRdata = restartPlotsDR(DRdata,doubleclick);
    end
else
    DRdata = guidata(hAxis);
    if DRdata.subplot.h(1)~=hAxis&&DRdata.h.LoadMapInScores~=hAxis
        return;
    end
    
    point1 = get(DRdata.subplot.h(1),'CurrentPoint'); % button down detected
    rbbox;                                                 % return figure units
    point2 = get(DRdata.subplot.h(1),'CurrentPoint'); % button up detected
    point1 = point1(1,1:2);                             % extract x and y
    point2 = point2(1,1:2);
    p1     = min(point1,point2);                        % calculate locations
    offset = abs(point1-point2);                        % and dimensions
    
    %% Rectangle coordinates
    x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
    y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
    if offset == 0
        DRdata = restartPlotsDR(DRdata,1);
    else
        xl = get(DRdata.subplot.h(1),'XLim');
        yl = get(DRdata.subplot.h(1),'YLim');
        
        %% Ignore selection outside of axes
        x(x < xl(1)) = xl(1);
        x(x > xl(2)) = xl(2);
        y(y < yl(1)) = yl(1);
        y(y > yl(2)) = yl(2);
        
        if DRdata.PCplot.stateOM == 1
            scores_x = DRdata.outliers.sd.vals;
            scores_y = DRdata.outliers.od.vals;
        elseif DRdata.PCplot.parallelCoord ==0
            if DRdata.PCplot.CVScores==1
                scores_x = DRdata.cv.T(:,DRdata.PCplot.selPCs(1));
                scores_y = DRdata.cv.T(:,DRdata.PCplot.selPCs(2));
            else
                scores_x = DRdata.scores(:,DRdata.PCplot.selPCs(1));
                scores_y = DRdata.scores(:,DRdata.PCplot.selPCs(2));
            end
        else
            if DRdata.PCplot.CVScores==1
                scores_x = DRdata.cv.T(:,DRdata.PCplot.selPCs(1):DRdata.PCplot.selPCs(2));
                scores_x = scores_x(:);
                scores_y = DRdata.PCplot.parXY.y;
            else
                scores_x = DRdata.PCplot.parXY.x;
                scores_y = DRdata.PCplot.parXY.y;
            end
        end
        selIndcs          = find((scores_x>x(1)&scores_x<x(3))&(scores_y>y(1)&scores_y<y(3)))';
        if ~isempty(selIndcs)
            selIndcs = rem(selIndcs,DRdata.nSmpls);
            selIndcs(selIndcs==0) = DRdata.nSmpls;
        end
        DRdata.selsamples = unique([DRdata.selsamples selIndcs]);
        
        DRdata              = updatePlotsDR(DRdata); % Update spectral profiles & scores plots
        xlims               = get(DRdata.subplot.h(2),'XLim'); % Update maps of spectral
        ylims               = get(DRdata.subplot.h(3),'YLim'); % profiles and sample ids
        if ~isempty(DRdata.sortSelIndcs)
            DRdata.X         = DRdata.X(DRdata.sortSelIndcs,:);
            DRdata.groupdata = DRdata.groupdata(DRdata.sortSelIndcs);
            DRdata.sampleIDs = DRdata.sampleIDs(DRdata.sortSelIndcs);
        end
        [DRdata.selIndcs,DRdata.sortSelIndcs] = getSortIndcsDR(DRdata);
        DRdata.X              = DRdata.X(DRdata.selIndcs,:);
        DRdata.groupdata      = DRdata.groupdata(DRdata.selIndcs);
        DRdata.sampleIDs      = DRdata.sampleIDs(DRdata.selIndcs);
        DRdata                = updateImagePlotsDR(DRdata,xlims,ylims);
        imageSampleIdsDR(DRdata,ylims);
    end
end
guidata(DRdata.h.figure,DRdata);