function redRatio = dataRedRatio(nDPs,hAxis)
if nargin < 2
     hAxis = gca;
end
pos          = getpixelposition(hAxis); 
pixels       = pos(3);                       % Width of the axes in pixels
sampleRate   = 2;                            % Data points per pixel
DPsToPlot    = sampleRate * pixels;          % Number of data points to plot
redRatio = max(1,floor(nDPs/DPsToPlot)); 