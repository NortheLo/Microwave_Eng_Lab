    function varargout = gpibGui1v1(varargin)
% GPIBGUI MATLAB code for gpibGui.fig
%      GPIBGUI, by itself, creates a new GPIBGUI or raises the existing
%      singleton*.
%
%      H = GPIBGUI returns the handle to a new GPIBGUI or the handle to
%      the existing singleton*.
%
%      GPIBGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GPIBGUI.M with the given input arguments.
%
%      GPIBGUI('Property','Value',...) creates a new GPIBGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gpibGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gpibGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gpibGui

% Last Modified by GUIDE v2.5 02-Nov-2017 15:57:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gpibGui_OpeningFcn, ...
                   'gui_OutputFcn',  @gpibGui_OutputFcn, ...
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


% --- Executes just before gpibGui is made visible.
function gpibGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gpibGui (see VARARGIN)

% Choose default command line output for gpibGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gpibGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gpibGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btSweepStart.
function btSweepStart_Callback(hObject, eventdata, handles)
% hObject    handle to btSweepStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    vs=getappdata(handles.figure1,'adapter');

    %read start, stop and points
    writeline(vs.a,':SENSe:NFIGure:FREQuency:STARt?');
    startFreq=fscanf(vs.a,'%f')/1e6;
    writeline(vs.a,':SENSe:NFIGure:FREQuency:STOP?');
    stopFreq=fscanf(vs.a,'%f')/1e6;
    writeline(vs.a,':SENSe:NFIGure:SWEep:POINts?');
    points=fscanf(vs.a,'%i');
    stepFreq=(stopFreq-startFreq)/(points-1);
    %update gui
    set(handles.teStart,'string',num2str(startFreq));
    set(handles.teStop,'string',num2str(stopFreq));
    set(handles.teStep,'string',num2str(stepFreq));
    
    freq=linspace(startFreq, stopFreq, points);
    
    writeline(vs.a,':READ:NFIGure:ARRay:CORRected:NFIGure?');
    noise = str2num(strrep(fscanf(vs.a),',',' '));
    writeline(vs.a,':FETCh:NFIGure:ARRay:CORRected:GAIN?');
    gain = str2num(strrep(fscanf(vs.a),',',' '));
    
    noise(noise == 9.91E+37) = NaN;
    gain(gain == 9.91E+37) = NaN;
    
    plot(handles.axgain,freq,gain);
    ylabel(handles.axgain,'Insertion Gain in dB');
    xlabel(handles.axgain,'Frequency in MHz');
    xlim([freq(1) freq(end)])
    
    plot(handles.axnoise,freq,noise);
    ylabel('Noise Figure in dB');
    xlabel('Frequency in MHz');
    xlim([freq(1) freq(end)])
    
    setappdata(handles.figure1,'messung',struct('gain',gain,'noise',noise,'f',freq));



% --- Executes on button press in btGpibInit.
function btGpibInit_Callback(hObject, eventdata, handles)
% hObject    handle to btGpibInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  %% Init
    
    switch(get(handles.mAdapter,'value'))
        case 1
            vs = visadev('GPIB0::1::INSTR'); %agilent
        case 2
            vs = visadev('GPIB0::18::INSTR'); %ni
    end

    vs
   
    %necessary minimum input buffer size can be calculated as datapoints*16+4.
    vs.InputBufferSize=2048;
    %some measurements can take a long time, so set the timeout to two
    %minutes
    %vs.Timeout = 120;
    set(vs,'Timeout',120);
    
    %fopen(vs);
    CleanUpTask=onCleanup(@() fclose(vs));
 
    %Rückgabe Format umstellen
    writeline(vs,'H1');
    setappdata(handles.figure1,'adapter',struct('a',vs,'CleanF',CleanUpTask));
 
    set(handles.btGpibInit,'Enable','off') 

% --- Executes on button press in btSave2W.
function btSave2W_Callback(hObject, eventdata, handles)
% hObject    handle to btSave2W (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    messung= getappdata(handles.figure1,'messung');
    assignin('base',get(handles.teSave2W,'String'),messung); 
