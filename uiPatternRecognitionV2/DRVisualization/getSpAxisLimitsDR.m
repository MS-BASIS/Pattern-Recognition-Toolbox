function [xlims,ylims] = getSpAxisLimitsDR(DRdata,xlims,ylims)
%% calculates axis limits for dimensionality reduction toolbox

nVrbls   = length(DRdata.ppm);
if nargin<2 || isempty(xlims)
    xlims(1) = 1;
    xlims(2) = nVrbls;
else
    if xlims(1)<1
        xlims(1) = 1;
    end
    if xlims(2)>nVrbls
        xlims(2) = nVrbls;
    end
end
xlims    = floor(xlims);
if nargin <3 || isempty(ylims)
    if nargout==2
        maxSp = max(max(DRdata.Sp(:,xlims(1):DRdata.redRatio:xlims(2))));
        minSp = min(min(DRdata.Sp(:,xlims(1):DRdata.redRatio:xlims(2))));
        range = maxSp - minSp;
        ylims = [minSp-0.1*range maxSp+0.1*range];
    end
end
return;