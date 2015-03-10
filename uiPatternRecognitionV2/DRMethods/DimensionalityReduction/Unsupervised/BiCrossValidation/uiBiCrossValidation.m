function DRdata = uiBiCrossValidation(DRdata)
%% bicrossvalidation performs rxs cross validation be leaving ...
%% r (rows) and s (columnts) simultaneously

%% Author: Kirill A. Veselkov, Imperial College London, 2011

%% Cross Validation Initiation
[maxPCs,rxsholdouts] = getVarArgin();
X                    = DRdata.X - DRdata.meanX(ones(1,DRdata.nSmpls),:);
DRdata.cv.Type       = {'K-fold',rxsholdouts(1)};
CVSmplPartIndcs      = cvDataSetPartition(DRdata);
DRdata.cv.Type       = {'K-fold',rxsholdouts(2)};
nSmpls               = DRdata.nSmpls;
DRdata.nSmpls        = DRdata.nVrbls;
CVVrblPartIndcs      = cvDataSetPartition(DRdata);
Rcv                  = zeros(1,maxPCs);
DRdata.nSmpls        = nSmpls;

%% PCA on full dataset
[P,T,varX]  = pcanipals(X,maxPCs);
P           = [zeros(DRdata.nVrbls,1),P];
T           = [zeros(DRdata.nSmpls,1),T];
wb    = waitbar(0,'Starting Bi-cross validation...','Name','Processing now...');
cvindex = 0;
nCVrounds = rxsholdouts(1)*rxsholdouts(2);
for r = 1:rxsholdouts(1)
    rindcs = CVSmplPartIndcs==r;
    for s = 1:rxsholdouts(2)
        sindcs = CVVrblPartIndcs==s;
        [Pcv,Tcv] = pcanipals(X(~rindcs,~sindcs),maxPCs);
        for iPC = 1:maxPCs
            Xres     = X(rindcs,sindcs) - ...
                T(rindcs,1:iPC)*P(sindcs,1:iPC)' - ...
                X(rindcs==1,~sindcs)*pinv(Tcv(:,iPC)*Pcv(:,iPC)')*X(~rindcs,sindcs);
            Rcv(iPC) = Rcv(iPC) + sum(sum(Xres.*Xres));
        end
        cvindex = cvindex + 1;
        frac = cvindex./(nCVrounds);
        
        waitbar(frac, wb, ...
            ['Bi-cross validation round' char(10) int2str(cvindex) ' out of ' int2str(nCVrounds)]);
    end
end
delete(wb);
DRdata.Rcv.values                         = (1-Rcv./sum(sum(X.*X)))*100;
DRdata.Rcv.values(2:end)                  = DRdata.Rcv.values(2:end)-cumsum(varX(1:end-1));
DRdata.Rcv.values(DRdata.Rcv.values>varX) = varX(DRdata.Rcv.values>varX);
DRdata.Rcv.method                         = [num2str(rxsholdouts(1)),'x' num2str(rxsholdouts(2))];

h = figure('menu','none','Color',[1 1 1]);
updateFigTitleAndIconMS(h,'Bi-cross validation','MSINavigatorLogo.png')
bar([varX',DRdata.Rcv.values']);
legend('R^2','R_c_v^2','FontSize',DRdata.fontsize.axislabel)
set(gca,'FontSize',DRdata.fontsize.axis)
ylabel({'variance (%)'},'FontSize',DRdata.fontsize.axislabel);
xlabel({'Principal Component'},'FontSize',DRdata.fontsize.axislabel);
title([DRdata.Rcv.method,' Fold Bi-Cross-Validation'],'FontSize',DRdata.fontsize.title);
return;

function [maxPCs,rxsholdouts] = getVarArgin()
%% get default input arguments
bicrossvalparam.names{1}  = 'Maximal number of computed principal componentsn';
bicrossvalparam.values{1} = '5';
bicrossvalparam.names{2}  = 'r (rows) x s (columns) holdouts';
bicrossvalparam.values{2} = '3x3';

answer = inputdlg(bicrossvalparam.names,'Bi-cross validation parameters',...
    1,bicrossvalparam.values);
ind            = findstr(answer{2},'x');
answer{2}(ind) = ' ';
maxPCs         = str2double(answer{1});
rxsholdouts    = [str2double(answer{2}(1:ind-1)) str2double(answer{2}(ind+1:end))];
return