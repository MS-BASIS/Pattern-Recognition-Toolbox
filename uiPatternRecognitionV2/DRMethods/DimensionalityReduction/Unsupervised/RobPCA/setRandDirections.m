function randDirMatrix = setRandDirections(X,nRandDirect)
%% setRandDir sets n random directions by n-time selecting two random
%% data points out of a sampleset
    % Input: X           - dataset
    %        nRandDirect - n random directions
%% Author: Kirill A. Veselkov, Imperial College London, 2011. 

nSmpls     = size(X,1);
nTotDirect = nSmpls*(nSmpls-1)/2; % an overall number of directins

if nRandDirect>=nTotDirect
    sampleSets = ones(nTotDirect,2);
    index = 0;
    for iSmpl = 1:nSmpls-1
        sampleSets(index+1:index+nSmpls-iSmpl,1) = iSmpl;
        sampleSets(index+1:index+nSmpls-iSmpl,2) = iSmpl+1:nSmpls;
        index = index+nSmpls-iSmpl;
    end
else
    sampleSets = randomset(nSmpls,nRandDirect);
end
randDirMatrix = X(sampleSets(:,1),:) - X(sampleSets(:,2),:);
return;

function sampleSets = randomset(nSmpls,nRandDirect)
sampleSets = ceil(nSmpls*rand(nRandDirect,2));
repIndcs   = (sampleSets(:,1) == sampleSets(:,2));
nRepetions = sum(repIndcs);
while nRepetions ~= 0
    sampleSets(repIndcs,:) = ceil(nSmpls*rand(nRepetions,2));
    repIndcs   = (sampleSets(:,1) == sampleSets(:,2));
    nRepetions = sum(repIndcs);
end
return;