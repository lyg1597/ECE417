function varargout = cbirMP(varargin)
%CBIRMP M-file for cbirMP.fig
%      CBIRMP, by itself, creates a new CBIRMP or raises the existing
%      singleton*.
%
%      H = CBIRMP returns the handle to a new CBIRMP or the handle to
%      the existing singleton*.
%
%      CBIRMP('Property','Value',...) creates a new CBIRMP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to cbirMP_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CBIRMP('CALLBACK') and CBIRMP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CBIRMP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cbirMP

% Last Modified by GUIDE v2.5 01-Apr-2008 11:47:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cbirMP_OpeningFcn, ...
                   'gui_OutputFcn',  @cbirMP_OutputFcn, ...
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


% --- Executes just before cbirMP is made visible.
function cbirMP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for cbirMP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cbirMP wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%----- loading the database -----
string = 'LOADING DATABASE FILES...';
set(handles.info_box,'String',string); 
pause(1)

load databaseInfo.mat

string = 'DATABASE FILES LOADED.';
set(handles.info_box,'String',string);

round=0;
session=0;
precision=zeros(5,3);
handles.round=round;
handles.session=session;
handles.precision=precision;

handles.META_DATA = META_DATA; 
handles.filenames = LIST;
guidata(hObject,handles)

clear META_DATA filenames clases;

%----- initialize RF weighting matrix -----
W = eye(size(handles.META_DATA,1));
handles.W = W;
guidata(hObject,handles);

%----- display a random image -----
h2=handles.axes1;
axes(h2); 

imgInd = randi(size(handles.META_DATA,2),1,1);
handles.currentfilename = strcat('IMAGES/',handles.filenames(imgInd,:));
handles.posInds = imgInd;
guidata(hObject,handles);

imshow(handles.currentfilename)

handles.currentTopInds = [];

guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = cbirMP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in query_button.
function query_button_Callback(hObject, eventdata, handles)
% hObject    handle to query_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

string = 'RETRIEVING IMAGES';
set(handles.info_box,'String',string); 
pause(1)

%get the feedback information
for i=1:20
    feedback(i) = eval(strcat('get(handles.rfRadio',num2str(i),',''Value'')'));
end
handles.posInds = unique([handles.posInds,handles.currentTopInds(find(feedback))]);
guidata(hObject,handles);

%=========================================================================
%=========================================================================
%
% START FILLING-IN RETRIEVAL FUNCTION (AS IN 3.1 HERE)
%
%=========================================================================
%=========================================================================

