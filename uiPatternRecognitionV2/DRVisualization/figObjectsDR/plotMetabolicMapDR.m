function DRdata = plotMetabolicMapDR(DRdata,xlims,ylims)
%% plotSpectraRedDR creates an image object of log fold changes of spectra
%%                  of biological samples
%                  Input: DRdata - data of dimension reduction objects
%                         values - loadings or explained variable variances
%                         xlims  - limits of x axes
%                         ylims  - limits of y axes
%% Author: Kirill A. Veselkov, Imperial College London, 2011. 

set(DRdata.h.figure,'CurrentAxes',DRdata.subplot.h(4)); 
delete(get(DRdata.subplot.h(4),'Children'));

if nargin<2
    xlims = [];
end
if nargin < 3
    ylims = [];
end
[xlims,ylims] = getMapAxisLimitsDR(DRdata,xlims,ylims);
    
%% Show i) sample profiles ii) recontructed sample profiles and iii) sample residuals
imageTitle = 'Sample profiles';
if ~isempty(DRdata.h.swapBetweenXorRecXorRes)
    ids = get(DRdata.h.swapBetweenXorRecXorRes,'TooltipString');
else
    ids = 'Show Reconstructed Sample Profiles';
end
if strcmp(ids,'Show Reconstructed Sample Profiles');
    refX = median(DRdata.X);
    X = DRdata.X - refX(ones(1,DRdata.nSmpls),:);
elseif strcmp(ids,'Show Residuals');
    if ~isempty(DRdata.selsamples)
        selIndcs = DRdata.selIndcs;
    elseif ~isempty(DRdata.spsortindcs)
        selIndcs = DRdata.spsortindcs;
    else
        selIndcs = 1:DRdata.nSmpls;
    end
    if DRdata.PCplot.stateOM == 0
        selPCsForRecs = DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1);
    else
        selPCsForRecs = 1:size(DRdata.loadings,2);
    end
    X             = DRdata.scores(selIndcs,selPCsForRecs)*DRdata.loadings(:,selPCsForRecs)';
    if ~isempty(DRdata.meanX)
        X         = X + DRdata.meanX(ones(1,DRdata.nSmpls),:);
    end
    refX = median(DRdata.X);
    X = X - refX(ones(1,DRdata.nSmpls),:);
    imageTitle = 'Reconstructed sample profiles';
elseif strcmp(ids,'Show Sample Profiles');
    if ~isempty(DRdata.selsamples)
        selIndcs  = DRdata.selIndcs;
    elseif ~isempty(DRdata.spsortindcs)
        selIndcs = DRdata.spsortindcs;
    else
        selIndcs  = 1:size(DRdata.X,1);
    end
    if DRdata.PCplot.stateOM == 0
        selPCsForRecs = DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1);
    else
        selPCsForRecs = 1:size(DRdata.loadings,2);
    end
    RecX          = DRdata.scores(selIndcs,selPCsForRecs)*DRdata.loadings(:,selPCsForRecs)';
    if ~isempty(DRdata.meanX)
        RecX          = RecX + DRdata.meanX(ones(1,DRdata.nSmpls),:);
    end
    X             = DRdata.X - RecX;
    imageTitle = 'Residuals';
end


imagesc([xlims(1) xlims(2)],[ylims(1) ylims(2)],...
    single(X(ylims(1):DRdata.redRatio:ylims(2),xlims(1):DRdata.redRatio:xlims(2))));
%[xTickIndcs]  = getXTickMarks(DRdata.subplot.h(4),DRdata.ppm);
%set(gca,'XTick',xTickIndcs);
set(gca,'XTickLabel',[]);
if DRdata.SPplot.xreverse ==1
    set(DRdata.subplot.h(4),'Xdir','reverse');
else
    set(DRdata.subplot.h(4),'Xdir','normal');
end
set(gca,'YTickLabel',[]);
if ~ischar(DRdata.SPplot.xlabel)
    xlabel('{\delta}^{ 1}H ppm','FontSize',DRdata.fontsize.axislabel);
else
    xlabel(DRdata.SPplot.xlabel,'FontSize',DRdata.fontsize.axislabel);
end

text(0.01,0.99,imageTitle,'units','normalized',...
    'HorizontalAlignment','Left','VerticalAlignment','top','EdgeColor','none',...
    'Color',[1 1 1],'FontSize',DRdata.fontsize.axis);

%% Set colormap
if isempty(DRdata.image.clims)
    clim     = max(abs(X(:)));
    DRdata.image.clims = [-clim clim];
