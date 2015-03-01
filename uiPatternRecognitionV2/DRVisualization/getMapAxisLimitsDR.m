function [xlims,ylims] = getMapAxisLimitsDR(DRdata,xlims,ylims)
%% calculates axis limits for dimensionality reduction toolbox

%% Adjust axis limits
nVrbls   = length(DRdata.ppm);
if nargin<2 || isempty(xlims)
    xlims = [1 nVrbls];
else
    if xlims(1)<1
        xlims(1) = 1;
    end
    if xlims(2)>nVrbls
        xlims(2) = nVrbls;
    end
end
nSmpls = size(DRdata.X,1);
if nargin<3 || isempty(ylims)
    ylims = ([1,nSmpls]);
else
    if ylims(1)<1
        ylims(1) = 1;
    end
    if ylims(2)>nSmpls
        ylims(2) = nSmpls;
    end
end
xlims = floor(xlims);
ylims = floor(ylims);
return;