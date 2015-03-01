function DRdata = doDR(DRdata)
%   Input: DRdata     - properties and parameter values
%                       of dimension reduction toolbox objects
%% Author: Kirill A. Veselkov, Imperial College 2011.

switch DRdata.method
    case 'PCA'
        DRdata = PCA(DRdata,[]);
        DRdata.PCScoreGraphics = 1;
        DRdata.outliers        = [];
        DRdata.object          = 'Unsupervised';
    case 'RobPCA'
        DRdata = doRobPCA(DRdata,[]);
        DRdata.PCScoreGraphics = 1;
        DRdata.object          = 'Unsupervised';
    case 'LDAMMC'
        DRdata.object          = 'Supervised';
        DRdata = doMMCLDA(DRdata,[]);
        DRdata.outliers        = [];
        DRdata.PCScoreGraphics = 1;
    case 'PCALDA'
        DRdata.object          = 'Supervised';
        DRdata = doPCALDA(DRdata,[]);
        DRdata.outliers        = [];
        DRdata.PCScoreGraphics = 1;
    case 'PLS'
        DRdata.object          = 'Supervised';
        DRdata = doPLS(DRdata,[]);
        DRdata.outliers        = [];
        DRdata.PCScoreGraphics = 1;
    case 'SVM'
        DRdata.object          = 'Supervised';
        DRdata = doSVM(DRdata,[]);
        DRdata.outliers        = [];
        DRdata.PCScoreGraphics = 1;
    case 'LDA'
        DRdata.object          = 'Supervised';
        DRdata = doLDA(DRdata,[]);
        DRdata.outliers        = [];
        DRdata.PCScoreGraphics = 1;
end
return;