%compute the query centroid (#1)
 qc=zeros(47,1);
 currentTopInds=zeros(1,20);
 dist=zeros(1,1400);
 rank=zeros(1,1400);
 sorted_ind=zeros(1,1400);
 for n=1:47
      qc(n)=mean(handles.META_DATA(n,handles.posInds));
 end

%compute the weighting matrix
%(this line is for free. un-comment once you've written the RF function)
 W = RF(handles);
 handles.W = W;
 
%compute weighted distances (#2)
 for n=1:1400
     dist(n)=((qc-handles.META_DATA(:,n)).')*W*(qc-handles.META_DATA(:,n));
 end
 
%return rank-sorted list of top indices (#3)
for n=2:1400
     for m=1:n
         if dist(m)>=dist(n)
             rank(n)=rank(n)+1;
         else
             rank(m)=rank(m)+1;
         end
     end
 end
 
 for n=1:1400
     sorted_ind(1401-rank(n))=n;
 end
 
 for n=1:20
     currentTopInds(n)=sorted_ind(n);
 end
 handles.currentTopInds=currentTopInds;
 
 %record precision information and plot the result
 if W==eye(47)
     handles.round=0;
     handles.session=handles.session+1;
 else
     handles.round=handles.round+1;
     handles.precision(handles.session,handles.round)=length(handles.posInds)/20;
 end
 
 if(handles.session==5 && handles.round==3)
     figure(open(cbirMP.fig));
    subplot(5,1,1);
    plot([1,2,3],handles.precision(1,1:3));
    subplot(5,1,2);
    plot([1,2,3],handles.precision(2,1:3));
    subplot(5,1,3);
    plot([1,2,3],handles.precision(3,1:3));
    subplot(5,1,4);
    plot([1,2,3],handles.precision(4,1:3));
    subplot(5,1,5);
    plot([1,2,3],handles.precision(5,1:3));
 end
%=========================================================================
%=========================================================================
%
% STOP FILLING-IN RETRIEVAL FUNCTION (AS IN 3.1 HERE)
%
%=========================================================================
%=========================================================================

%plot outputs
if ~isempty(handles.currentTopInds)
    for i=1:20
        h=eval(strcat('handles.',sprintf('axes%d',i+1)));   
        axes(h); 

        handles.currentfilename = strcat('IMAGES/',handles.filenames(handles.currentTopInds(i),:));

        imshow(handles.currentfilename)
    end
end

%set the feedback information to zero
for i=1:20
    eval(strcat('set(handles.rfRadio',num2str(i),',''Value'',0)'));
end

string = 'PLEASE PROVIDE FEEDBACK...';
set(handles.info_box,'String',string); 
pause(1)

guidata(hObject,handles);

% --- Computes the weighting matrix for Relevance Feedback
function W = RF(handles)

%=========================================================================
%=========================================================================
%
% START FILLING-IN RELEVANCE FEEDBACK FUNCTION (AS IN 3.2 HERE)
%
%=========================================================================
%=========================================================================
W=zeros(47);

if size(handles.posInds)==1
    W=eye(47);
else
    for n=1:47
        W(n,n)=1/(var(handles.META_DATA(n,handles.posInds),1)+0.0222);
    end
end
    

%=========================================================================
%=========================================================================
%
% STOP FILLING-IN RELEVANCE FEEDBACK FUNCTION (AS IN 3.2 HERE)
%
%=========================================================================
%=========================================================================

% --- Executes on button press in random_button.
function random_button_Callback(hObject, eventdata, handles)
% hObject    handle to random_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----- display a random image -----
h=handles.axes1;
axes(h); 

imgInd = randi(size(handles.META_DATA,2),1,1);
handles.currentfilename = strcat('IMAGES/',handles.filenames(imgInd,:));
handles.posInds = imgInd;
guidata(hObject,handles);

set(handles.info_box,'String',handles.filenames(imgInd,:)); 

imshow(handles.currentfilename)

%----- re-initialize data structures -----
handles.W = eye(size(handles.META_DATA,1));;
handles.currentTopInds = [];

%set the feedback information to zero
for i=1:20
    eval(strcat('set(handles.rfRadio',num2str(i),',''Value'',0)'));
end

guidata(hObject,handles);

% --- Executes on button press in filenameDropDown.
function fileget_button_Callback(hObject, eventdata, handles)
% hObject    handle to filenameDropDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----- get the image from the drop-down-----
fileNum = get(handles.filenameDropDown,'Value');
allNames = get(handles.filenameDropDown,'String');
handles.currentfilename = strcat('IMAGES/',allNames{fileNum});

imgInd = find(sum((handles.filenames == repmat(allNames{fileNum},size(handles.META_DATA,2),1))') == 10);
handles.currentfilename = strcat('IMAGES/',handles.filenames(imgInd,:));
handles.posInds = imgInd;

guidata(hObject,handles);

h=handles.axes1;
axes(h); 

imshow(handles.currentfilename)

%----- re-initialize data structures -----
handles.W = eye(size(handles.META_DATA,1));;
handles.currentTopInds = [];

%set the feedback information to zero
for i=1:20
    eval(strcat('set(handles.rfRadio',num2str(i),',''Value'',0)'));
end

guidata(hObject,handles);



function rfRadio1_Callback(hObject, eventdata, handles)
function rfRadio2_Callback(hObject, eventdata, handles)
function rfRadio3_Callback(hObject, eventdata, handles)
function rfRadio4_Callback(hObject, eventdata, handles)
function rfRadio5_Callback(hObject, eventdata, handles)
function rfRadio6_Callback(hObject, eventdata, handles)
function rfRadio7_Callback(hObject, eventdata, handles)
function rfRadio8_Callback(hObject, eventdata, handles)
function rfRadio9_Callback(hObject, eventdata, handles)
function rfRadio10_Callback(hObject, eventdata, handles)
function rfRadio11_Callback(hObject, eventdata, handles)
function rfRadio12_Callback(hObject, eventdata, handles)
function rfRadio13_Callback(hObject, eventdata, handles)
function rfRadio14_Callback(hObject, eventdata, handles)
function rfRadio15_Callback(hObject, eventdata, handles)
function rfRadio16_Callback(hObject, eventdata, handles)
function rfRadio17_Callback(hObject, eventdata, handles)
function rfRadio18_Callback(hObject, eventdata, handles)
function rfRadio19_Callback(hObject, eventdata, handles)
function rfRadio20_Callback(hObject, eventdata, handles)
function filenameDropDown_Callback(hObject, eventdata, handles)