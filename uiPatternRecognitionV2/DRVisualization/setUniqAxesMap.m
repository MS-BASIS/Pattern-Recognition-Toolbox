function hCB = setUniqAxesMap(haxes, colorMap, drawCB, CBPosition)
% set unique map to a given axes and draws colobar, if neccessary
%   Input: colormap [number of colors x 3 channels]
%   haxes    - axes handle or object
%   drawCB   - draw colorbar if true (default, 0)
%   hCB
%% Author: Kirill Veselkov, Imperial College London, 2015
if nargin<3
    drawCB = 0;
end

if ~ishandle(haxes)
    haxes = gca;
end

% check matlab version
matver = version;
% if matlab version R2014b or older the colormap can be specific to axes
if str2num(matver(1:3))>=8.4
    colormap(haxes,colorMap);
    if drawCB ==1
        if nargin ==4
            hCB = colorbar('Position',CBPosition);
        else
            hCB = colorbar;
        end
    end    
else
    % otherwise rely on external functions
    colormap(colorMap);
    freezeColors(haxes);
    if drawCB==1 
        if nargin ==4
            hCB = colorbar('Position',CBPosition);
        else
            hCB = colorbar;
        end
        hCB = cbfreeze(hCB);
    end
end

return;

% attach colormap and draw colobar
