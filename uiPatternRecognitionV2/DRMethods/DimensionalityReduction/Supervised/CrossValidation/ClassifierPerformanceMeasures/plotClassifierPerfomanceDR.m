function DRdata = plotClassifierPerfomanceDR(DRdata)
%% plotClassifierPerfomanceDR visualizes different performance measures of
%% a selected classifier construced based on extracted discriminating feautures
%   %     Input: DRdata      - data objects of dimension reduction toolbox
%            doubleclick - if yes, double click was initiated
%% Author: Kirill Veselkov, Imperial College London, 2011. 


%% install figure
fullscreen = get(0,'ScreenSize');
%[fullscreen,~,~] = getDefaultScreenSize();
hFig = figure('Units', 'normalized', ...
    'OuterPosition',[0 0 1 1],...
    'Color',DRdata.mainFig.backgroundcolor);
updateFigTitleAndIconMS(hFig,'Cross Validation Diagnostics','MSINavigatorLogo.png');


%% classification accuracy
subplot(3,5,1:2);
bar(DRdata.cv.accuracy','FaceColor',[0 0 1]);
[value,index] = max(DRdata.cv.accuracy);
hold on; bar(index,value','FaceColor',[1 0 0]); hold off;
set(gca,'FontSize',DRdata.fontsize.axis)
ylabel({'classification accuracy (%)'},'FontSize',DRdata.fontsize.axislabel-1)
xlabel({'Component'},'FontSize',DRdata.fontsize.axislabel-1);
title({['The highest accuracy = ',num2str(DRdata.cv.accuracy(index),'%0.1f'),'%']},'FontSize',DRdata.fontsize.axislabel+1);

%% Cumulative cross validated variance
subplot(3,5,4:5);
bar(DRdata.cv.cumRsq','FaceColor',[0 0 1]);
ylabel({'variance (%)'},'FontSize',DRdata.fontsize.axislabel-1)
xlabel({'Component'},'FontSize',DRdata.fontsize.axislabel-1);
title({'Cumulative  variance'},...
    'FontSize',DRdata.fontsize.axislabel+1);
hold on; bar(index,DRdata.cv.cumRsq(index)','FaceColor',[1 0 0]); hold off;


%% Classification confusion matrix
subplot(3,5,[7:9 12:14]);
DRdata.cv.confMat   = getConfMatDR(DRdata.groupdata,DRdata.cv.predclass(:,index));
DRdata.cv.predclass = DRdata.cv.predclass(:,index);
plotConfMatDR(DRdata.cv.confMat,DRdata.groupIds,DRdata.fontsize.axislabel);
%% Super title: Cross Validation method

[ign,h3] = suplabel([DRdata.cv.Name,' Cross-Validation','; ',' Classifier: ',DRdata.cv.classifierName]  ,'t');
set(h3,'FontSize',DRdata.fontsize.title);