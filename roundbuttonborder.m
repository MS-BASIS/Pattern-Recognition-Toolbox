function roundbuttonborder(hbutton)
% round button border (mainly for mac)

%if ~strcmp(get(hbutton,'style'),'togglebutton')
    jbutton        = findjobj(hbutton);
    %jbutton.border = jbutton.border.getToolBarButtonBorder;
    jbutton.repaint
%end


