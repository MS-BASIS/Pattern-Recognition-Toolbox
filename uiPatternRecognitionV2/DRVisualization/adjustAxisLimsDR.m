function axislims = adjustAxisLimsDR(DRdata,driveHanle,supportHandles,XorYLims)

if strcmp(XorYLims,'XLim')
    axislims = get(driveHanle,'XLim');
    axislims = floor(sort(axislims));
    if axislims(1) < 1
        axislims(1) = 1;
    end
    if axislims(2) > DRdata.nVrbls
        axislims(2) = DRdata.nVrbls;
    end
elseif strcmp(XorYLims,'YLim')
    axislims = get(driveHanle,'YLim');
    axislims = floor(sort(axislims));
    if axislims(1) < 1
        axislims(1) = 1;
    end
    if axislims(2) > DRdata.nSmpls
        axislims(2) = DRdata.nSmpls;
    end
end
set(supportHandles,XorYLims,axislims);
return;