function uidoANOVA(hMainFig,eventdata)
%% uidoANOVA sets parameters for ANOVA-type feature selection
%    Input: hMainFig - handle of the main figure of DR toolbox
%% Author: Kirill A. Veselkov, Imperial College London, 2012.

DRdata = guidata(hMainFig);
nGrps  = length(unique(DRdata.groupdata));
set(DRdata.h.ANOVA,'State','Off');
set(DRdata.h.BayesANOVA,'State','Off');
if nGrps < 2
    display('Biomarker Recovery: The number of groups for biomarker recovery must be more than one')
    return;
else
    set(hMainFig,'State','On');
end
if DRdata.pos.showBR == 0
    DRdata            = deleteDRObjects(DRdata);
    DRdata.pos.showDR = 0; 
    DRdata.pos.showBR = 1;
end
DRdata.methodBR = get(hMainFig,'TooltipString');
switch DRdata.methodBR
    case 'Conventional ANOVA test'
    DRdata          = doanovaBR(DRdata);
    case 'Emprical bayes ANOVA-test'
    DRdata          = doEbayesAnovaBR(DRdata);
end
    %if strcmp(get(DRdata.h.PeakPickedData,'State'),'off');
    %end
if ~isnan(DRdata.BR.alpha)
    [pThr1,pThr2]    = BHYFDR(DRdata.BR.pvalues,DRdata.BR.alpha);
    [qVls1,qVls2]    = getBHYqVls(DRdata.BR.pvalues,DRdata.BR.alpha);
    if strcmp(DRdata.BR.corrstr,'pos')
        DRdata.BR.pFDRThr = pThr1;
        DRdata.BR.qvals   = qVls1;
    elseif strcmp(DRdata.BR.corrstr,'any')
        DRdata.BR.pFDRThr = pThr2;
        DRdata.BR.qvals   = qVls2;
    end
else
    DRdata.BR.pFDRThr = [];
    DRdata.BR.qvals   = [];
end  
set(DRdata.h.pvalues,'State','On');
set(DRdata.h.qvalues,'State','Off');
set(DRdata.h.rvalues,'State','Off');
DRdata.BR.CovXy = DRdata.Sp'*getDummyY(DRdata.groupdata,'yes');
if nGrps>2
    DRdata.BR.CovXy = mean(abs(DRdata.BR.CovXy),2);
else
    DRdata.BR.CovXy =  DRdata.BR.CovXy(:,1);
end
xlims    = get(DRdata.subplot.h(4),'XLim');  
xlims    = [ceil(xlims(1)),floor(xlims(2))];
DRdata   = plotpvaluesBR(DRdata,xlims);

guidata(hMainFig,DRdata);