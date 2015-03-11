function [hSTOCSY,CovXY] = STOCSY(Sp,X,ppm,peakID,pthr,CCmetric,barplot,DRdata)
% Description: this function performs the STOCSY analysis on a selected
% peak intensity variable defined by the PeakID chemical shift

%Input:  X =any data matrix of dimension observation-by-variables
%           ppm = a vector of NMR chemical shifts
%           peakID - the chemical shift value of an intensity variable for STOCSY 
%           CCmetric – the selection of correlation coefficient measure {'pearson'  or 'spearman', by default ‘pearson’}
%           pthr - the threshold p-value for testing the hypothesis   of no correlation (by default 0.1)

%Output: CC - correlation coefficients between NMR peakID
%        intensity variable and all other variables


% Author: Kirill Veselkov, Imperial College 2009

[nsmpls, nvrbls]=size(X);

if nsmpls>nvrbls
    warning('a data set needs to be arranged in a input matrix observation-by-variables');
end

if nargin<5
    CCmetric='pearson';
end

if nargin<4||isempty(pthr)
    pthr=0.1;
end

if nargin<6
    barplot = 0;
end

if ppm(1)>ppm(2)
    ppm=sort(ppm);
end

if nargin == 8
    axlabelfontsize = DRdata.fontsize.axislabel + 4;
    axtitlefontsize = DRdata.fontsize.title + 4;
    axisfontsize    = DRdata.fontsize.axis + 3; 
    renderer        = DRdata.renderer;
else
    axlabelfontsize = 18;
    axtitlefontsize = 24;
    axisfontsize    = 16; 
    renderer        = 'zbuffer';
end

peakIndex=find(ppm>=peakID,1,'first');
%peakIndex=peakID;
Y=X(:,peakIndex);

[CCXY,pXY]     = corrcoeffs(X,Y,CCmetric);
CCXY(pXY>pthr) = 0;
meanSp         = mean(Sp);
Sp             = Sp-(meanSp(ones(1,nsmpls),:));
CovXY          = Sp'*(Y-mean(Y))./(nsmpls-1);

if size(ppm,1)>size(ppm,2)
    ppm=ppm';
end
%fullscreen         = get(0,'ScreenSize');
%[fullscreen,~,~] = getDefaultScreenSize();
hSTOCSY          = figure('Units','normalized',...
    'OuterPosition',[0 0 1 1],'Renderer',renderer,'menu','none','Color',[1 1 1]);
updateFigTitleAndIconMS(hSTOCSY,'STOCSY','MSINavigatorLogo.png')

[ignore,hCB]       = plotCCValues(1:length(ppm),CovXY',abs(CCXY'),0,1,[],barplot);
xlim([1 length(ppm)]);
%xlabel('\delta,ppm','FontSize',18);
if DRdata.NMR==1
    DRdata.SPplot.xreverse                 = 1;
    DRdata.SPplot.xlabel                   = '1H ppm';
    %% Bucketted data
else
    DRdata.SPplot.xreverse                 = 0;
    DRdata.SPplot.xlabel                   = 'MZ';
end
xlabel( DRdata.SPplot.xlabel ,'FontSize',axlabelfontsize);
set(get(hCB,'ylabel'),'String', 'abs(correlation coefficient)','FontSize',axlabelfontsize);
ylabel(['Covariance(X,'  DRdata.SPplot.xlabel '= ',num2str(peakID),')'],'FontSize',axlabelfontsize);
%set(gca,'YAxisLocation','Right');
%set(gca,'xAxisLocation','Top');
title(['STOCSY',' (',  DRdata.SPplot.xlabel ' = ',num2str(peakID),')'],'FontSize',axtitlefontsize);
if DRdata.SPplot.xreverse == 1
    set(gca,'XDir','reverse');
end
set(gca,'FontSize',axisfontsize);