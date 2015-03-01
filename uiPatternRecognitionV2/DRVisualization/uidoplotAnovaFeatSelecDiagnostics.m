function uidoplotAnovaFeatSelecDiagnostics(DRdata)
%% CV Anova Feature Selection Dianostics Plot
% To be used within dimension reduction toolbox cross validation with anova
% feature selection.
% Ottmar Golf

% Get the data from DRdata
pVals = DRdata.cv.anovaFeatSel.pVals;
feat  = DRdata.cv.anovaFeatSel.features;
mz    = DRdata.ppm;

% Scale average mass spectrum to base peak
Sp    = bsxfun(@rdivide,mean(DRdata.Sp,1),max(mean(DRdata.Sp,1),[],2));

% Check if significant peaks were detected
sumFeat = sum(feat,1);
if max(sumFeat)==0; 
    msgbox('No significant features detected. Try higher p-Value threshold?');
else
    % Get top 50 significant features
    meanpVals = mean(pVals,1);
    [~,indcs] = sort(meanpVals);
    topIndcs  = indcs(1:50);
    cmap      = flipud(jet(length(topIndcs)));
    
    % Plot diagnostics figure
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    stem(mz,Sp,'k','marker','none'); hold on
    scatter(mz(topIndcs),Sp(topIndcs),[],meanpVals(topIndcs),'filled'); hold off
    colormap(cmap); hcb = colorbar;
    set(get(hcb,'ylabel'),'String','p-Value')
    labels = num2str(sumFeat(topIndcs)','%d');
    text(mz(topIndcs),Sp(topIndcs)+0.005, labels, 'horizontal','center', 'vertical','bottom')
    legend(gca,{'Mean Mass Spectrum','p-Value'});
    xlabel('m/z');
    ylabel('Basepeak-normalised Intensity');
    title({'Diagnostics plot of anova feature selection','Labeled peaks: Colours represent p-Value - Numbers show how often peak was considered significant in cross validtion iterations'});
    set(h,'color','w');
end
end

