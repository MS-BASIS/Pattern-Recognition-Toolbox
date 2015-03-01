function plotPeakStatDR(x, y, p, peakID, grpcolors, markertype, plotparam,methodtype)

if isempty(p)
    p          =  anova1('kruskalwallis',x,y,'off');
    methodtype = 'Kruskal-Wallis ANOVA';
end
    
figure; set(gcf,'Units','normalized')  
h  = gca;
updateFigTitleAndIconMS(gcf,'Peak Statistics','MSINavigatorLogo.png')


hbox = notBoxPlot(x',y); d=[hbox.data]; mu = [hbox.mu];
set(h,'XTick',[]); set(h,'XTickLabel',[]);
nGrps = length(unique(y));
for iGrp = 1:nGrps
    set(d(iGrp),'markerfacecolor',grpcolors(iGrp,:),'color',[0 0 0]);
    set(d(iGrp),'Marker',markertype.type{iGrp}); 
    set(mu(iGrp),'color',grpcolors(iGrp,:));
end

legend([hbox.mu],plotparam.grpIds'); 
set(gca,'FontSize',plotparam.fontsize.axis)
ylabel(h,'Log-intensity value','FontSize',plotparam.fontsize.axislabel); 
title(h,sprintf([methodtype, '\n ', plotparam.xlabel,'=',num2str(peakID), '; p=',num2str(p)]),'FontSize',plotparam.fontsize.axislabel);
return