function zoomcallbackSTOCSY(obj,axis,x,y,xreverse)

double_click    = strcmp(get(obj,'SelectionType'),'open');

if double_click==1
    xlims = [1 length(x)] ;
else
    xlims = floor(get(gca,'XLim'));
    xlims(1) = max(1,xlims(1)); xlims(2) = min(length(x),xlims(2));
end
    
maxSp = max(y(xlims(1):xlims(2)));
minSp = min(y(xlims(1):xlims(2)));
range = maxSp - minSp;
ylims = [minSp-0.1*range maxSp+0.1*range];

set(gca,'XLim',xlims,'YLim',ylims);
[xTickIndcs,xTickLbls]  = getXTickMarks(gca,x);
set(gca,'XTick',xTickIndcs);
set(gca,'XTickLabel',xTickLbls);
if xreverse ==1
    set(gca,'Xdir','reverse');
else
    set(gca,'Xdir','normal');
end
return;