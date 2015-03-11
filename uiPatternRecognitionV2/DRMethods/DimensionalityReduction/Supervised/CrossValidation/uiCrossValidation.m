 function DRdata = uiCrossValidation(DRdata)
%% uiCrossValidation performs cross validation for supervised learning
%   Input: DRdata     - properties and parameter values
%                       of dimension reduction toolbox objects
%% Author: Kirill A. Veselkov, Imperial College 2011.

if DRdata.nVrbls > (DRdata.nSmpls - 1) && ~strcmp(DRdata.cv.anovaFeatSel.do,'Yes')
    X = DRdata.pca.T;
    P = DRdata.pca.P;
else
    X = DRdata.X;
    P = 1;
end
DRdata = resetparamDR(DRdata);

%% Partition a data set for cross validation
cvpartindcs                     = cvDataSetPartition(DRdata); % CV partition of the dataset
%save cvindcs cvpartindcs 
%load cvindcs
nCVrounds                       = length(unique(cvpartindcs));
cvtrain.method                  = DRdata.method;
cvtrain.options                 = DRdata.options;
cvtrain.options.setparam        = 0;
cvtrain.options.values{1}       = DRdata.cv.nComps;
DRdata.cv.predclass             = zeros(DRdata.nSmpls,DRdata.cv.nComps);
cvtest.T                        = zeros(DRdata.nSmpls,DRdata.cv.nComps);
Rsqcum                          = zeros(1,DRdata.cv.nComps);
cvtrain.X                       = X;
cvtrain.groupdata               = DRdata.groupdata;
trainX                          = doDR(cvtrain);
ssqTest                         = 0;
cvtest.X                        = NaN(size(X));
DRdata.cv.weights               = zeros(size(X,2),DRdata.cv.nComps);
%DRdata.cv.meanX                 = zeros(1,size(X,2));
DRdata.cv.weights               = zeros(size(X,2),DRdata.cv.nComps);
nVar                            = size(cvtrain.X,2);
DRdata.cv.anovaFeatSel.pVals    = zeros(nCVrounds,nVar);
DRdata.cv.anovaFeatSel.features = ones(nCVrounds,nVar);
cvpartindcs                     = grp2idx(cvpartindcs);
wb = waitbar(0,'Starting cross validation rounds...','Name','Processing now...');
for jRound = 1:nCVrounds
    %% Perform dimension reduction on trained data
    test              = (cvpartindcs == jRound); train = ~test;
    cvtrain.X         = X(train,:);
    cvtrain.groupdata = DRdata.groupdata(train);
    if strcmp(DRdata.cv.anovaFeatSel.do,'Yes')
        DRdata.cv.anovaFeatSel.pVals(jRound,:)    = onewayanovaBR(cvtrain.X,cvtrain.groupdata,'ANOVA');
        DRdata.cv.anovaFeatSel.features(jRound,:) = DRdata.cv.anovaFeatSel.pVals(jRound,:)<=DRdata.cv.anovaFeatSel.pValThresh;
        AnovaIndcs                                = logical(DRdata.cv.anovaFeatSel.features(jRound,:));
    else
        AnovaIndcs = logical(ones(nVar,1)); %#ok<LOGL>
    end
    cvtrain.X = X(train,AnovaIndcs);
    cvtrain   = doDR(cvtrain);
    weights   = zeros(nVar,DRdata.cv.nComps); 
    loadings  = zeros(nVar,DRdata.cv.nComps); 
    loadings(AnovaIndcs,:) = cvtrain.loadings; 
    cvtrain.loadings       = loadings; 
    weights(AnovaIndcs,:)  = cvtrain.weights; 
    cvtrain.weights        = weights; 
    %% Make sure weights are compatible between CV models
    if jRound > 0
        [dirIndcs,dirSigns] = alignCVdirsDR(cvtrain.weights,trainX.weights);
        cvtrain.weights     = cvtrain.weights(:,dirIndcs);
        cvtrain.scores      = cvtrain.scores(:,dirIndcs);
        cvtrain.loadings    = cvtrain.loadings(:,dirIndcs);
        for i=1:DRdata.cv.nComps
            cvtrain.weights(:,i)  = cvtrain.weights(:,i)*dirSigns(i);
            cvtrain.scores(:,i)   = cvtrain.scores(:,i)*dirSigns(i);
            cvtrain.loadings(:,i) = cvtrain.loadings(:,i)*dirSigns(i);
        end
        DRdata.cv.weights  = DRdata.cv.weights+cvtrain.loadings;
    end
    %% Mapping test data into a lower dimension space
    cvtest.X(test,AnovaIndcs) = bsxfun(@minus, X(test,AnovaIndcs), cvtrain.meanX);
 %   DRdata.cv.meanX  = DRdata.cv.meanX+cvtrain.meanX;
    cvtest.T(test,:)          = cvtest.X(test,AnovaIndcs)*cvtrain.weights(AnovaIndcs,:);
    for iComp = 1:DRdata.cv.nComps
        %% Classifying test samples
        switch DRdata.cv.classifierType{1}
            case 'mahalanobis' 
                testclass = classify(cvtest.T(test,1:iComp) , cvtrain.scores(:,1:iComp), DRdata.groupdata(train),'mahalanobis');
            case 'quadratic'
                testclass = classify(cvtest.T(test,1:iComp) , cvtrain.scores(:,1:iComp), DRdata.groupdata(train),'quadratic');
            case 'knn'
                testclass = knnclassify(cvtest.T(test,1:iComp) , cvtrain.scores(:,1:iComp), DRdata.groupdata(train),DRdata.cv.classifierType{2});
        end
        DRdata.cv.predclass(test,iComp)  = testclass;
        Rsqcum(iComp)                    = Rsqcum(iComp)+ssq(cvtest.X(test,AnovaIndcs)-cvtest.T(test,1:iComp)*cvtrain.loadings(AnovaIndcs,1:iComp)');
    end
    frac = jRound/(nCVrounds);
    waitbar(frac, wb, ...
        ['Cross validation round' char(10) int2str(jRound) ' out of ' int2str(nCVrounds)]);
    ssqTest                   = ssqTest+ssq(cvtest.X(test,AnovaIndcs));
end
delete(wb);

% Explore and/or export anova feature selection data
if strcmp(DRdata.cv.anovaFeatSel.do,'Yes')
    if DRdata.cv.anovaFeatSel.diagnostics==1
        uidoplotAnovaFeatSelecDiagnostics(DRdata);
    end
    if DRdata.cv.anovaFeatSel.exportData==1
        exportAnovaData(DRdata);
    end
end
for iComp = 1:DRdata.cv.nComps
    DRdata.cv.accuracy(iComp) = 100*sum(DRdata.cv.predclass(:,iComp)==DRdata.groupdata')./DRdata.nSmpls;
    DRdata.cv.cumRsq(iComp)   = 100*(1- Rsqcum(iComp)/ssqTest);
end
DRdata.cv.cumRsq(DRdata.cv.cumRsq<-50) = -10;
DRdata.cv.misclassified                = DRdata.cv.predclass==repmat(DRdata.groupdata,DRdata.cv.nComps ,1)';
DRdata.PCplot.CVScores                 = 1;
DRdata.cv.T                            = cvtest.T;
%DRdata.scores                          = cvtest.T; 
%Xmc           = bsxfun(@minus, X, DRdata.cv.meanX./nCVrounds);
%DRdata.scores = Xmc*(DRdata.cv.weights)./nCVrounds;
%DRdata.cv.T   = DRdata.scores;
for iComp = 1:DRdata.cv.nComps
    DRdata.loadings(:,iComp) = P*(cvtest.X'*cvtest.T(:,iComp)./(cvtest.T(:,iComp)'*cvtest.T(:,iComp)));
end
DRdata.loadings(isnan(DRdata.loadings)) = 0;
DRdata = plotClassifierPerfomanceDR(DRdata);
DRdata = updateAllSubPlots(DRdata);

if length(unique(DRdata.groupdata))==2;
    roc(DRdata.groupdata,DRdata.cv.T(:,1),1);
end

%% insert label rotation button
Pos1   = get(DRdata.h.legendbutton,'Position');
Pos1(2) = Pos1(2) - Pos1(4);
DRdata.cv.h.rotatecvlabels = uicontrol('style', 'pushbutton','CData',...             % sample selection
    DRdata.icons.rotateclockwise,'units','normalized','Position',Pos1,...
    'Callback', @changeCVScoreLablesDR, 'TooltipString','Show missclassified samples');
if ismac
    set(DRdata.cv.h.rotatecvlabels,'Visible','off');
    drawnow; pause(0.05);
    set(DRdata.cv.h.rotatecvlabels,'Visible','on');
end


%jButton = java(findjobj(DRdata.cv.h.rotatecvlabels));
%set(jButton,'Border',[]);
DRdata.cv.case = 1;
guidata(DRdata.h.figure,DRdata);
return;

function exportAnovaData(DRdata)
%% Write anova data to excel spreadsheet
[fn,fp] = uiputfile('anovaData.xlsx','Save As');
path    = deSlash([fp fn]);
sheet1  = [DRdata.ppm;DRdata.cv.anovaFeatSel.pVals];
sheet2  = [DRdata.ppm;DRdata.cv.anovaFeatSel.features];
xlswrite(path,sheet1,'p-Values');
xlswrite(path,sheet2,'selected features');
return;
