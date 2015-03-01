function uidoSpOrderDR(hMainFigDR,eventdata)
%% spOrderDR: Given n objects in PC scores and the similarities between them the objective 
%% of ordering is to insure that (i) adjacent objects are similar (ii) the larger the 
%% distance between the objects, the less similar the two objects are.
%      Input: hMainFigDR - a handle to the main figure of DR toolbox
%% Author: Kirill Velselkov, Imperial College 2011. 

DRdata = guidata(hMainFigDR);
% Calculate the affinity\similarity matrix between sample scores (W)
X      = DRdata.scores(:,DRdata.PCplot.selPCs(DRdata.PCplot.selPCsForRecs==1)); % samples by dimensions
nSmpls = size(X,1);
XX     = sum(X.*X,2);
dist   = sqrt(XX(:,ones(1,nSmpls)) + XX(:,ones(1,nSmpls))' - 2.*(X*X')); %% euclidean distance
S      = exp(-dist./10);
%S      = - dist;
%S      = S - min(S(:));
S(1:nSmpls+1:end) = 0;

%% Find fiedler vector
if ~isempty(DRdata.spsortindcs) || ~isempty(DRdata.selsamples)
    DRdata.spsortindcs    = [];
    if ~isempty(DRdata.sortSelIndcs)
        DRdata.X              = DRdata.X(DRdata.sortSelIndcs,:);
        DRdata.groupdata      = DRdata.groupdata(DRdata.sortSelIndcs);
        DRdata.sampleIDs      = DRdata.sampleIDs(DRdata.sortSelIndcs);
        DRdata.sortSelIndcs   = [];
    end
end
%% Calculate unnormalized Laplacian (L = D - W) 
D = sum(S,1);  L = diag(D) - S;  
% Normalized Laplacian (symmetric normalization D-1/2*L*D-1/2)
Dnorm             = diag(1./(sqrt(D)+eps));
Ln                = Dnorm*L*Dnorm; % round off errors
Ln                = 0.5*(Ln+Ln');
[fiedler,eigVal]  = eigs(Ln,2,'SA'); 
[I,DRdata.spsortindcs] = sort(fiedler(:,2));
%% Visualize results
%figure; subplot(2,2,1); imagesc(S); subplot(2,2,2); imagesc(S(DRdata.spsortindcs,DRdata.spsortindcs));
%subplot(2,2,3:4); plot(1:nSmpls,fiedler(:,2),'o','MarkerSize',6);


DRdata                  = updatePlotsDR(DRdata,1);
DRdata.X                = DRdata.X(DRdata.spsortindcs,:);
DRdata.groupdata        = DRdata.groupdata(DRdata.spsortindcs);
DRdata.sampleIDs        = DRdata.sampleIDs(DRdata.spsortindcs);
xlims                   = get(DRdata.subplot.h(2),'xlim');
DRdata                  = updateImagePlotsDR(DRdata,xlims);
[I,DRdata.sortSelIndcs] = sort(DRdata.spsortindcs);
imageSampleIdsDR(DRdata);

guidata(hMainFigDR,DRdata);