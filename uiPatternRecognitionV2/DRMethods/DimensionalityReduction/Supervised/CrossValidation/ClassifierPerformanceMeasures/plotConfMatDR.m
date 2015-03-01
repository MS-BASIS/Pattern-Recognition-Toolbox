function plotConfMatDR(confMat,classids,fontsize)
%% plotConfMatDR plot confusion matrix
% Input: confMat - confusion matrix 
%        classids - class names
%% Author: Kirill A. Veselkov, Imperial College London, 2012
if nargin<3
    fontsize = 10;
end
    
imagesc(confMat.acc,[0,100]); 
colormap(flipud(gray)); 
nClasses   = length(classids);
accStrings = strtrim(cellstr(num2str(confMat.acc(:),'%0.1f')));
samStrings = strtrim(cellstr(num2str(confMat.smpls(:),'%0.0f')));
nCells     = length(samStrings);
for i = 1:nCells
    cellIds{i} = [accStrings{i},'%, ',samStrings{i}];
end
[x,y]       = meshgrid(1:nClasses); 
hCells      = text(x(:),y(:),cellIds(:), 'HorizontalAlignment','center','FontSize',fontsize);
midValue    = mean(get(gca,'CLim')); 
textColors  = repmat(confMat.acc(:) > midValue,1,3); 
set(hCells,{'Color'},num2cell(textColors,2));  %# Change the text colors
set(gca,'xtick',1:nClasses);
set(gca,'ytick',1:nClasses);
set(gca,'xticklabel',classids,'XAxisLocation','bottom','FontSize',fontsize);
set(gca,'yticklabel',classids,'XAxisLocation','bottom','FontSize',fontsize);
%rotateticklabel(gca,135)
xlabel('Target Class','FontSize',fontsize+2);
ylabel('Predicted Class','FontSize',fontsize+2);
%rotateXLabels(gca, 315); 
set(gca,'yticklabel',classids);