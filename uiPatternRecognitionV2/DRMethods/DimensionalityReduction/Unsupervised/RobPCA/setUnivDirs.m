function univDirs = setUnivDirs(X,nRandDirect)
%% setRandDir sets n univariate directions at Random
    % Input: X           - dataset
    %        nRandDirect - n random univariate directions
%% Author: Kirill A. Veselkov, Imperial College London, 2011. 

%nTotDirect = nSmpls*(nSmpls-1)/2; % an overall number of directins

%if nRandDirect>=nTotDirect
%    sampleSets = ones(nTotDirect,2);
%    index = 0;
%    for iSmpl = 1:nSmpls-1
%        sampleSets(index+1:index+nSmpls-iSmpl,1) = iSmpl;
%        sampleSets(index+1:index+nSmpls-iSmpl,2) = iSmpl+1:nSmpls;
%        index = index+nSmpls-iSmpl;
%    end
%else
%    sampleSets = randomset(nSmpls,nRandDirect);
%end
%univDirs = X(sampleSets(:,1),:) - X(sampleSets(:,2),:);

univDirs = twopoints(X,nRandDirect,0);
normDirs = sqrt(sum(univDirs.^2,2));
univDirs = univDirs(normDirs > 1.e-12,:);  
normDirs = normDirs(normDirs > 1.e-12); 
univDirs = diag(1./normDirs)*univDirs;  
return;

function sampleSets = randomset(nSmpls,k)
%% RANDOMSET draws randomly k-cases of paired samples from the overall number of
%% samples 
%    Input: nSmpls - the number of samples
%           k      - the number of random subsamples
%% Author: Kirill A. Veselkov, Imperial College London.

sampleSets = randi([1 nSmpls],k,2);
repIndcs   = (sampleSets(:,1) == sampleSets(:,2));
nRepetions = sum(repIndcs);
while nRepetions ~= 0
    sampleSets(repIndcs,:) = randi([1 nSmpls],nRepetions,2);
    repIndcs   = (sampleSets(:,1) == sampleSets(:,2));
    nRepetions = sum(repIndcs);
end
return;