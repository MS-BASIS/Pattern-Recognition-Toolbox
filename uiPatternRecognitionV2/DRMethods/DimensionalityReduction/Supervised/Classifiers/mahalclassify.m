function [outClass,traincovstr] = mahalclassify(test, train, group, cutoff)
%% mahalclassify classifies each row of the data in SAMPLE into one...
%% of the groups in trainING using mahalabis distance classifier

if nargin <4
    cutoff = 0.975;
end

[gindex,groups] = grp2idx(group);
nans            = find(isnan(gindex));
if ~isempty(nans)
    train(nans,:) = [];
    gindex(nans)  = [];
    groups        = unique(gindex);
end
ngroups = length(groups);

[nObs,nVrbls] = size(train);
if size(gindex,1) ~= nObs
    error('mahalclassify:BadGroupLength',...
        'The length of GROUP must equal the number of samples in training set');
elseif size(test,2) ~= nVrbls
    error('mahalclassify:SampletrainingSizeMismatch',...
        'test and train sets must have the same number of variables');
end

nObsTest = size(test,1);
iClass   = zeros(nObsTest,ngroups);
traincovstr = cell(1,ngroups); 
for iGrp = 1:ngroups
    iGrpTrain  = train(gindex==iGrp,:); % exctract specimens belonging to a given group
    %% calculate the distribution parameters for a given class
    traincovstr{iGrp} = mcdcov(iGrpTrain,'alpha',0.8);
    %traincovstr{i}.center = mean(iGrpTrain); traincovstr{i}.cov = cov(iGrpTrain);
    %% calculate mahalanobis distances for each class
    %trainsd  = sqrt(mahalanobis(iGrpTrain,traincovstr.center,'cov',traincovstr.cov))';
    sdcutoff = sqrt(chi2inv(cutoff,nVrbls));
    testsd   = sqrt(mahalanobis(test,traincovstr{iGrp}.center,'cov',traincovstr{iGrp}.cov)');
    testsd   = testsd<=sdcutoff;
    iClass(testsd,iGrp) = iGrp;
end
outClass = zeros(1,nObsTest);
for j = 1:nObsTest
    indcs = iClass(j,:)>0; 
    if sum(indcs)~=1
        outClass(j) = 0;
    else
        outClass(j) = iClass(j,indcs);        
    end
end
outClass(outClass==0) = ngroups+1;
return;    