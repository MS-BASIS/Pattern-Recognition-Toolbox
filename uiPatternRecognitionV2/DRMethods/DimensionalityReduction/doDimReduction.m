function DRdata = doDimReduction(DRdata,DRparam,method)
%   Input: DRdata     - properties and parameter values
%                       of dimension reduction toolbox objects
%% Author: Kirill A. Veselkov, Imperial College 2011.

switch method
    case 'PCA'
        DRdata = PCA(DRdata,DRparam);
        DRdata.PCScoreGraphics = 1;
        DRdata.outliers        = [];
        DRdata.object          = 'Unsupervised';
    case 'RobPCA'
        DRdata = doRobPCA(DRdata,DRparam);
        DRdata.PCScoreGraphics = 1;
        DRdata.object          = 'Unsupervised';
    case 'LDAMMC'
        DRdata = doMMCLDA(DRdata,DRparam);
        DRdata.PCScoreGraphics = 1;
        DRdata.object          = 'Supervised';
    case 'PCALDA'
        DRdata = doPCALDA(DRdata,DRparam);
        DRdata.PCScoreGraphics = 1;
        DRdata.object          = 'Supervised';   
    case 'PLS'
        DRdata = doPLS(DRdata,DRparam);
        DRdata.PCScoreGraphics = 1;
        DRdata.object          = 'Supervised';
end
return;