end
set(gca,'CLim',DRdata.image.clims);
%colorMap = [0,1,0;0,0.954367220401764,0;0,0.908734381198883,0;0,0.863101601600647,0;0,0.817468822002411,0;0,0.771835982799530,0;0,0.726203203201294,0;0,0.680570423603058,0;0,0.634937584400177,0;0,0.589304804801941,0;0,0.543672025203705,0;0,0.498039215803146,0;0,0.474323064088821,0;0,0.450606912374496,0;0,0.426890760660172,0;0,0.403174608945847,0;0,0.379458457231522,0;0,0.355742305517197,0;0,0.332026153802872,0;0,0.308310002088547,0;0,0.284593850374222,0;0,0.260877698659897,0;0,0.237161532044411,0;0,0.213445380330086,0;0,0.189729228615761,0;0,0.166013076901436,0;0,0.142296925187111,0;0,0.118580766022205,0;0,0.0948646143078804,0;0,0.0711484625935555,0;0,0.0474323071539402,0;0,0.0237161535769701,0;0,0,0;0.0428571440279484,0.0142857143655419,0;0.0857142880558968,0.0285714287310839,0;0.128571435809135,0.0428571440279484,0;0.171428576111794,0.0571428574621677,0;0.214285716414452,0.0714285746216774,0;0.257142871618271,0.0857142880558968,0;0.300000011920929,0.100000001490116,0;0.342857152223587,0.114285714924335,0;0.385714292526245,0.128571435809135,0;0.428571432828903,0.142857149243355,0;0.471428602933884,0.157142862677574,0;0.514285743236542,0.171428576111794,0;0.557142853736877,0.185714289546013,0;0.600000023841858,0.200000002980232,0;0.614532887935638,0.197693198919296,0;0.629065752029419,0.195386394858360,0;0.643598616123200,0.193079590797424,0;0.658131480216980,0.190772786736488,0;0.672664403915405,0.188465982675552,0;0.687197268009186,0.186159178614616,0;0.701730132102966,0.183852374553680,0;0.716262996196747,0.181545570492744,0;0.730795860290527,0.179238751530647,0;0.745328724384308,0.176931947469711,0;0.759861588478088,0.174625143408775,0;0.774394452571869,0.172318339347839,0;0.788927376270294,0.170011535286903,0;0.803460240364075,0.167704731225967,0;0.817993104457855,0.165397927165031,0;0.832525968551636,0.163091123104095,0;0.847058832645416,0.160784319043159,0;];
colorMap = [1,1,1;0.941176474094391,1,1;0.882352948188782,1,1;0.823529422283173,1,1;0.764705896377564,1,1;0.705882370471954,1,1;0.647058844566345,1,1;0.588235318660736,1,1;0.529411792755127,1,1;0.470588237047195,1,1;0.411764711141586,1,1;0.352941185235977,1,1;0.294117659330368,1,1;0.235294118523598,1,1;0.176470592617989,1,1;0.117647059261799,1,1;0.0588235296308994,1,1;0,1,1;0,0.923076927661896,0.923076927661896;0,0.846153855323792,0.846153855323792;0,0.769230782985687,0.769230782985687;0,0.692307710647583,0.692307710647583;0,0.615384638309479,0.615384638309479;0,0.538461565971375,0.538461565971375;0,0.461538463830948,0.461538463830948;0,0.384615391492844,0.384615391492844;0,0.307692319154739,0.307692319154739;0,0.230769231915474,0.230769231915474;0,0.153846159577370,0.153846159577370;0,0.0769230797886848,0.0769230797886848;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0.100000001490116,0,0;0.200000002980232,0,0;0.300000011920929,0,0;0.400000005960465,0,0;0.500000000000000,0,0;0.600000023841858,0,0;0.699999988079071,0,0;0.800000011920929,0,0;0.899999976158142,0,0;1,0,0;1,0.0421052649617195,0.0421052649617195;1,0.0842105299234390,0.0842105299234390;1,0.126315787434578,0.126315787434578;1,0.168421059846878,0.168421059846878;1,0.210526317358017,0.210526317358017;1,0.252631574869156,0.252631574869156;1,0.294736832380295,0.294736832380295;1,0.336842119693756,0.336842119693756;1,0.378947377204895,0.378947377204895;1,0.421052634716034,0.421052634716034;1,0.463157892227173,0.463157892227173;1,0.505263149738312,0.505263149738312;1,0.547368407249451,0.547368407249451;1,0.589473664760590,0.589473664760590;1,0.631578981876373,0.631578981876373;1,0.673684239387512,0.673684239387512;1,0.715789496898651,0.715789496898651;1,0.757894754409790,0.757894754409790;1,0.800000011920929,0.800000011920929;];

%% Set colorbar
if isempty(DRdata.h.CBSubP2) || ~ishandle(DRdata.h.CBSubP2)
    DRdata.h.CBSubP2 = setUniqAxesMap(DRdata.subplot.h(4), colorMap,1);
    set(DRdata.subplot.h(4),'FontSize',DRdata.fontsize.axis);
    set(DRdata.h.CBSubP2,'units','normalized');
else
    setUniqAxesMap(DRdata.subplot.h(4), colorMap)
end

if ~isempty(DRdata.selsamples)
    nSelSmpls = length(DRdata.selsamples);
    line([ xlims(1) xlims(2)], [nSelSmpls+1  nSelSmpls+1],...
            'LineStyle','--','LineWidth',DRdata.SPplot.linewidth+1,...
            'Color',[1 1 1]);
end
        
if strcmp(ids,'Show Sample Profiles')
    set(get(DRdata.h.CBSubP2,'ylabel'),'String',...
        sprintf('Changes between sample profiles and \n reconstructed sample profiles'),'FontSize',DRdata.fontsize.axislabel);
else
    set(get(DRdata.h.CBSubP2,'ylabel'),'String', ...
        sprintf('Log fold changes relative to the median \n profile across all samples'),'FontSize',DRdata.fontsize.axislabel);
end
adjustPlotPtns(DRdata.subplot.h(2),DRdata.subplot.h(4));
return;