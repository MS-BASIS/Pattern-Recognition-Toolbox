function uiCVMenuSupervised(hMainFig)
hmenu      = CVMenuSupervised();
h          = guidata(hmenu);
DRdata     = guidata(hMainFig);
h.hMainFig = hMainFig;
set(h.edit2,'Tag','nComps');
set(h.edit2,'String',num2str(size(DRdata.scores,2)));
set(h.edit2,'Callback',[]);
set(h.edit2,'CreateFcn',[])
set(h.text2,'Tag','classiferType');
set(h.text3,'Tag','CVtype');
set(h.text4,'Tag','nFolds');
set(h.edit3,'Tag','nFolds');
set(h.edit3,'Callback',[]);
set(h.edit3,'CreateFcn',[]);
set(h.popupmenu2,'Tag','CVtype');
set(h.text6,'Tag','NNN');
set(h.edit4,'Tag','NNN');
set(h.edit4,'Callback',[]);
set(h.edit4,'CreateFcn',[]);
set(h.popupmenu3,'Tag','classiferType');
set(h.popupmenu4,'Tag','anovaFeatureSelection');
set(h.edit5,'Callback',[]);
set(h.edit5,'CreateFcn',[]);
set(h.text7,'Tag','anovaFeatureSelection');
set(h.text8,'Tag','pValThresh');

guidata(hmenu,h);