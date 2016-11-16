function varargout = vesselSegmentationGUI(varargin)
%VESSELSEGMENTATIONGUI M-file for vesselSegmentationGUI.fig
%      VESSELSEGMENTATIONGUI, by itself, creates a new VESSELSEGMENTATIONGUI or raises the existing
%      singleton*.
%
%      H = VESSELSEGMENTATIONGUI returns the handle to a new VESSELSEGMENTATIONGUI or the handle to
%      the existing singleton*.
%
%      VESSELSEGMENTATIONGUI('Property','Value',...) creates a new VESSELSEGMENTATIONGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to vesselSegmentationGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      VESSELSEGMENTATIONGUI('CALLBACK') and VESSELSEGMENTATIONGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in VESSELSEGMENTATIONGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vesselSegmentationGUI

% Last Modified by GUIDE v2.5 16-Nov-2016 13:21:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vesselSegmentationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @vesselSegmentationGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before vesselSegmentationGUI is made visible.
function vesselSegmentationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for vesselSegmentationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vesselSegmentationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = vesselSegmentationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
    str = get(hObject,'String');
    val = get(hObject, 'Value');
    switch str{val};
        case 'Scale space' % User selects peaks.
            handles.seg_img = vesselSegmentation.getVasculatureScaleSpace;
        case 'matched filter response' % User selects membrane.
            handles.seg_img = vesselSegmentation.getVasculatureMatchedFilterResponse(handles.source_img,7,0.5);
        case 'motion blur' % User selects sinc.
            handles.seg_img = vesselSegmentation.getVasculatureMotionBlur(handles.source_img,9);
    end
    
    axes(handles.axes2);
    imshow(handles.seg_img, [], 'XData', [0 1], 'YData', [0 1]);
    guidata(hObject, handles);

    

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fileselect.
function fileselect_Callback(hObject, eventdata, handles)
% hObject    handle to fileselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [basename, folder] = uigetfile('./data');
    img = imread(strcat(folder,'/',basename));
    handles.source_img = img;
    axes(handles.axes1);
    imshow(img, [], 'XData', [0 1], 'YData', [0 1]);
    guidata(hObject, handles);
    

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
        pos = get(hObject, 'Value');
        if(pos==0)
            pos=-1;
        end
        post_processed = vesselSegmentation.connectedComponentThres(handles.seg_img,pos);        
        axes(handles.axes2);
        imshow(post_processed, [], 'XData', [0 1], 'YData', [0 1]);
% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
