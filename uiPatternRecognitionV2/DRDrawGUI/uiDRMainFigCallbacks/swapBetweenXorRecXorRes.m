function swapBetweenXorRecXorRes(hMainFigDR,eventdata)
%% swapSpOrRecSpDR swaps between spectra of biological samples,
%%                 reconstucted spectra of biological samples 
%%                 and residuals between them
%   hMainFigDR     - a handle of the main figure    
%% Author: Kirill A. Veselkov, Imperial College 2011

DRdata               = guidata(hMainFigDR);
%% Install two toggle buttons for PC selection
DRdata               = updateImagePlotsDR(DRdata);
ids = get(DRdata.h.swapBetweenXorRecXorRes,'TooltipString');
if strcmp(ids,'Show Sample Profiles');
 set(DRdata.h.swapBetweenXorRecXorRes,'TooltipString','Show Reconstructed Sample Profiles');
elseif strcmp(ids,'Show Reconstructed Sample Profiles');
    set(DRdata.h.swapBetweenXorRecXorRes,'TooltipString','Show Residuals');
elseif strcmp(ids,'Show Residuals');
    set(DRdata.h.swapBetweenXorRecXorRes,'TooltipString','Show Sample Profiles');
end
DRdata   = updateImagePlotsDR(DRdata);
guidata(hMainFigDR,DRdata)