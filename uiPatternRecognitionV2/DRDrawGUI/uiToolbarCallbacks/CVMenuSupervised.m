function varargout = CVMenuSupervised(varargin)
%% creates menu for cross validation of supervised dimension reduction

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CVMenuSupervised_OpeningFcn, ...
                   'gui_OutputFcn',  @CVMenuSupervised_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
               
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

%% menu callback functions
function CVMenuSupervised_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject; guidata(hObject, handles);

function varargout = CVMenuSupervised_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function listbox1_Callback(hObject, eventdata, handles)
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu1_Callback(hObject, eventdata, handles)
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu2_Callback(hObject, eventdata, handles)
h       = guidata(hObject);
cvTypes = get(h.popupmenu2,'String');
cvType  = cvTypes{get(h.popupmenu2,'Value')};
switch strtrim(cvType)
    case 'K-fold'
        set(h.text4,'Visible','on');
        set(h.edit3,'Visible','on');
    case 'Leave one out'
        set(h.text4,'Visible','off');
        set(h.edit3,'Visible','off');
end

function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu3_Callback(hObject, eventdata, handles)
h    = guidata(hObject);
classifierTypes = get(h.popupmenu3,'String');
classifierType  = strtrim(classifierTypes{get(h.popupmenu3,'Value')});
switch classifierType
    case 'knn'
        set(h.text6,'Visible','on');
        set(h.edit4,'Visible','on');
    case 'mahalanobis'
        set(h.text6,'Visible','off');
        set(h.edit4,'Visible','off');
    case 'quadratic'
        set(h.text6,'Visible','off');
        set(h.edit4,'Visible','off');
end

function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu4_Callback(hObject, eventdata, handles)
h    = guidata(hObject);
classifierTypes = get(h.popupmenu4,'String');
classifierType  = strtrim(classifierTypes{get(h.popupmenu4,'Value')});
switch classifierType
    case 'Yes'
        set(h.text8,'Visible','on');
        set(h.edit5,'Visible','on');
        set(h.text12,'Visible','on');
        set(h.checkbox1,'Visible','on');
        set(h.text13,'Visible','on');
        set(h.checkbox2,'Visible','on');
    case 'No'
        set(h.text8,'Visible','off');
        set(h.edit5,'Visible','off');
        set(h.text12,'Visible','off');
        set(h.checkbox1,'Visible','off');
        set(h.text13,'Visible','off');
        set(h.checkbox2,'Visible','off');
end

function pushbutton2_Callback(hObject, eventdata, handles)
h        = guidata(hObject);
cvTypes = get(h.popupmenu2,'String');
cv.Type{1}  = strtrim(cvTypes{get(h.popupmenu2,'Value')});
if strcmp(cv.Type{1},'K-fold')
    cv.Type{2} = str2double(get(h.edit3,'String'));
    cv.Name    = [get(h.edit3,'String'),'-fold'];
else
    cv.Name  = cv.Type{1};
end
cv.nComps = str2double(get(h.edit2,'String'));

classifierTypes = get(h.popupmenu3,'String');
cv.classifierType{1}  = strtrim(classifierTypes{get(h.popupmenu3,'Value')});
if strcmp(cv.classifierType{1},'knn')
    cv.classifierType{2}  = str2double(get(h.edit4,'String'));
    cv.classifierName     = [get(h.edit4,'String'),'-nn'];
else
    cv.classifierName = cv.classifierType{1};
end

anovaFeatSel = get(h.popupmenu4,'String');
cv.anovaFeatSel.do = strtrim(anovaFeatSel{get(h.popupmenu4,'Value')});
if strcmp(cv.anovaFeatSel.do,'Yes')
    cv.anovaFeatSel.pValThresh  = str2double(get(h.edit5,'String'));
    cv.anovaFeatSel.diagnostics = get(h.checkbox1,'Value');
    cv.anovaFeatSel.exportData  = get(h.checkbox2,'Value');
end

delete(h.figure1);
DRdata    = guidata(h.hMainFig);
DRdata.cv = cv;
uiCrossValidation(DRdata);
return;