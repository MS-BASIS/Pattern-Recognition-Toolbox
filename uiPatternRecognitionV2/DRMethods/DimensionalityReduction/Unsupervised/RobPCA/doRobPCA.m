function DRdata = doRobPCA(DRdata,options)
%% doRobPCA sets parameters for performing robust principal component analysis of data matrix X
%       Input: DRdata     - various parameters of DR toolbox objects
%              options - default parameters for robust PCA (number of PCs and
%              method for computing PCs)
%% Author: Kirill A. Veselkov, Imperial College London 2011.

if nargin<2
    options = [];
end
if DRdata.options.setparam==1
    DRdata.options = getVarArgin(options);
end
nPCs      = DRdata.options.values{1};
alpha     = DRdata.options.values{2};
PCmax     = DRdata.options.values{3};
nRandDir  = DRdata.options.values{4};

resRobPCA = RPCA(DRdata.X,'nPCs',nPCs,'mcdPCs',PCmax,...
    'nRandDir',nRandDir,'alpha',alpha);

DRdata.PCvar    = resRobPCA.PCvar*100;
DRdata.loadings = resRobPCA.loadings;
DRdata.scores   = resRobPCA.scores;
DRdata.meanX    = resRobPCA.meanX;
DRdata.outliers = resRobPCA.outliers;
return;

function options = getVarArgin(options)
%% get default input arguments 
if isempty(options)
    options.names{1}  = 'The number of PCs';
    options.values{1} = '3';
    options.names{2}  = 'The fraction of outliers';
    options.values{2} = '0.25';
    options.names{3}  = 'The number of PCs used in the MCD estimator';
    options.values{3} = '10';
    options.names{4}   = 'The number of random directions for computing outlyingness';
    options.values{4}  = '250';    
else
    options.values{1} = num2str(options.values{1});
    options.values{2} = num2str(options.values{2});
    options.values{3} = num2str(options.values{3});
    options.values{4} = num2str(options.values{4});
end
answer           = inputdlg(options.names,'Robust PCA: parameters'' setup',1,options.values);
options.values{1} = str2double(answer{1});
options.values{2} = str2double(answer{2});   
options.values{3} = str2double(answer{3});   
options.values{4} = str2double(answer{4});   