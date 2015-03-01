function DRdata = plotGradLoadMapDR(DRdata,xlims,ylims,PCs)
%% plotGradLoadMap creates an image graphics or lineplot object of loadings
%%                 values
%           Input: DRdata - data of DR toolbox objects
%                  xlims  - limits of the x axis
%                  ylims  - limits of the y axis
%                  PCs    - selected PCs
%% Author: Kirill A. Veselkov, Imperial College London, 2011. 

nCells   = 15;
loadings = DRdata.loadings(:,PCs);
PCsel    = find(DRdata.PCplot.selPCsForRecs==1);
    
if any(loadings<0)
    maxLimX = max(abs(xlims));
    maxLimY = max(abs(ylims));
    deltax  = (2*maxLimX)/(2*nCells-1);
    deltay  = (2*maxLimY)/(2*nCells-1);
    xdata   = -maxLimX:deltax:maxLimX;
    ydata   = -maxLimY:deltay:maxLimY;
    if PCsel == 1
        colorMatrix = repmat(-1:1/nCells:1,nCells*2,1);
        colorMatrix(:,nCells+1)=[];
    elseif PCsel ==2
        colorMatrix = repmat(1:-1/nCells:-1,nCells*2,1);
        colorMatrix(:,nCells+1)=[];
        colorMatrix = colorMatrix';
    else
        colorMatrix = getGradColLoadMapDR(nCells,0);
    end
    colorMap    = DRdata.colormap.loadingsPCA;
else
    deltax = (xlims(2)-xlims(1))/(2*nCells-1);
    deltay = (ylims(2)-ylims(1))/(2*nCells-1);
    xdata  = xlims(1):deltax:xlims(2);
    ydata  = ylims(1):deltay:ylims(2);
    if PCsel == 1
        colorMatrix = repmat(-1:1/nCells:1,nCells*2,1);
        colorMatrix(:,nCells+1)=[];
    elseif PCsel ==2
        colorMatrix = repmat(1:-1/nCells:-1,nCells*2,1);
        colorMatrix(:,nCells+1)=[];
        colorMatrix = colorMatrix';
    else
        colorMatrix = getGradColLoadMapDR(nCells,1);
    end
    colorMap    = DRdata.colormap.loadingsNMF;
end
colorMatrix              = flipdim(colorMatrix,1);
DRdata.h.LoadMapInScores = pcolor(xdata,ydata,colorMatrix);
shading interp
setUniqAxesMap(gca, colorMap);
set(DRdata.h.LoadMapInScores,'Visible','off');
return;

function colorMatrix = getGradColLoadMapDR(nCells,posLoadings)
%% getGradColLoadMapDR calculates color matrix for loadings map
%% Author: Kirill A. Veselkov, Imperial College 2011.
if nargin<2 || posLoadings==1
    posLoadings = 1;
    nCells      = nCells*2;
end

upperRightSq = ones(1,nCells);
upperLeftSq  = ones(1,nCells);
lowerLeftSq  = ones(1,nCells);
lowerRightSq = ones(1,nCells);

for i =1:nCells
    upperRightSq(nCells+1-i,:) = (1:nCells)+i-1;
end

if posLoadings ==1;
    colorMatrix = upperRightSq;
else
    for i =1:nCells
        lowerLeftSq(i,:) = (nCells:-1:1)+i-1;
    end
    lowerLeftSq  = - lowerLeftSq;
    
    for i =1:nCells
        upperLeftSq(nCells+1-i,:) = (nCells:-1:1)+i-1;
    end
    upperLeftSq((upperLeftSq+1)/2~=round((upperLeftSq+1)/2))=...
        -upperLeftSq((upperLeftSq+1)/2~=round((upperLeftSq+1)/2));
    
    for i =1:nCells
        lowerRightSq(i,:) = (1:nCells)+i-1;
    end
    lowerRightSq(lowerRightSq/2~=round(lowerRightSq/2))=...
        -lowerRightSq(lowerRightSq/2~=round(lowerRightSq/2));
    colorMatrix = [upperLeftSq,upperRightSq;lowerLeftSq,lowerRightSq];
    
end
colorMatrix = colorMatrix./max(colorMatrix(:));
return;