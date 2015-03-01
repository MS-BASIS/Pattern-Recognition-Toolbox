function [tp, fp, AUC] = roc(ytest_true, ytest_pred, display)
% ROC - generate a receiver operating characteristic curve
%    [TP,FP] = ROC(ytest_true,ytest_pred,1) gives the true-positive rate (TP) and false positive
%    rate (FP), where ytest_pred is a column vector giving the score assigned to each
%    pattern and ytest_true indicates the true class (a value above zero represents
%    the positive class and anything else represents the negative class).  
%     display == 1 (show results)
%   The details of the algorithm are provided in [1]
%    [1] Fawcett, T., "ROC graphs : Notes and practical
%        considerations for researchers", Technical report, HP
%        Laboratories, MS 1143, 1501 Page Mill Road, Palo Alto
%        CA 94304, USA, April 2004.
% Author: Kirill Veselkov, Imperial College London 2012. 

if nargin<3
    display=1;
end

ntp = length(ytest_pred);

CC = corrcoef(ytest_true,ytest_pred);
if CC(1,2)<0
    ytest_pred = - ytest_pred;
end

% sort by classeifier output
[ytest_pred,sortindcs] = sort(ytest_pred, 'descend');
ytest_true             = ytest_true(sortindcs) > 1;


if nargin<3
    display = 0;
end

% generate ROC
P     = sum(ytest_true);
N     = ntp - P;
fp    = zeros(ntp+2,1);
tp    = zeros(ntp+2,1);
FP    = 0;
TP    = 0;
n     = 1;
yprev = -realmax;

for i=1:ntp
   if ytest_pred(i) ~= yprev
      tp(n) = TP/P;
      fp(n) = FP/N; 
      yprev = ytest_pred(i);
      n     = n + 1;
   end
   if ytest_true(i) == 1
      TP = TP + 1;
   else
      FP = FP + 1;
   end
end

tp(n) = 1;
fp(n) = 1;
fp    = fp(1:n);
tp    = tp(1:n);

AUC = sum((fp(2:n) - fp(1:n-1)).*(tp(2:n)+tp(1:n-1)))/2;

if display==1
    figure(1);
    clf;
    h = plot(fp,tp,'-.');
    set(h,'LineWidth',3);
    xlabel('false positive rate','FontSize',14);
    ylabel('true positive rate','FontSize',14);
    AUC = sum((fp(2:n) - fp(1:n-1)).*(tp(2:n)+tp(1:n-1)))/2;
    title(['ROC curve, AUC = ',num2str(AUC)],'FontSize',18);
    xlim([-0.05,1]);
    ylim([-0,1.05]);
end

return;