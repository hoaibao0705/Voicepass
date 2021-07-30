function varargout = voicepass(varargin)
% VOICEPASS MATLAB code for voicepass.fig
%      VOICEPASS, by itself, creates a new VOICEPASS or raises the existing
%      singleton*.
%
%      H = VOICEPASS returns the handle to a new VOICEPASS or the handle to
%      the existing singleton*.
%
%      VOICEPASS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOICEPASS.M with the given input arguments.
%
%      VOICEPASS('Property','Value',...) creates a new VOICEPASS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voicepass_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voicepass_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voicepass

% Last Modified by GUIDE v2.5 07-Jul-2021 15:34:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voicepass_OpeningFcn, ...
                   'gui_OutputFcn',  @voicepass_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before voicepass is made visible.
function voicepass_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voicepass (see VARARGIN)

% Choose default command line output for voicepass
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voicepass wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voicepass_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Nut nhan btnLogin.
function btnLogin_Callback(hObject, eventdata, handles)
% hObject    handle to btnLogin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global master1;
global master2;
global master3;
global s;
%thu am
set(handles.btnLogin,'Enable','off','BackgroundColor','green');
sig = audiorecorder(44100,16,1);
recordblocking(sig,3);
set(handles.btnLogin,'BackgroundColor','red');
login = getaudiodata(sig);

%trich xuat, so sanh dac trung
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
[MFCC1,~,~] = mfcc(master1, 44100, 25, 10, 0.97, hamming, [300 3700], 20, 13, 22 );
[MFCC2,~,~] = mfcc(master2, 44100, 25, 10, 0.97, hamming, [300 3700], 20, 13, 22 );
[MFCC3,~,~] = mfcc(master3, 44100, 25, 10, 0.97, hamming, [300 3700], 20, 13, 22 );
[MFCC,~,~] = mfcc(login, 44100, 25, 10, 0.97, hamming, [300 3700], 20, 13, 22 );

d(1) = dtw(MFCC,MFCC1); 
d(2) = dtw(MFCC,MFCC2); 
d(3) = dtw(MFCC,MFCC3);
disp(d);
%xuat ket qua
if ( (d(1) <= 4.6e+03) | (d(2)<=4.6e+03) | (d(3)<=4.6e+03) ) 
    set(handles.pn1,'Visible','off');
    set(handles.pn3,'Visible','on');
    fwrite (s,['a']);
else
    set(handles.pn1,'Visible','off');
    set(handles.pn2,'Visible','on');
end

% --- Nut nhan btnAgain.
function btnAgain_Callback(hObject, eventdata, handles)
% hObject    handle to btnAgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnLogin,'Enable','on','BackgroundColor',[0.8 0.8 0.8])
set(handles.pn1,'Visible','on');
set(handles.pn2,'Visible','off');

% --- Nut nhan btnSetup.
function btnSetup_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnSetup,'Enable','off','BackgroundColor','green');
sig = audiorecorder(44100,16,1);
recordblocking(sig,3);
set(handles.btnSetup,'BackgroundColor','red');
pause(0.3);
temp = getaudiodata(sig);
audiowrite('D:\hbao\Matlab\voicepass\audio\master1.wav',temp,44100);
set(handles.pn4,'Visible','on');
set(handles.pn3,'Visible','off');

% --- Mo ung dung
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global s;
global master1;
global master2;
global master3;
s = serial('COM6');
fopen(s);
master1 = audioread('D:\hbao\Matlab\voicepass\audio\master1.wav');
master2 = audioread('D:\hbao\Matlab\voicepass\audio\master2.wav');
master3 = audioread('D:\hbao\Matlab\voicepass\audio\master3.wav');

% --- Dong ung dung
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fclose(s);
delete (s);
clear s;
set(handles.btnLogin,'Enable','on','BackgroundColor',[0.8 0.8 0.8])
set(handles.pn1,'Visible','on');
set(handles.pn2,'Visible','off');
set(handles.pn3,'Visible','off');
set(handles.pn4,'Visible','off');

% --- Nut nhan btnComfirm2.
function btnComfirm2_Callback(hObject, eventdata, handles)
% hObject    handle to btnComfirm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnComfirm2,'Enable','off','BackgroundColor','green');
sig = audiorecorder(44100,16,1);
recordblocking(sig,3);
set(handles.btnComfirm2,'BackgroundColor','red');
pause(0.3);
temp = getaudiodata(sig);
audiowrite('D:\hbao\Matlab\voicepass\audio\master3.wav',temp,44100);
set(handles.btnComfirm2,'Visible','off');
set(handles.btnLock2,'Visible','on');

% --- Nut nhan btnComfirm1.
function btnComfirm1_Callback(hObject, eventdata, handles)
% hObject    handle to btnComfirm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnComfirm1,'Enable','off','BackgroundColor','green');
sig = audiorecorder(44100,16,1);
recordblocking(sig,3);
set(handles.btnComfirm1,'BackgroundColor','red');
pause(0.3);
temp = getaudiodata(sig);
audiowrite('D:\hbao\Matlab\voicepass\audio\master2.wav',temp,44100);
set(handles.btnComfirm1,'Visible','off');
set(handles.btnComfirm2,'Visible','on');

% --- Nut nhan btnLock.
function btnLock_Callback(hObject, eventdata, handles)
% hObject    handle to btnLock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fwrite (s,['b']);
global master1;
global master2;
global master3;
master1 = audioread('D:\hbao\Matlab\voicepass\audio\master1.wav');
master2 = audioread('D:\hbao\Matlab\voicepass\audio\master2.wav');
master3 = audioread('D:\hbao\Matlab\voicepass\audio\master3.wav');
set(handles.btnLogin,'Enable','on','BackgroundColor',[0.8 0.8 0.8])
set(handles.pn1,'Visible','on');
set(handles.pn3,'Visible','off');

% --- Nut nhan btnLock2.
function btnLock2_Callback(hObject, eventdata, handles)
% hObject    handle to btnLock2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fwrite (s,['b']);
global master1;
global master2;
global master3;
master1 = audioread('D:\hbao\Matlab\voicepass\audio\master1.wav');
master2 = audioread('D:\hbao\Matlab\voicepass\audio\master2.wav');
master3 = audioread('D:\hbao\Matlab\voicepass\audio\master3.wav');
set(handles.btnLogin,'Enable','on','BackgroundColor',[0.8 0.8 0.8])
set(handles.pn1,'Visible','on');
set(handles.pn4,'Visible','off');
set(handles.btnLock2,'Visible','off');
set(handles.btnSetup,'Enable','on','BackgroundColor',[0.8 0.8 0.8]);
set(handles.btnComfirm1,'Enable','on','BackgroundColor',[0.8 0.8 0.8],'Visible','on');
set(handles.btnComfirm2,'Enable','on','BackgroundColor',[0.8 0.8 0.8],'Visible','on');
