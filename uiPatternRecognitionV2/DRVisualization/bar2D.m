function hbar = bar2D(x,y,cdata,colorMap)
%% barh constructs of x versus y coloroded with cdata using defined colormap

% Author: Kirill A. Veselkov, Imperial College London, 2015.
if nargin<4
    colorMap = jet;
end
tic;
[nrows,ncols] = size(colorMap);
if nrows == 3
    nColors  = ncols;
    colorMap = colorMap';
else
    nColors = nrows;
end

cdata = cdata - min(cdata);
cdata = cdata./max(cdata);
cdata = floor(cdata*(nColors-1)) + 1;
ytemp = NaN(1,length(x));
hold on;
for i = 1:nColors
    indcs        = cdata==i;
    if sum(indcs)~=0
        ytemp(indcs) = y(indcs);
        hbar = bar(x,ytemp,'FaceColor',colorMap(i,:));
        ytemp(indcs) = NaN;
    end
end
hold off;
return;