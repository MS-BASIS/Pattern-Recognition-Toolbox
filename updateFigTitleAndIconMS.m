function updateFigTitleAndIconMS(h,title,filename)
set(h,'name',title,'numbertitle','off')
javaFrame = get(h,'JavaFrame');
iconImage = javax.swing.ImageIcon(filename);
javaFrame.setFigureIcon(iconImage);