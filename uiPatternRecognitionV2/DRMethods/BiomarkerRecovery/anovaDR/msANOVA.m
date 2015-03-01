function [ANOVAindcs] = msANOVA(pValThresh,X,classIDs,sampleIDs)
%% ANOVA for mass spectral data with sample and patient IDs
% input arg:    X:          Intensity matrix
%               sampleIDs:  Cell array or numerical vector of sample IDs
%               classIDs:   Cell array or numerical vector of row IDs
%
% Ottmar Golf, 2014

if nargin < 4
    sampleIDs = ones(length(classIDs),1);
end

[XAnova,histIDAnova]         = averageSmplClass(X,sampleIDs,classIDs);
pValues                      = onewayanovaBR(XAnova,grp2idx(histIDAnova),'ANOVA');
if pValThresh>=1; pValues(1) = 1; end
ANOVAindcs                   = pValues<=pValThresh;

end