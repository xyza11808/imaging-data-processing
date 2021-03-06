
function varargout = CaSignal_ROI_GUI(varargin)
% CaSignal_ROI_GUI M-file for CaSignal_ROI_GUI.fig
%      CaSignal_ROI_GUI, by itself, creates a new CaSignal_ROI_GUI or raises the existing
%      singleton*.
%
%      H = CaSignal_ROI_GUI returns the handle to a new CaSignal_ROI_GUI or the handle to
%      the existing singleton*.
%
%      CaSignal_ROI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CaSignal_ROI_GUI.M with the given input arguments.
%
%      CaSignal_ROI_GUI('Property','Value',...) creates a new CaSignal_ROI_GUI or raises the
% CaSignal_ROI_GUI M-file for CaSignal_ROI_GUI.fig
%      CaSignal_ROI_GUI, by itself, creates a new CaSignal_ROI_GUI or raises the existing
%      singleton*.
%
%      H = CaSignal_ROI_GUI returns the handle to a new CaSignal_ROI_GUI or the handle to
%      the existing singleton*.
%
%      CaSignal_ROI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CaSignal_ROI_GUI.M with the given input arguments.
%
%      CaSignal_ROI_GUI('Property','Value',...) creates a new CaSignal_ROI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CaSignal_ROI_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CaSignal_ROI_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CaSignal_ROI_GUI

% Last Modified by GUIDE v2.5 31-Oct-2013 16:14:37

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CaSignal_ROI_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CaSignal_ROI_GUI_OutputFcn, ...
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


% --- Executes just before CaSignal_ROI_GUI is made visible.
function CaSignal_ROI_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
global CaSignal % ROIinfo ICA_ROIs
% Choose default command line output for CaSignal_ROI_GUI
handles.output = hObject;
usrpth = userpath; % usrpth = usrpth(1:end-1);
if exist([usrpth filesep 'nx_CaSingal.info'],'file')
    load([usrpth filesep 'nx_CaSingal.info'], '-mat');
    set(handles.DataPathEdit, 'String',info.DataPath);
    set(handles.AnimalNameEdit, 'String', info.AnimalName);
    set(handles.ExpDate,'String',info.ExpDate);
    set(handles.SessionName, 'String',info.SessionName);
    if isfield(info, 'SoloDataPath')
        set(handles.SoloDataPath, 'String', info.SoloDataPath);
        set(handles.SoloDataFileName, 'String', info.SoloDataFileName);
        set(handles.SoloSessionName, 'String', info.SoloSessionName);
        set(handles.SoloStartTrialNo, 'String', info.SoloStartTrialNo);
        set(handles.SoloEndTrialNo, 'String', info.SoloEndTrialNo);
    end
else
    set(handles.DataPathEdit, 'String', '/Users/xun/Documents/ExpData/2p-Imaging/');
    set(handles.SoloDataPath, 'String', '/Users/xun/Documents/ExpData/Whisker_Behavior_Data/SoloData/Data_2PRig/');
end
% Initialize handles
    % Open and Display section
set(handles.dispModeGreen, 'Value', 1);
set(handles.dispModeRed, 'Value', 0);
set(handles.dispModeImageInfoButton, 'Value', 0);
set(handles.dispModeWithROI, 'Value', 1);
% set(handles.LUTminEdit, 'Value', 0);
% set(handles.LUTmaxEdit, 'Value', 500);
% set(handles.LUTminSlider, 'Value', 0);
% set(handles.LUTmaxSlider, 'Value', 0.5);
set(handles.CurrentImageFilenameText, 'String', 'Current Image Filename');
    % ROI section
set(handles.nROIsText, 'String', '0');
set(handles.CurrentROINoEdit, 'String', '1');
set(handles.ROITypeMenu, 'Value', 1);
    % Analysis mode
set(handles.AnalysisModeDeltaFF, 'Value', 1);
set(handles.AnalysisModeBGsub, 'Value', 0);
set(handles.batchStartTrial, 'String', '1');
set(handles.batchEndTrial, 'String', '1');
% set(handles.ROI_Edit_button, 'Value', 0);
set(handles.CurrentFrameNoEdit,'String',1);
set(handles.setTargetMaxDelta,'Value',0);
set(handles.setTargetCurrentFrame,'Value',0);
set(handles.setTargetMean,'Value',0);

CaSignal.CaTrials = struct([]);
CaSignal.ROIinfo = struct('ROImask',{}, 'ROIpos',{}, 'ROItype',{},'BGpos',[],...
        'BGmask', [], 'ROI_def_trialNo',[], 'Method','');
% CaSignal.ICA_ROIs = struct('ROImask',{}, 'ROIpos',{}, 'ROItype',{},'Method','ICA');
CaSignal.ImageArray = [];
CaSignal.nFrames = 0;
% handles.userdata.CaTrials = [];
CaSignal.h_info_fig = NaN;
CaSignal.FrameNum = 1;
CaSignal.imSize = [];
CaSignal.h_img = NaN;
CaSignal.Scale = [0 500];
% ROIinfo = {};
% ICA_ROIs = struct;
CaSignal.ROIplot = NaN;
CaSignal.avgCorrCoef_trials = [];
CaSignal.CorrMapTrials = [];
CaSignal.CorrMapROINo = [];
CaSignal.AspectRatio_mode = 'Square';
CaSignal.ICA_figs = nan(1,2);
CaSignal.CurrentTrialNo = [];
CaSignal.Last_TrialNo = [];
CaSignal.results_path = [];
CaSignal.results_fname = [];
CaSignal.ROIinfo_fname = [];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CaSignal_ROI_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CaSignal_ROI_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function CaTrial = init_CaTrial(filename, TrialNo, header)
% Initialize the struct data for the current trial
CaTrial.DataPath = pwd;
CaTrial.FileName = filename;
CaTrial.FileName_prefix = filename(1:end-7);

CaTrial.TrialNo = TrialNo;
if isfield(header, 'acq')
    CaTrial.DaqInfo = header;
    CaTrial.nFrames = header.acq.numberOfFrames;
    CaTrial.FrameTime = header.acq.msPerLine*header.acq.linesPerFrame;
elseif isfield(header, 'SI4')
    CaTrial.DaqInfo = header.SI4;
    CaTrial.nFrames = header.SI4.acqNumFrames;
    CaTrial.FrameTime = header.SI4.scanFramePeriod;
else
    CaTrial.nFrames = header.n_frame;
    CaTrial.FrameTime = [];
end
if CaTrial.FrameTime < 1 % some earlier version of ScanImage use sec as unit for msPerLine
    CaTrial.FrameTime = CaTrial.FrameTime*1000;
end
CaTrial.nROIs = 0;
CaTrial.BGmask = []; % Logical matrix for background ROI
CaTrial.AnimalName = '';
CaTrial.ExpDate = '';
CaTrial.SessionName = '';
CaTrial.dff = [];
CaTrial.f_raw = [];
% CaTrial.meanImage = [];
CaTrial.RegTargetFrNo = [];
% CaTrial.ROIinfo = struct('ROImask',{}, 'ROIpos',{}, 'ROItype',{},'Method','');
CaTrial.ROIinfo = struct('ROImask',{}, 'ROIpos',{}, 'ROItype',{},'BGpos',[],...
        'BGmask', [], 'ROI_def_trialNo',[], 'Method','');
CaTrial.SoloDataPath = '';
CaTrial.SoloFileName = '';
CaTrial.SoloSessionName = '';
CaTrial.SoloTrialNo = [];
CaTrial.SoloStartTrialNo = [];
CaTrial.SoloEndTrialNo = [];
CaTrial.behavTrial = [];
% CaTrial.ROIType = '';

% --- Executes on button press in open_image_file_button.
function open_image_file_button_Callback(hObject, eventdata, handles, filename)
global CaSignal % ROIinfo ICA_ROIs
datapath = get(handles.DataPathEdit,'String');
if exist(datapath, 'dir')
    cd(datapath);
else
    warning([datapath ' not exist!'])
    if exist('/Users/xun/Documents/ExpData/2p-Imaging/','dir')
        cd('/Users/xun/Documents/ExpData/2p-Imaging/');
    end
end;
if ~exist('filename', 'var')
    [filename, pathName] = uigetfile('*.tif', 'Load Image File');
    if isequal(filename, 0) || isequal(pathName,0)
        return
    end
    cd(pathName);
    FileName_prefix = filename(1:end-7);
    CaSignal.data_files = dir([FileName_prefix '*.tif']);
    CaSignal.data_file_names = {};
    for i = 1:length(CaSignal.data_files)
        CaSignal.data_file_names{i} = CaSignal.data_files(i).name;
    end;
end
datapath = pwd;
set(handles.DataPathEdit,'String',datapath);

CaSignal.data_path = datapath;

FileName_prefix = filename(1:end-7);

disp(['Loading image file ' filename ' ...']);
set(handles.msgBox, 'String', ['Loading image file ' filename ' ...']);
% [im, header] = imread_multi(filename, 'g');
% read all frames, disregard number of channels, since green channel has
% been already selected during the process of registration.
[im, header] = load_scim_data(filename); 
% t_elapsed = toc;
set(handles.msgBox, 'String', ['Loaded file ' filename]);

TrialNo = find(strcmp(filename, CaSignal.data_file_names));
set(handles.CurrentTrialNo,'String', int2str(TrialNo));
CaSignal.CurrentTrialNo = TrialNo;

info = imfinfo(filename);
CaSignal.ImInfo = info;

if isfield(info(1), 'ImageDescription')
    CaSignal.ImageDescription = info(1).ImageDescription; % used by Turboreg
else
    CaSignal.ImageDescription = '';
end
CaSignal.ImageArray = im;
CaSignal.imSize = size(im);
if ~isempty(CaSignal.CaTrials)
    if length(CaSignal.CaTrials)<TrialNo || isempty(CaSignal.CaTrials(TrialNo).FileName)
        CaSignal.CaTrials(TrialNo) = init_CaTrial(filename, TrialNo, header);
    end
    if ~strcmp(CaSignal.CaTrials(TrialNo).FileName_prefix, FileName_prefix)
        CaSignal.CaTrials_INIT = 1;
    else
        CaSignal.CaTrials_INIT = 0;
    end
else
    CaSignal.CaTrials_INIT = 1;
end


if CaSignal.CaTrials_INIT == 1
   CaSignal.CaTrials = []; % ROIinfo = {};
    if exist(CaSignal.results_fname,'file')
        load(CaSignal.results_fname, '-mat');
        CaSignal.CaTrials = CaTrials;
    else
        A = init_CaTrial(filename, TrialNo, header);
        A(TrialNo) = A;
        if TrialNo ~= 1
            names = fieldnames(A);
            for i = 1:length(names)
                A(1).(names{i})=[];
            end
        end
        CaSignal.CaTrials = A;
    end
    
    if exist(CaSignal.ROIinfo_fname,'file')
        load(CaSignal.ROIinfo_fname, '-mat');
        if iscell(ROIinfo)
            f1 = fieldnames(ROIinfo{TrialNo}); f2 = fieldnames(CaSignal.ROIinfo);
            for i = 1:length(ROIinfo)
                for j = 1:length(f1),
                    CaSignal.ROIinfo(i).(f2{strcmpi(f2,f1{j})}) = ROIinfo{i}.(f1{j});
                end
            end
        else
            CaSignal.ROIinfo = ROIinfo;
        end
    end
else
    if get(handles.import_ROI_from_Trial_checkbox, 'Value') == 1
        import_ROIinfo_from_trial_Callback(handles.import_ROIinfo_from_trial, eventdata, handles);
    end
end

% if exist([CaSignal.results_path filesep FileName_prefix(1:end-7) '[dftShift].mat'],'file')
%     load([CaSignal.results_path filesep FileName_prefix(1:end-7) '[dftShift].mat']);
%     CaSignal.dftreg_shift = shift;
% else
%     CaSignal.dftreg_shift = [];
% end

% Collect info to be displayed in a separate figure

% if get(handles.dispModeImageInfoButton,'Value') == 1
if isfield(header,'acq')
    CaSignal.info_disp = {sprintf('numFramesPerTrial: %d', header.acq.numberOfFrames), ...
    ['Zoom: ' num2str(header.acq.zoomFactor)],...
    ['numOfChannels: ' num2str(header.acq.numberOfChannelsAcquire)],...
    sprintf('ImageDimXY: %d,  %d', header.acq.pixelsPerLine, header.acq.linesPerFrame),...
    sprintf('Frame Rate: %d', header.acq.frameRate), ...
    ['msPerLine: ' num2str(header.acq.msPerLine)],...
    ['fillFraction: ' num2str(header.acq.fillFraction)],...
    ['motor_absX: ' num2str(header.motor.absXPosition)],...
    ['motor_absY: ' num2str(header.motor.absYPosition)],...
    ['motor_absZ: ' num2str(header.motor.absZPosition)],...
    ['num_zSlice: ' num2str(header.acq.numberOfZSlices)],...
    ['zStep: ' num2str(header.acq.zStepSize)] ...
    ['triggerTime: ' header.internal.triggerTimeString]...
    };
else
    CaSignal.info_disp = [];
end
%     dispModeImageInfoButton_Callback(hObject, eventdata, handles)
% end;
%% Initialize UI values
set(handles.TotTrialNum, 'String', int2str(length(CaSignal.data_file_names)));
set(handles.CurrentImageFilenameText, 'String',  filename);
if CaSignal.CaTrials_INIT == 1
    set(handles.DataPathEdit, 'String', pwd);
    set(handles.AnimalNameEdit, 'String', CaSignal.CaTrials(TrialNo).AnimalName);
    set(handles.ExpDate,'String',CaSignal.CaTrials(TrialNo).ExpDate);
    set(handles.SessionName, 'String',CaSignal.CaTrials(TrialNo).SessionName);
    if isfield(CaSignal.CaTrials(TrialNo), 'SoloDataFileName')
        set(handles.SoloDataPath, 'String', CaSignal.CaTrials(TrialNo).SoloDataPath);
        set(handles.SoloDataFileName, 'String', CaSignal.CaTrials(TrialNo).SoloDataFileName);
        set(handles.SoloSessionName, 'String', CaSignal.CaTrials(TrialNo).SoloSessionName);
        set(handles.SoloStartTrialNo, 'String', num2str(CaSignal.CaTrials(TrialNo).SoloStartTrialNo));
        set(handles.SoloEndTrialNo, 'String', num2str(CaSignal.CaTrials(TrialNo).SoloEndTrialNo));
    end
end

nFrames = size(im, 3);
set(handles.FrameSlider, 'SliderStep', [1/nFrames 1/nFrames]);
set(handles.FrameSlider, 'Value', 1/nFrames);
if length(CaSignal.ROIinfo) >= TrialNo
    set(handles.nROIsText, 'String', int2str(length(CaSignal.ROIinfo(TrialNo).ROIpos)));
end
CaSignal.nFrames = nFrames;
set(handles.batchPrefixEdit, 'String', FileName_prefix);
%    handles = get_exp_info(hObject, eventdata, handles);
% CaSignal.CaTrials(TrialNo).meanImage = mean(im,3);

% update target info for TurboReg
% setTargetCurrentFrame_Callback(handles.setTargetCurrentFrame, eventdata, handles);
% setTargetMaxDelta_Callback(handles.setTargetMaxDelta, eventdata,handles);
% setTargetMean_Callback(handles.setTargetMaxDelta, eventdata, handles);

CaSignal.avgCorrCoef_trials = [];

% The trialNo to load ROIinfo from
TrialNo_load = str2double(get(handles.import_ROIinfo_from_trial,'String'));
if TrialNo_load > 0 && length(CaSignal.ROIinfo)>= TrialNo_load
    CaSignal.ROIinfo(TrialNo) = CaSignal.ROIinfo(TrialNo_load);
    nROIs = length(CaSignal.ROIinfo(TrialNo).ROIpos);
    CaSignal.CaTrials(TrialNo).nROIs = nROIs;
    set(handles.nROIsText, 'String', num2str(nROIs));
end

handles = update_image_axes(handles,im);
update_projection_images(handles);
% set(handles.figure1, 'WindowScrollWheelFcn',{@figScroll, handles.figure1, eventdata, handles});
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%% Start of Independent functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = get_exp_info(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs

TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
filename = CaSignal.data_file_names{TrialNo};

if ~isempty(CaSignal.CaTrials(TrialNo).ExpDate)
    ExpDate = CaSignal.CaTrials(TrialNo).ExpDate;
    set(handles.ExpDate, 'String', ExpDate);
else
    CaSignal.CaTrials(TrialNo).ExpDate = get(handles.ExpDate, 'String');
end;


if ~isempty(CaSignal.CaTrials(TrialNo).AnimalName)
    AnimalName = CaSignal.CaTrials(TrialNo).AnimalName;
    set(handles.AnimalNameEdit, 'String', AnimalName);
else
    CaSignal.CaTrials(TrialNo).AnimalName = get(handles.AnimalNameEdit, 'String');
end


if ~isempty(CaSignal.CaTrials(TrialNo).SessionName)
    SessionName = CaSignal.CaTrials(TrialNo).SessionName;
    set(handles.SessionName, 'String', SessionName);
else
    CaSignal.CaTrials(TrialNo).SessionName = get(handles.SessionName, 'String');
end



function handles = update_image_axes(handles,varargin)
% update image display, called by most of call back functions
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String')); 
LUTmin = str2double(get(handles.LUTminEdit,'String'));
LUTmax = str2double(get(handles.LUTmaxEdit,'String'));
sc = [LUTmin LUTmax];
cmap = 'gray';
fr = str2double(get(handles.CurrentFrameNoEdit,'String'));
if fr > CaSignal.nFrames && CaSignal.nFrames > 0
    fr = CaSignal.nFrames;
end
if ~isempty(varargin)
    CaSignal.ImageArray = varargin{1};
end
CaSignal.Scale = sc;
CaSignal.FrameNum = fr;
im = CaSignal.ImageArray;
im_size = size(im);
switch CaSignal.AspectRatio_mode
    case 'Square'
        s1 = im_size(2)/max(im_size(1:2));
        s2 = im_size(1)/max(im_size(1:2));
        asp_ratio = [s1 s2 1]; 
    case 'Image'
        asp_ratio = [1 1 1];
end
axes(handles.Image_disp_axes);
% hold on;
% if (isfield(CaSignal, 'h_img')&& ishandle(CaSignal.h_img))
%     delete(CaSignal.h_img);
% end;
% CaSignal.h_img = imagesc(im(:,:,fr), sc);
CaSignal.h_img = imshow(im(:,:,fr), sc);
set(handles.Image_disp_axes, 'DataAspectRatio', asp_ratio);  %'XTickLabel','','YTickLabel','');
time_str = sprintf('%.3f  sec',CaSignal.CaTrials(1).FrameTime*fr/1000);
set(handles.frame_time_disp, 'String', time_str);
% colormap(gray);
if get(handles.dispModeWithROI,'Value') == 1 && length(CaSignal.ROIinfo) >= TrialNo && ~isempty(CaSignal.ROIinfo(TrialNo).ROIpos)
    update_ROI_plot(handles);
end

% set(handles.figure1, 'WindowScrollWheelFcn',{@figScroll, hObject, eventdata, handles});

guidata(handles.figure1, handles);


function update_ROI_plot(handles)
global CaSignal % ROIinfo ICA_ROIs

CurrentROINo = str2double(get(handles.CurrentROINoEdit,'String'));
TrialNo = str2double(get(handles.CurrentTrialNo,'String')); 

if get(handles.dispModeWithROI,'Value') == 1
    axes(handles.Image_disp_axes);
    % delete existing ROI plots
    if any(ishandle(CaSignal.ROIplot))
        try
            delete(CaSignal.ROIplot(ishandle(CaSignal.ROIplot)));
        end
    end
    CaSignal.ROIplot = plot_ROIs(handles);
end
if isfield(CaSignal.ROIinfo, 'BGpos') && ~isempty(CaSignal.ROIinfo(TrialNo).BGpos)
    BGpos = CaSignal.ROIinfo(TrialNo).BGpos;
    CaSignal.BGplot = line(BGpos(:,1),BGpos(:,2), 'Color', 'b', 'LineWidth', 2);
end
% set(handles.figure1, 'WindowScrollWheelFcn',{@figScroll, handles.figure1, eventdata, handles});
guidata(handles.figure1,handles);

function h_roi_plots = plot_ROIs(handles)
%%
global CaSignal % ROIinfo ICA_ROIs
CurrentROINo = str2double(get(handles.CurrentROINoEdit,'String'));
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
h_roi_plots = [];
roi_pos = {};
%     if get(handles.ICA_ROI_anal, 'Value') == 1 && isfield(ICA_ROIs, 'ROIpos');
%         roi_pos = ICA_ROIs.ROIpos;
%     elseif length(ROIinfo) >= TrialNo && ~isempty(ROIinfo{TrialNo})
%
%         roi_pos = ROIinfo{TrialNo}.ROIpos;
%     end

if length(CaSignal.ROIinfo) >= TrialNo
    roi_pos = CaSignal.ROIinfo(TrialNo).ROIpos;
end
for i = 1:length(roi_pos) % num ROIs
    if i == CurrentROINo
        lw = 2;
        fsize = 18;
    else
        lw = 1;
        fsize = 15;
    end
    if ~isempty(roi_pos{i})
        %             if length(CaSignal.ROIplot)>=i & ~isempty(CaSignal.ROIplot(i))...
        %                     & ishandle(CaSignal.ROIplot(i))
        %                 delete(CaSignal.ROIplot(i));
        %             end
        h_roi_plots(i) = line(roi_pos{i}(:,1),roi_pos{i}(:,2), 'Color', [0.8 0 0], 'LineWidth', lw);
        text(median(roi_pos{i}(:,1)), median(roi_pos{i}(:,2)), num2str(i),'Color',[0 .7 0],'FontSize',fsize);
        set(h_roi_plots(i), 'LineWidth', lw);
    end
end

function handles = update_projection_images(handles)
global CaSignal % ROIinfo ICA_ROIs

if get(handles.dispMeanMode, 'Value')==1
    if ~isfield(CaSignal, 'h_mean_fig') || ~ishandle(CaSignal.h_mean_fig)
        CaSignal.h_mean_fig = figure('Name','Mean Image','Position',[960   500   480   480]);
    else
        figure(CaSignal.h_mean_fig)
    end
    im = CaSignal.ImageArray;
    sc = CaSignal.Scale;
    mean_im = mean(im,3);
    colormap(gray);
    imagesc(mean_im, sc);
    set(gca, 'Position',[0.05 0.05 0.9 0.9], 'Visible','off');
    update_projection_image_ROIs(handles);
end
if get(handles.dispMaxDelta,'Value')==1
    if ~isfield(CaSignal, 'h_maxDelta_fig') || ~ishandle(CaSignal.h_maxDelta_fig)
        CaSignal.h_maxDelta_fig = figure('Name','max Delta Image','Position',[960   40   480   480]);
    else
        figure(CaSignal.h_maxDelta_fig);
    end
    im = CaSignal.ImageArray;
    sc = CaSignal.Scale;
    mean_im = uint16(mean(im,3));
    im = im_mov_avg(im,3);
    max_im = max(im,[],3);
    CaSignal.MaxDelta = max_im - mean_im;
    imagesc(CaSignal.MaxDelta, sc);
    colormap(gray); 
    set(gca, 'Position',[0.05 0.05 0.9 0.9], 'Visible','off');
    
    update_projection_image_ROIs(handles);
end
if get(handles.dispMaxMode,'Value')==1
    if ~isfield(CaSignal, 'h_max_fig') || ~ishandle(CaSignal.h_max_fig)
        CaSignal.h_max_fig = figure('Name','Max Projection Image','Position',[960   180   480   480]);
    else
        figure(CaSignal.h_max_fig)
    end
    im = CaSignal.ImageArray;
    sc = CaSignal.Scale;
    im = im_mov_avg(im,5);
    max_im = max(im,[],3);
    imagesc(max_im, sc);
    colormap(gray); 
    set(gca, 'Position',[0.05 0.05 0.9 0.9], 'Visible','off');
    update_projection_image_ROIs(handles);
end
guidata(handles.figure1,handles);

% update ROI plotting in projecting image figure, called only by updata_projection image
function update_projection_image_ROIs(handles)
% global CaSignal ROIinfo ICA_ROIs
if get(handles.dispModeWithROI,'Value') == 1 
    plot_ROIs(handles);
end

function figScroll(src,evnt, hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
% callback function for mouse scroll
% 
im = CaSignal.ImageArray;
fr = str2double(get(handles.CurrentFrameNoEdit, 'String'));
sc = CaSignal.Scale;
nFrames = CaSignal.nFrames;
% axes(handles.Image_disp_axes);
if evnt.VerticalScrollCount > 0
    if fr < nFrames
        fr = fr + 1;
    end
    
elseif evnt.VerticalScrollCount < 0
    if fr > 1
        fr = fr - 1;
    end  
end

set(handles.FrameSlider,'Value', fr/nFrames);

CaSignal.FrameNum = fr;
set(handles.CurrentFrameNoEdit, 'String', num2str(fr));

CaSignal.h_img = imagesc(im(:,:,fr), sc);
colormap(gray);

handles = update_image_axes(handles);

% Update handles structure
% guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% End of Independent functions %%%%%%%%%%%%%%%%%%%%%%%%%


function dispModeWithROI_Callback(hObject, eventdata, handles)
value = get(handles.dispModeWithROI,'Value');
handles = update_image_axes(handles);
handles = update_projection_images(handles);

function DataPathEdit_Callback(hObject, eventdata, handles)
handles.datapath = get(hObject, 'String');
guidata(hObject, handles);

function DataPathEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ROI_add_Callback(hObject, eventdata, handles)

% global CaSignal % ROIinfo ICA_ROIs
nROIs = str2num(get(handles.nROIsText, 'String'));
nROIs = nROIs + 1;
set(handles.nROIsText, 'String', num2str(nROIs));

CurrentROINo = get(handles.CurrentROINoEdit,'String');
% if strcmp(CurrentROINo, '0')
%     set(handles.CurrentROINoEdit,'String', '1');
% end;
% Use this instead: automatically go to the last ROI added.
set(handles.CurrentROINoEdit,'String', num2str(nROIs));
guidata(hObject, handles);


function ROI_del_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CurrentROINo = str2double(get(handles.CurrentROINoEdit,'String'));
if CurrentROINo > 0
    if length(CaSignal.ROIplot) >= CurrentROINo && ishandle(CaSignal.ROIplot(CurrentROINo))
        try
            delete(CaSignal.ROIplot(CurrentROINo))
            CaSignal.ROIplot(CurrentROINo)=[];
        end
    end
    %     if get(handles.ICA_ROI_anal,'Value') ==1 &&  length(ICA_ROIs.ROIpos) >= CurrentROINo
    %         ICA_ROIs.ROIpos(CurrentROINo) = [];
    %         ICA_ROIs.ROIMask(CurrentROINo) = [];
    %         try
    %         ICA_ROIs.ROIType(CurrentROINo) = [];
    %         end
    %     elseif length(ROIinfo{TrialNo}.ROIpos(CurrentROINo)) >= CurrentROINo
    %         ROIinfo{TrialNo}.ROIpos(CurrentROINo) = [];
    %         ROIinfo{TrialNo}.ROIMask(CurrentROINo) = [];
    %         ROIinfo{TrialNo}.ROIType(CurrentROINo) = [];
    %         CaSignal.CaTrials(TrialNo).nROIs = CaSignal.CaTrials(TrialNo).nROIs - 1;
    %         CaSignal.CaTrials(TrialNo).ROIinfo = ROIinfo{TrialNo};
    %     end
    CaSignal.ROIinfo(TrialNo).ROIpos(CurrentROINo) = [];
    CaSignal.ROIinfo(TrialNo).ROImask(CurrentROINo) = [];
    CaSignal.ROIinfo(TrialNo).ROItype(CurrentROINo) = [];
    CaSignal.CaTrials(TrialNo).nROIs = CaSignal.CaTrials(TrialNo).nROIs - 1;
    CaSignal.CaTrials(TrialNo).ROIinfo = CaSignal.ROIinfo(TrialNo);
    set(handles.nROIsText, 'String', num2str(CaSignal.CaTrials(TrialNo).nROIs));
    set(handles.CurrentROINoEdit,'String', int2str(CurrentROINo - 1));
    % TotROI = get(handles.nROIsText, 'String');
    % if strcmp(TotROI, '0');
    %     set(handles.CurrentROINoEdit,'String', '0');
    % end
    update_ROI_plot(handles);
    update_ROI_numbers(handles);
end
guidata(hObject, handles);



function update_ROI_numbers(handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'string'));
CurrentROINo = str2double(get(handles.CurrentROINoEdit,'String'));
% if get(handles.ICA_ROI_anal,'value') ==1
%     nd = cellfun(@(x) isempty(x), ICA_ROIs.ROIpos);
%     try
%         ICA_ROIs.ROIpos(nd) = [];
%         ICA_ROIs.ROIMask(nd) = [];
%         ICA_ROIs.ROIType(nd) = [];
%     end
%     nROIs = length(ICA_ROIs.ROIpos);
% else
%     for i = 1:length(ROIinfo{TrialNo}.ROIpos)
%         if isempty(ROIinfo{TrialNo}.ROIpos{i})
%             ROIinfo{TrialNo}.ROIpos(i) = [];
%             ROIinfo{TrialNo}.ROIMask(i) = [];
%             ROIinfo{TrialNo}.ROIType(i) = [];
%         end
%     end
%     nROIs = length(ROIinfo{TrialNo}.ROIpos);
% end
for i = 1:length(CaSignal.ROIinfo(TrialNo).ROIpos)
    if isempty(CaSignal.ROIinfo(TrialNo).ROIpos{i})
        CaSignal.ROIinfo(TrialNo).ROIpos(i) = [];
        CaSignal.ROIinfo(TrialNo).ROImask(i) = [];
        CaSignal.ROIinfo(TrialNo).ROItype(i) = [];
    end
end
    nROIs = length(CaSignal.ROIinfo(TrialNo).ROIpos);
set(handles.nROIsText, 'String', num2str(nROIs));
if CurrentROINo > nROIs
    CurrentROINo = nROIs;
elseif CurrentROINo < 1
    CurrentROINo = 1;
end
set(handles.CurrentROINoEdit, 'String', num2str(CurrentROINo));



function ROI_pre_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
% update_ROI_numbers(handles);
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CurrentROINo = str2double(get(handles.CurrentROINoEdit,'String'));
CurrentROINo = CurrentROINo - 1;
if CurrentROINo <= 0
    CurrentROINo = 1;
end;
set(handles.CurrentROINoEdit,'String',int2str(CurrentROINo));

str_menu = get(handles.ROITypeMenu,'String');
ROIType_str = CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo};
if ~isempty(ROIType_str)
    ROIType_num = find(strcmp(ROIType_str, str_menu));
    set(handles.ROITypeMenu,'Value', ROIType_num);
else
    ROIType_str = str_menu{get(handles.ROITypeMenu,'Value')};
    CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo} = ROIType_str;
end
% axes(handles.Image_disp_axes);
update_ROI_plot(handles);
handles = update_projection_images(handles);
guidata(hObject, handles);



function ROI_next_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
% update_ROI_numbers(handles);
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CurrentROINo = str2double(get(handles.CurrentROINoEdit,'String'));
CurrentROINo = CurrentROINo + 1;
if CurrentROINo > str2double(get(handles.nROIsText,'String')) 
    CurrentROINo = str2double(get(handles.nROIsText,'String')) ;
end;
set(handles.CurrentROINoEdit,'String',int2str(CurrentROINo));

str_menu = get(handles.ROITypeMenu,'String');
if length(CaSignal.ROIinfo(TrialNo).ROItype)>= CurrentROINo
    % ~isempty(ROIinfo{TrialNo}.ROIType{CurrentROINo})
    
    ROIType_str = CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo};
    if ~isempty(ROIType_str)
        ROIType_num = find(strcmp(ROIType_str, str_menu));
        set(handles.ROITypeMenu,'Value', ROIType_num);
    else
        ROIType_str = str_menu{get(handles.ROITypeMenu,'Value')};
        CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo} = ROIType_str;
    end
else
    CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo} = str_menu{get(handles.ROITypeMenu,'Value')};
end
update_ROI_plot(handles);
handles = update_projection_images(handles);
guidata(hObject, handles);


function ROI_del_all_Callback(hObject, eventdata, handles)


function CurrentROINoEdit_Callback(hObject, eventdata, handles)
global CaSignal
CurrentTrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CurrentROINo = str2num(get(handles.CurrentROINoEdit,'String'));
if get(handles.Go_to_ROI_def_trial_check_button, 'Value') == 1
    % Load the trial where the current ROI was defined.
    ROI_def_trialNo = CaSignal.ROIinfo(CurrentTrialNo).ROI_def_trialNo(CurrentROINo);
    filename = CaSignal.data_file_names{ROI_def_trialNo};
    if exist(filename,'file')
        open_image_file_button_Callback(hObject, eventdata, handles, filename);
    end
end
update_ROI_plot(handles);
guidata(hObject, handles);


function CurrentROINoEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Go_to_ROI_def_trial_check_button_Callback(hObject, eventdata, handles)
CurrentROINoEdit_Callback(hObject, eventdata, handles);

function Set_ROI_button_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CurrentROINo = str2double(get(handles.CurrentROINoEdit, 'String'));
str_menu = get(handles.ROITypeMenu,'String');
ROIType = str_menu{get(handles.ROITypeMenu,'Value')};
% ROI_updated_flag = 0; % to determine if update the trial No of ROI updating.
%% Draw an ROI after mouse press
waitforbuttonpress;
% define the way of drawing, freehand or ploygon
if get(handles.ROI_draw_freehand, 'Value') == 1
    draw = @imfreehand;
elseif get(handles.ROI_draw_poly, 'Value') == 1;
    draw = @impoly;
end
h_roi = feval(draw);
finish_drawing = 0;
while finish_drawing == 0
    choice = questdlg('confirm ROI drawing?','confirm ROI', 'Yes', 'Re-draw', 'Cancel','Yes');
    switch choice
        case'Yes',
            pos = h_roi.getPosition;
            line(pos(:,1), pos(:,2),'color','g')
            BW = createMask(h_roi);
            delete(h_roi);
            finish_drawing = 1;
%             ROI_updated_flag = 1;
        case'Re-draw'
            delete(h_roi);
            h_roi = feval(draw); finish_drawing = 0;
        case'Cancel',
            delete(h_roi); finish_drawing = 1;
%             ROI_updated_flag = 0;
            return
    end
end

CaSignal.ROIinfo(TrialNo).ROIpos{CurrentROINo} = pos;
CaSignal.ROIinfo(TrialNo).ROImask{CurrentROINo} = BW;
CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo} = ROIType;
CaSignal.ROIinfo(TrialNo).ROI_def_trialNo(CurrentROINo) = TrialNo;
CaSignal.CaTrials(TrialNo).nROIs = length(CaSignal.ROIinfo(TrialNo).ROIpos);

set(handles.import_ROIinfo_from_trial, 'String', num2str(TrialNo));
% 
% if get(handles.ICA_ROI_anal,'Value') == 1
%     CaSignal.ROIinfo(TrialNo).Method = 'ICA';
%     CaSignal.rois_by_IC{CaSignal.currentIC} = [CaSignal.rois_by_IC{CaSignal.currentIC}  CurrentROINo];
%     for jj = 1:length(CaSignal.ICA_figs)
%         if ishandle(CaSignal.ICA_figs(jj))
%             figure(CaSignal.ICA_figs(jj)),
%             plot_ROIs(handles);
%         end
%     end
% else
%     
% end
set(handles.nROIsText,'String', num2str(length(CaSignal.ROIinfo(TrialNo).ROIpos)));
axes(handles.Image_disp_axes);
if length(CaSignal.ROIplot) >= CurrentROINo
    if ishandle(CaSignal.ROIplot(CurrentROINo)) && CaSignal.ROIplot(CurrentROINo) > 0
        delete(CaSignal.ROIplot(CurrentROINo));
    else
        CaSignal.ROIplot(CurrentROINo) = [];
    end
end
guidata(hObject, handles);
%CaSignal.roi_line(CurrentROINo) = line(pos(:,1),pos(:,2), 'Color', 'r', 'LineWidth', 2);
update_ROI_plot(handles);
update_projection_images(handles);
ROITypeMenu_Callback(hObject, eventdata, handles);
guidata(hObject, handles);



% function ROI_Edit_button_Callback(hObject, eventdata, handles)
% global CaSignal % ROIinfo ICA_ROIs
% TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
% CurrentROINo = str2double(get(handles.CurrentROINoEdit, 'String'));
% pos = CaSignal.ROIinfo(TrialNo).ROIpos{CurrentROINo};
% h_axes = handles.Image_disp_axes;
% 
% if get(hObject, 'Value')==1
%     CaSignal.current_poly_obj = impoly(h_axes, pos);
% elseif get(hObject, 'Value')== 0 
%     if isa(CaSignal.current_poly_obj, 'imroi')
%         pos = getPosition(CaSignal.current_poly_obj);
%         BW = createMask(CaSignal.current_poly_obj);
%         CaSignal.ROIinfo(TrialNo).ROIpos{CurrentROINo} = pos;
%         CaSignal.ROIinfo(TrialNo).ROImask{CurrentROINo} = BW;
%         axes(h_axes);
%         delete(CaSignal.current_poly_obj); % delete polygon object
%         if ishandle(CaSignal.ROIplot(CurrentROINo))
%             delete(CaSignal.ROIplot(CurrentROINo));
%         end
%         CaSignal.ROIplot(CurrentROINo) = [];
%         % CaSignal.roi_line(CurrentROINo) = line(pos(:,1),pos(:,2), 'Color', 'r', 'LineWidth', 2);
%          update_ROI_plot(handles);
%          handles = update_projection_images(handles);
%     end;
% end;
% guidata(hObject, handles);

% --- Executes on button press in import_ROIinfo_from_file.
function import_ROIinfo_from_file_Callback(hObject, eventdata, handles)

choice = questdlg('Import ROIinfo from different file/session?', 'Import ROIs', 'Yes','No','No');
switch choice
    case 'Yes'
        [fn, pth] = uigetfile('*.mat');
        r = load([pth filesep fn]);
        ROIinfo = r.ROIinfo(1);
    case 'No'
        return
end
import_ROIinfo(ROIinfo, handles);


function import_ROIinfo_from_trial_Callback(hObject, eventdata, handles)
% get ROIinfo from the specified trial, and call import_ROIinfo function
global CaSignal
% The trialNo to load ROIinfo from
TrialNo_load = str2double(get(handles.import_ROIinfo_from_trial,'String'));
if ~isempty(CaSignal.ROIinfo)
    ROIinfo = CaSignal.ROIinfo(TrialNo_load);
    import_ROIinfo(ROIinfo, handles);% getROIinfoButton_Callback(hObject, eventdata, handles)
else
    warning('No ROIs specified!');
end

function import_ROIinfo(ROIinfo, handles)
% update the ROIs of the current trial with the input "ROIinfo".
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));

FileName_prefix = CaSignal.CaTrials(TrialNo).FileName_prefix;

CaSignal.ROIinfo(TrialNo) = ROIinfo;
% elseif exist(['ROIinfo_' FileName_prefix '.mat'],'file')
%     load([FileName_prefix 'ROIinfo.mat'], '-mat');
%     if length(CaSignal.ROIinfo)>= TrialNo_load
%         CaSignal.ROIinfo(TrialNo) = CaSignal.ROIinfo{TrialNo_load};
%     end
nROIs = length(CaSignal.ROIinfo(TrialNo).ROIpos);
CaSignal.CaTrials(TrialNo).nROIs = nROIs;
set(handles.nROIsText, 'String', num2str(nROIs));
update_ROI_plot(handles);
handles = update_projection_images(handles);



function import_ROIinfo_from_trial_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ROITypeMenu_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CurrentROINo = str2double(get(handles.CurrentROINoEdit, 'String'));
Menu = get(handles.ROITypeMenu,'String');
% CaSignal.CaTrials(TrialNo).ROIType{CurrentROINo} = Menu{get(handles.ROITypeMenu,'Value')};
CaSignal.ROIinfo(TrialNo).ROItype{CurrentROINo} = Menu{get(handles.ROITypeMenu,'Value')};
guidata(hObject, handles);

function CalculatePlotButton_Callback(hObject, eventdata, handles, im, plot_flag)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
% ROIMask = CaSignal.CaTrials(TrialNo).ROIMask;
% if get(handles.ICA_ROI_anal, 'Value') == 1
%     nROI_effective = length(ICA_ROIs.ROIMask);
%     ROImask = ICA_ROIs.ROIMask;
% else
%     nROI_effective = length(CaSignal.ROIinfo(TrialNo).ROIpos);
%     ROImask = CaSignal.ROIinfo(TrialNo).ROIMask;
% end
nROI_effective = length(CaSignal.ROIinfo(TrialNo).ROIpos);
ROImask = CaSignal.ROIinfo(TrialNo).ROImask;
if nargin < 4
    im = CaSignal.ImageArray;
end    
if nargin < 5 %~exist('plot_flag','var')
    plot_flag = 1;
end
if ~isempty(CaSignal.ROIinfo(TrialNo).BGmask)
    BGmask = repmat(CaSignal.ROIinfo(TrialNo).BGmask,[1 1 size(im,3)]) ;
    BG_img = BGmask.*double(im);
    BG_img(BG_img==0) = NaN;
    BG = reshape(nanmean(nanmean(BG_img)),1,[]); % 1-by-nFrames array
else
    BG = 0;
end;

F = zeros(nROI_effective, size(im,3));
dff = zeros(size(F));

for i = 1: nROI_effective
    mask = repmat(ROImask{i}, [1 1 size(im,3)]); % reproduce masks for every frame
    % Using indexing and reshape function to increase speed
    nPix = sum(sum(ROImask{i}));
    % Using reshape to partition into different trials.
    roi_img = reshape(im(mask), nPix, []);
    % Raw intensity averaged from pixels of the ROI in each trial.
    if nPix == 0
        F(i,:) = 0;
    else
        F(i,:) = mean(roi_img, 1);
    end
%%%%%%%%%%%%% Obsolete slower method to compute ROI pixel intensity %%%%%%%   
%     roi_img = mask .* double(im);                                       % 
%                                                                         %      
%     roi_img(roi_img<=0) = NaN;                                          %  
%    % F(:,i) = nanmean(nanmean(roi_img));                                %
%     F(i,:) = nanmean(nanmean(roi_img));                                 %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if get(handles.AnalysisModeBGsub,'Value') == 1
        F(i,:) = F(i,:) - BG;
    end;
    if get(handles.AnalysisModeDeltaFF,'Value') == 1
        [N,X] = hist(F(i,:));
        F_mode = X(find(N==max(N)));
        baseline = mean(F_mode);
        dff(i,:) = (F(i,:)- baseline)./baseline*100;
    else
%         CaTrace(i,:) = F(i,:);
    end
end;
CaSignal.CaTrials(TrialNo).dff = dff;
CaSignal.CaTrials(TrialNo).f_raw = F;
ts = (1:CaSignal.CaTrials(TrialNo).nFrames).*CaSignal.CaTrials(TrialNo).FrameTime;
if plot_flag == 1
    if get(handles.check_plotAllROIs, 'Value') == 1
        roiNos = [];
    else
        roiNos = str2num(get(handles.roiNo_to_plot, 'String'));
    end
    CaSignal.h_CaTrace_fig = plot_CaTraces_ROIs(dff, ts, roiNos);
end
guidata(handles.figure1, handles);

function doBatchButton_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
batchPrefix = get(handles.batchPrefixEdit, 'String');
Start_trial = str2double(get(handles.batchStartTrial, 'String'));
End_trial = str2double(get(handles.batchEndTrial,'String'));
% CaSignal.CaTrials = [];
h = waitbar(0, 'Start Batch Analysis ...');
for TrialNo = Start_trial:End_trial
    fname = CaSignal.data_file_names{TrialNo};
    if ~exist(fname,'file')
        [fname, pathname] = uigetfile('*.tif', 'Select Image Data file');
        cd(pathname);
    end;
    msg_str1 = sprintf('Batch analyzing %d of total %d trials with %d ROIs...', ...
        TrialNo, End_trial-Start_trial+1, CaSignal.CaTrials(1).nROIs);  
%     disp(['Batch analyzing ' num2str(TrialNo) ' of total ' num2str(End_trial-Start_trial+1) ' trials...']);
    disp(msg_str1);
    waitbar((TrialNo-Start_trial+1)/(End_trial-Start_trial+1), h, msg_str1);
    set(handles.msgBox, 'String', msg_str1);
    [im, header] = load_scim_data(fname);
    if (length(CaSignal.CaTrials)<TrialNo || isempty(CaSignal.CaTrials(TrialNo).FileName))
        trial_init = init_CaTrial(fname,TrialNo,header);
        CaSignal.CaTrials(TrialNo) = trial_init;
    end
    set(handles.CurrentTrialNo,'String', int2str(TrialNo));
    % if isempty(ROIinfo{TrialNo})
    %###########################################################################
    % Make sure the ROIinfo of the first trial of the batch is up to date
    if TrialNo > Start_trial && ~isempty(CaSignal.ROIinfo(TrialNo-1).ROIpos)
        CaSignal.ROIinfo(TrialNo) = CaSignal.ROIinfo(TrialNo-1);
        CaSignal.CaTrials(TrialNo).nROIs = CaSignal.CaTrials(TrialNo-1).nROIs;
    end
    %##########################################################################
    % end
%     update_image_axes(handles,im);
    CalculatePlotButton_Callback(handles.figure1, eventdata, handles, im, 0);
%     handles = update_projection_images(handles);
    handles = get_exp_info(hObject, eventdata, handles);
%     CaSignal.CaTrials(TrialNo).meanImage = mean(im,3);
%     close(CaSignal.h_CaTrace_fig);
    set(handles.CurrentTrialNo, 'String', int2str(TrialNo));
    set(handles.CurrentImageFilenameText,'String',fname);
%     set(handles.nROIsText,'String',int2str(length(ROIinfo{TrialNo}.ROIpos)));
    guidata(hObject, handles);
end

SaveResultsButton_Callback(hObject, eventdata, handles);
close(h);
disp(['Batch analysis completed for ' CaSignal.CaTrials(1).FileName_prefix]);
set(handles.msgBox, 'String', ['Batch analysis completed for ' CaSignal.CaTrials(1).FileName_prefix]);

function SaveResultsButton_Callback(hObject, eventdata, handles)
%% Save Results
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
FileName_prefix = CaSignal.CaTrials(TrialNo).FileName_prefix;
% CaSignal.CaTrials = CaSignal.CaTrials;
% ROIinfo = ROIinfo;

% Now we are in data file path. Since analysis results are saved in a separate
% folder, we need to find that folder in order to laod or save analysis
% results. If that folder does not exist, a new folder will be created.

% CaSignal.results_path = strrep(datapath,[filesep 'data'],[filesep 'results']);
if isempty(CaSignal.results_path) || ~exist(CaSignal.results_path,'dir')
    CaSignal.results_path = uigetdir([CaSignal.data_path filesep 'Analysis_Results']);
end

% 
% mkdir(CaSignal.results_path);
% disp('results dir not exists! A new folder created:');
% disp(CaSignal.results_path);

CaSignal.results_fname = [CaSignal.results_path filesep 'CaTrials_' FileName_prefix '.mat'];
CaSignal.ROIinfo_fname = [CaSignal.results_path filesep 'ROIinfo_', FileName_prefix '.mat'];   

% [fname, pathname, ~] = uigetfile('*.mat', 'Saving Results To ...', CaSignal.results_fname);
% CaSignal.results_fname = fname;

ROIinfo = CaSignal.ROIinfo;
for i = 1:length(CaSignal.CaTrials)
    if length(CaSignal.ROIinfo) >= i
        CaSignal.CaTrials(i).ROIinfo = CaSignal.ROIinfo(i);
    end
end
CaTrials = CaSignal.CaTrials;
% save(CaSignal.results_fname, 'CaTrials','ICA_results');
save(CaSignal.results_fname, 'CaTrials');
save(CaSignal.ROIinfo_fname, 'ROIinfo');
% save(fullfile(CaSignal.results_path, ['ICA_ROIs_', FileName_prefix '.mat']), 'ICA_ROIs');
msg_str = sprintf('CaTrials Saved, with %d trials, %d ROIs', length(CaSignal.CaTrials), CaSignal.CaTrials(TrialNo).nROIs);
disp(msg_str);
set(handles.msgBox, 'String', msg_str);
save_gui_info(handles);

function batchStartTrial_Callback(hObject, eventdata, handles)

function batchStartTrial_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function batchEndTrial_Callback(hObject, eventdata, handles)

function batchEndTrial_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dispModeGreen_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
if CaSignal.CaTrials(TrialNo).DaqInfo.acq.numberOfChannelsAcquire == 1
    set(hObject,'Value',1);
end;

function dispModeImageInfoButton_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
if get(hObject, 'Value') == 1
    CaSignal.h_info_fig = figure; set(gca, 'Visible', 'off');
    f_pos = get(CaSignal.h_info_fig, 'Position'); f_pos(3) = f_pos(3)/2;
    set(CaSignal.h_info_fig, 'Position', f_pos);
    info_disp = CaSignal.info_disp;
    for i = 1: length(info_disp),
        x = 0.01;
        y=1-i/length(info_disp);
        text(x,y,info_disp{i},'Interpreter','none');
    end
    guidata(hObject, handles);
else
    close(CaSignal.h_info_fig);
end


function nROIsText_CreateFcn(hObject, eventdata, handles)

function figure1_DeleteFcn(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
save_gui_info(handles);
clear CaSignal % ROIinfo ICA_ROIs
% close all;

function CurrentTrialNo_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
% To record the Current loaded trial number. Use this number to come back
% one step.
CaSignal.Last_TrialNo = CaSignal.CurrentTrialNo;
CaSignal.CurrentTrialNo = str2double(get(handles.CurrentTrialNo,'String'));

TrialNo = CaSignal.CurrentTrialNo;
if TrialNo>0
    filename = CaSignal.data_file_names{TrialNo};
    if exist(filename,'file')
        open_image_file_button_Callback(hObject, eventdata, handles,filename);
    end
end

function PrevTrialButton_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
CaSignal.Last_TrialNo = CaSignal.CurrentTrialNo;
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
if TrialNo>1
    filename = CaSignal.data_file_names{TrialNo-1};
    if exist(filename,'file')
        open_image_file_button_Callback(hObject, eventdata, handles,filename);
    end
end

function NextTrialButton_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
CaSignal.Last_TrialNo = CaSignal.CurrentTrialNo;
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
if  TrialNo+1 <= length(CaSignal.data_file_names) % exist(filename,'file')
    filename = CaSignal.data_file_names{TrialNo+1};
    open_image_file_button_Callback(hObject, eventdata, handles,filename);
end

function go_to_last_trial_button_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
LastTrialNo = CaSignal.Last_TrialNo;
if  LastTrialNo > 0 % exist(filename,'file')
    filename = CaSignal.data_file_names{LastTrialNo};
    open_image_file_button_Callback(hObject, eventdata, handles,filename);
end


function AnalysisModeBGsub_Callback(hObject, eventdata, handles)

function batchPrefixEdit_Callback(hObject, eventdata, handles)

function batchPrefixEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AnimalNameEdit_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CaSignal.CaTrials(TrialNo).AnimalName = get(hObject, 'String');
guidata(hObject, handles);
save_gui_info(handles);

function AnimalNameEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ExpDate_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CaSignal.CaTrials(TrialNo).ExpDate = get(hObject, 'String');
guidata(hObject, handles);
save_gui_info(handles);

function ExpDate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SessionName_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
CaSignal.CaTrials(TrialNo).SessionName = get(hObject, 'String');
guidata(hObject, handles);
save_gui_info(handles);

function SessionName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FrameSlider_Callback(hObject, eventdata, handles, varargin)
global CaSignal % ROIinfo ICA_ROIs
nFrames = CaSignal.nFrames;

if ~isempty(varargin)
    new_frameNum = varargin{1};
    if new_frameNum == 0, new_frameNum = 1; end;
    if new_frameNum > nFrames, new_frameNum = nFrames; end
    slider_value = new_frameNum/nFrames;
    set(hObject, 'Value', slider_value)
else
    slider_value = get(hObject,'Value');
    new_frameNum = ceil(nFrames*slider_value);
    if new_frameNum == 0, new_frameNum = 1; end;
end
set(handles.CurrentFrameNoEdit, 'String', num2str(new_frameNum));
handles = update_image_axes(handles);
guidata(hObject, handles);

% h_main_figure = gcf;
% ch = getkey2(h_main_figure);
% if ismember(ch, [28 29])
%     old_frameNum = str2num(get(handles.CurrentFrameNoEdit, 'String'));
% %     ch = getkey2(hf);
%     if ch == 29
%         new_frameNum = old_frameNum + 1;
%     elseif ch == 28
%         new_frameNum = old_frameNum - 1;
%     end
% %     disp(new_frameNum);
%     FrameSlider_Callback(hObject, eventdata, handles, new_frameNum)
%  end


function FrameSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function CurrentFrameNoEdit_Callback(hObject, eventdata, handles)

handles = update_image_axes(handles);

function CurrentFrameNoEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LUTminEdit_Callback(hObject, eventdata, handles)

update_image_axes(handles);
update_projection_images(handles);

function LUTminEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LUTmaxEdit_Callback(hObject, eventdata, handles)

update_image_axes(handles);
update_projection_images(handles);


function LUTmaxEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LUTminSlider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value_min = get(hObject,'Value');
value_max = get(handles.LUTmaxSlider,'Value');
if value_min >= value_max
    value_min = value_max - 0.01;
    set(hObject, 'Value', value_min);
end;
set(handles.LUTminEdit, 'String', num2str(value_min*1000));
update_image_axes(handles);
update_projection_images(handles);
% guidata(hObject, handles);


function LUTminSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function LUTmaxSlider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value_max = get(hObject,'Value');
value_min = get(handles.LUTminSlider, 'Value');
if value_max <= value_min
    value_max = value_min + 0.01;
    set(hObject, 'Value', value_max);
end;
set(handles.LUTmaxEdit, 'String', num2str(value_max*1000));
update_image_axes(handles);
update_projection_images(handles);
% guidata(hObject, handles);


function dispMeanMode_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
if get(hObject, 'Value')==1
    handles = update_projection_images(handles);
else
    try
        if ishandle(CaSignal.h_mean_fig)
            delete(CaSignal.h_mean_fig);
        end;
    catch ME
    end
end
guidata(hObject, handles);


function dispMaxDelta_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
if get(hObject, 'Value')==1
    handles = update_projection_images(handles);
else
    try
        if ishandle(CaSignal.h_maxDelta_fig)
            delete(CaSignal.h_maxDelta_fig);
        end;
    catch ME
    end
end
guidata(hObject, handles);

function dispMaxMode_Callback(hObject, eventdata, handles)
if get(hObject, 'Value')==1
    handles = update_projection_images(handles);
else
    try
        if ishandle(CaSignal.h_max_fig)
            delete(CaSignal.h_max_fig);
        end;
    catch ME
    end
end
guidata(hObject, handles);

function ROITypeMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dispModeGreen_CreateFcn(hObject, eventdata, handles)

function LUTmaxSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in SaveFrameButton.
function SaveFrameButton_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
im = CaSignal.ImageArray;
fr = str2double(get(handles.CurrentFrameNoEdit,'String'));
dataFileName = get(handles.CurrentImageFilenameText, 'String');

[fname, pathName] = uiputfile([dataFileName(1:end-4) '_' int2str(fr) '.tif'], 'Save the current frame as');
if ~isequal(fname, 0)&& ~isequal(pathName, 0)
    imwrite(im(:,:,fr), [pathName fname], 'tif','WriteMode','overwrite','Compression','none');
end


% --- Executes on button press in setTargetForTrial.
function setTargetForTrial_Callback(hObject, eventdata, handles)



% --- Executes on button press in setTargetForSession.
function setTargetForSession_Callback(hObject, eventdata, handles)
% hObject    handle to setTargetForSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setTargetForSession


% --- Executes on button press in setTargetCurrentFrame.
function setTargetCurrentFrame_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2num(get(handles.CurrentTrialNo, 'String'));
if get(hObject,'Value') == 1
    fr = str2num(get(handles.CurrentFrameNoEdit, 'String'));
    CaSignal.RegTarget = CaSignal.ImageArray(:,:,fr);
    CaSignal.CaTrials(TrialNo).RegTargetFrNo = fr;
    set(handles.setTargetMean, 'Value', 0);
    set(handles.setTargetMaxDelta, 'Value', 0);
end
guidata(hObject, handles);


% --- Executes on button press in setTargetMean.
function setTargetMean_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
if get(hObject,'Value') == 1
    CaSignal.RegTarget = uint16(mean(CaSignal.ImageArray,3));
    set(handles.setTargetCurrentFrame, 'Value', 0);
    set(handles.setTargetMaxDelta, 'Value', 0);
end
guidata(hObject, handles);

% --- Executes on button press in setTargetMaxDelta.
function setTargetMaxDelta_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
if get(hObject,'Value') == 1
    if isfield(CaSignal, 'MaxDelta')&& ~isempty(CaSignal.MaxDelta)
        CaSignal.RegTarget = CaSignal.MaxDelta;
    else
        im = CaSignal.ImageArray;
        mean_im = uint16(mean(im,3));
        im = im_mov_avg(im,5);
        max_im = max(im,[],3);
        CaSignal.RegTarget = max_im - mean_im;
        set(handles.setTargetCurrentFrame, 'Value', 0);
        set(handles.setTargetMean, 'Value', 0);
    end 
end
guidata(hObject, handles);

% --- Executes on button press in RegCurrentTrial.
function RegCurrentTrial_Callback(hObject, eventdata, handles)
% Motion correction by for the current trial
% setTargetCurrentFrame_Callback(hObject, eventdata, handles);
% setTargetMaxDelta_Callback(hObject, eventdata, handles);
% setTargetMean_Callback(hObject, eventdata, handles);
global CaSignal%  ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
RegMethod_id = get(handles.RegMethodMenu,'Value');
RegMethod_string = get(handles.RegMethodMenu,'String');
switch get(handles.RegMethodMenu,'Value')
    case 2 % 'TurboReg'
        ImageReg = Turboreg_nx3(CaSignal.RegTarget, CaSignal.ImageArray,'translation',0);
    case {3 4} % 'dft_Reg'
        tg_img = CaSignal.RegTarget;
        src_img = CaSignal.ImageArray;
        for i=1:size(src_img,3);
            output(:,i) = dftregistration(fft2(double(tg_img)),fft2(double(src_img(:,:,i))),1);
        end
        shift = output(3:4,:);
%         if size(src_img,1) > CaSignal.CaTrials(TrialNo).DaqInfo.acq.linesPerFrame
%             % if the source image is already padded image from the original
%             % data, then do not padding
%             padding = [0 0 0 0];
%         else
%             % Otherwise, pad the image matrix according to the shift pixels
%             padding = [];
%         end
        padding = [0 0 0 0];
        ImageReg = ImageTranslation_nx(src_img,shift,padding,0);
        figure('Name','Image shiftings');
        dist_shifted = sqrt(shift(1,:).^2 + shift(2,:).^2);
        plot(dist_shifted);
        xlabel('# Frame'); ylabel('Shift Distance');
        disp(['mean shifting for all frames: ' num2str(mean(dist_shifted))]);
end;
disp(['Completed registration of the current trial using ' RegMethod_string{RegMethod_id}]);
CaSignal.ImageArray = ImageReg;
handles = update_image_axes(handles);
guidata(hObject,handles)

% --- Executes on button press in RegCurrentSession.
function RegCurrentSession_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
% setTargetCurrentFrame_Callback(hObject, eventdata, handles);
% setTargetMaxDelta_Callback(hObject, eventdata, handles);
% setTargetMean_Callback(hObject, eventdata, handles);
filename_base = get(handles.batchPrefixEdit, 'String');
targetImage = CaSignal.RegTarget;
sorce_filenames = CaSignal.data_file_names;
ref_trial_num = str2num(get(handles.CurrentTrialNo, 'String'));
shift = [];
switch get(handles.RegMethodMenu,'Value')
    case 2 % 'TurboReg'
        for i = 1:length(CaSignal.data_file_names)
            disp(['Registering data file: ' sorce_filenames{i} ' ...']);
            Turboreg_nx3(targetImage, sorce_filenames{i}, 'translation',1);
        end
        save(['dft_reg\' filename_base '[dftShift].mat'], 'shift','ref_trial_num');
    case 3 % 'dft_Reg'
        shift = batch_dft_reg(targetImage, sorce_filenames, 0);
        % save reg info
        save(['dft_reg\' filename_base '[dftShift].mat'], 'shift','ref_trial_num');
    case 4 % 'dft_Reg_padded', padding the orignal image to accomadate the maximum pixel shifts accross trials
        shift = batch_dft_reg(targetImage, sorce_filenames, 1);
end;
CaSignal.dftreg_shift = shift;
guidata(hObject,handles);

% --- Executes on button press in SaveRegImage.
function SaveRegImage_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
im = CaSignal.ImageArray;
currentFileName = get(handles.CurrentImageFilenameText, 'String');
im_describ = CaSignal.ImageDescription;
% if the current file is not the original data, then overwrite it,
% otherwise create another file for the registered image
switch get(handles.RegMethodMenu,'Value')
    case 2 % 'TurboReg'
        if isempty(findstr(pwd, 'turboreg'))
            saveName = [currentFileName(1:end-7) 'reg_' currentFileName(end-6:end)];
            savePath = [pwd filesep 'turboreg_corrected'];
        else
            saveName = currentFileName;
            savePath = pwd;
        end;
    case {3, 4}% 'dft_Reg'
        if isempty(findstr(pwd, 'dft_reg'))
            savePath = [pwd filesep 'dft_reg'];
            saveName = [currentFileName(1:end-7) '_dftReg_' currentFileName(end-6:end-4) '.tif'];
        else
            saveName = currentFileName;
            savePath = pwd;
        end
end
if ~exist(savePath, 'dir')
    mkdir(savePath);
end
for i = 1:size(im,3)
    if i == 1,
        imwrite(im(:,:,i),[savePath filesep saveName],'tif','Compression','none','Description',im_describ,'WriteMode','overwrite');
    else
        imwrite(im(:,:,i),[savePath filesep saveName],'tif','Compression','none','WriteMode','append');
    end
end
disp(['Registered image saved as ' saveName]);
set(handles.msgBox, 'String', ['Registered image saved as ' saveName]);


% --- Executes on button press in BG_poly_set.
function BG_poly_set_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
%    if isempty(CaSignal.CaTrials(TrialNo).BGmask)
waitforbuttonpress;
[BW,xi,yi] = roipoly;
CaSignal.ROIinfo(TrialNo).BGmask = BW;
CaSignal.ROIinfo(TrialNo).BGpos = [xi yi];
% axes(CaSignal.image_disp_gui.Image_disp_axes);
% if isfield(CaSignal, 'BGplot')&& ishandle(CaSignal.BGplot)
%     delete(CaSignal.BGplot);
% end
% CaSignal.BGplot = line(xi, yi, 'Color','b', 'LineWidth',2);
update_ROI_plot(handles);       
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalysisModeBGsub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalysisModeBGsub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in RegMethodMenu.
function RegMethodMenu_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function RegMethodMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegMethodMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MotionEstmOptions.
function MotionEstmOptions_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns MotionEstmOptions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MotionEstmOptions
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
switch get(hObject,'Value')
    case 2 % plot cross correlation coef for the current trial
        img = CaSignal.ImageArray;
        xcoef = xcoef_img(img);
        figure('Name', ['xCorr. Coefficient for Trial ' num2str(TrialNo)], 'Position', [1200 300 480 300]);
        plot(xcoef); xlabel('Frame #'); ylabel('Corr. Coeff');
        disp(sprintf(['mean xCorr. Coefficient for trial ' num2str(TrialNo) ': %g'],mean(xcoef)));
    case 3 % Compute cross correlation across all trials
        n_trials = length(CaSignal.data_file_names);
        if isempty(CaSignal.avgCorrCoef_trials)
            xcoef_trials = zeros(n_trials,1);
            h_wait = waitbar(0, 'Calculating cross correlation coefficients for trial 0 ...');
            for i = 1:n_trials
                waitbar(i/n_trials, h_wait, ['Calculating cross correlation coefficients for trial ' num2str(i)]);
                img = load_scim_data(CaSignal.data_file_names{i}); 
                xcoef = xcoef_img(img);
                xcoef_trials(i) = mean(xcoef);
            end
            close(h_wait);
            CaSignal.avgCorrCoef_trials = xcoef_trials;
        else
            xcoef_trials = CaSignal.avgCorrCoef_trials;
        end
        figure('Name', 'xCorr. Coef across all trials', 'Position', [1200 300 480 300]);
        plot(xcoef_trials); xlabel('Trial #'); ylabel('mean Corr. Coeff');
    case 4
        
    case 5
        if ~isempty(CaSignal.dftreg_shift)
            for i = 1:str2num(get(handles.TotTrialNum, 'String'))
                avg_shifts(i) = max(mean(abs(CaSignal.dftreg_shift(:,:,i)),2));
            end
            figure;
            plot(avg_shifts,'LineWidth',2); 
            title('Motion estimation of all trials','FontSize',18);
            xlabel('Trial #', 'FontSize', 15); ylabel('Mean shift of all frames', 'FontSize', 15);
        end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function MotionEstmOptions_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function save_gui_info(handles)
% global CaSignal ROIinfo ICA_ROIs
info.DataPath = pwd;
info.AnimalName = get(handles.AnimalNameEdit,'String');
info.ExpDate = get(handles.ExpDate,'String');
info.SessionName = get(handles.SessionName, 'String');
info.SoloDataPath = get(handles.SoloDataPath, 'String');
info.SoloDataFileName = get(handles.SoloDataFileName, 'String');
info.SoloSessionName = get(handles.SoloSessionName, 'String');
info.SoloStartTrialNo = get(handles.SoloStartTrialNo, 'String');
info.SoloEndTrialNo = get(handles.SoloEndTrialNo, 'String');

usrpth = userpath; % usrpth = usrpth(1:end-1);
if strcmp(usrpth(end), ':'), usrpth(end) = []; end
save([usrpth filesep 'nx_CaSingal.info'], 'info');



function SoloStartTrialNo_Callback(hObject, eventdata, handles)
%

% --- Executes during object creation, after setting all properties.
function SoloStartTrialNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solostarttrialno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SoloEndTrialNo_Callback(hObject, eventdata, handles)
%

% --- Executes during object creation, after setting all properties.
function SoloEndTrialNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soloendtrialno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SoloDataPath_Callback(hObject, eventdata, handles)
%

% --- Executes during object creation, after setting all properties.
function SoloDataPath_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SoloDataFileName_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SoloDataFileName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addBehavTrials.
function addBehavTrials_Callback(hObject, eventdata, handles)
global CaSignal %  ROIinfo ICA_ROIs

Solopath = get(handles.SoloDataPath,'String');
mouseName = get(handles.AnimalNameEdit, 'String');
sessionName = get(handles.SoloSessionName, 'String');
trialStartEnd(1) = str2num(get(handles.SoloStartTrialNo, 'String'));
trialStartEnd(2) = str2num(get(handles.SoloEndTrialNo, 'String'));
trailsToBeExcluded = str2num(get(handles.behavTrialNoToBeExcluded, 'String'));

[Solo_data, SoloFileName] = Solo.load_data_nx(mouseName, sessionName,trialStartEnd,Solopath);
set(handles.SoloDataFileName, 'String', SoloFileName);
behavTrialNums = trialStartEnd(1):trialStartEnd(2);
behavTrialNums(trailsToBeExcluded) = [];

if length(behavTrialNums) ~= str2num(get(handles.TotTrialNum, 'String'))
    error('Number of behavior trials NOT equal to Number of Ca Image Trials!')
end

for i = 1:length(behavTrialNums)
    behavTrials(i) = Solo.BehavTrial_nx(Solo_data,behavTrialNums(i),1);
    CaSignal.CaTrials(i).behavTrial = behavTrials(i);
end
disp([num2str(i) ' Behavior Trials added to CaSignal.CaTrials']);
set(handles.msgBox, 'String', [num2str(i) ' Behavior Trials added to CaSignal.CaTrials']);
guidata(hObject, handles)


function SoloSessionName_Callback(hObject, eventdata, handles)

Solopath = get(handles.SoloDataPath,'String');
mouseName = get(handles.AnimalNameEdit, 'String');
sessionName = get(handles.SoloSessionName, 'String');
trialStartEnd(1) = str2num(get(handles.SoloStartTrialNo, 'String'));
trialStartEnd(2) = str2num(get(handles.SoloEndTrialNo, 'String'));

[Solo_data, SoloFileName] = Solo.load_data_nx(mouseName, sessionName,trialStartEnd,Solopath);
set(handles.SoloDataFileName, 'String', SoloFileName);


% --- Executes during object creation, after setting all properties.
function SoloSessionName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dispModeImageInfoButton_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in ROI_move_left.
function ROI_move_left_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
imsize = size(CaSignal.ImageArray);
aspect_ratio = imsize(2)/imsize(1);
move_unit = 1* max(aspect_ratio,1);
if get(handles.ROI_move_all_check, 'Value') == 1
    roi_num_to_move = 1: length(CaSignal.ROIinfo(TrialNo).ROIpos);
else
    roi_num_to_move = str2num(get(handles.CurrentROINoEdit,'String'));
end
for i = roi_num_to_move
    CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1) = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1)-move_unit;
    x = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1);
    y = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2);
    CaSignal.ROIinfo(TrialNo).ROImask{i} = poly2mask(x,y,imsize(1),imsize(2));
end;
update_ROI_plot(handles);
handles = update_projection_images(handles);
guidata(hObject, handles);


% --- Executes on button press in ROI_move_right.
function ROI_move_right_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs

TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
imsize = size(CaSignal.ImageArray);
aspect_ratio = imsize(2)/imsize(1);
move_unit = 1* max(aspect_ratio,1);
if get(handles.ROI_move_all_check, 'Value') == 1
    roi_num_to_move = 1: length(CaSignal.ROIinfo(TrialNo).ROIpos);
else
    roi_num_to_move = str2num(get(handles.CurrentROINoEdit,'String'));
end
for i = roi_num_to_move
    CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1) = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1)+move_unit;
    x = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1);
    y = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2);
    CaSignal.ROIinfo(TrialNo).ROImask{i} = poly2mask(x,y,imsize(1),imsize(2));
end;
update_ROI_plot(handles);
handles = update_projection_images(handles);
guidata(hObject, handles)

% --- Executes on button press in ROI_move_up.
function ROI_move_up_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
imsize = size(CaSignal.ImageArray);
aspect_ratio = imsize(2)/imsize(1);
move_unit = 1* max(1/aspect_ratio,1);
if get(handles.ROI_move_all_check, 'Value') == 1
    roi_num_to_move = 1: length(CaSignal.ROIinfo(TrialNo).ROIpos);
else
    roi_num_to_move = str2num(get(handles.CurrentROINoEdit,'String'));
end
for i = roi_num_to_move
    CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2) = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2)-move_unit;
    x = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1);
    y = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2);
    CaSignal.ROIinfo(TrialNo).ROImask{i} = poly2mask(x,y,imsize(1),imsize(2));
end;
update_ROI_plot(handles);
handles = update_projection_images(handles);
guidata(hObject, handles)


% --- Executes on button press in ROI_move_down.
function ROI_move_down_Callback(hObject, eventdata, handles)

global CaSignal % ROIinfo ICA_ROIs
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
imsize = size(CaSignal.ImageArray);
aspect_ratio = imsize(2)/imsize(1);
move_unit = 1* max(1/aspect_ratio,1);
if get(handles.ROI_move_all_check, 'Value') == 1
    roi_num_to_move = 1: length(CaSignal.ROIinfo(TrialNo).ROIpos);
else
    roi_num_to_move = str2num(get(handles.CurrentROINoEdit,'String'));
end
for i = roi_num_to_move
    CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2) = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2)+move_unit;
    x = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,1);
    y = CaSignal.ROIinfo(TrialNo).ROIpos{i}(:,2);
    CaSignal.ROIinfo(TrialNo).ROImask{i} = poly2mask(x,y,imsize(1),imsize(2));
end

update_ROI_plot(handles);
handles = update_projection_images(handles);
guidata(hObject, handles)



function behavTrialNoToBeExcluded_Callback(hObject, eventdata, handles)
% hObject    handle to behavTrialNoToBeExcluded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of behavTrialNoToBeExcluded as text
%        str2double(get(hObject,'String')) returns contents of behavTrialNoToBeExcluded as a double


% --- Executes during object creation, after setting all properties.
function behavTrialNoToBeExcluded_CreateFcn(hObject, eventdata, handles)
% hObject    handle to behavTrialNoToBeExcluded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.

function dFF_array = get_dFF_roi(CaSignal, roiNo)

nTrials = numel(CaSignal.CaTrials);
dFF_array = [];
for i = 1:nTrials
    if ~isempty(CaSignal.CaTrials(i).dff)
        if size(CaSignal.CaTrials(i).dff,1) < roiNo
            return;
        else
            dFF_array = [dFF_array; CaSignal.CaTrials(i).dff(roiNo,:)];
        end
    end
end
    
% --- Executes during object creation, after setting all properties.
function Image_disp_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_disp_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Image_disp_axes


% --- Executes during object creation, after setting all properties.
function msgBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msgBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in dispAspectRatio.
function dispAspectRatio_Callback(hObject, eventdata, handles)
global CaSignal % ROIinfo ICA_ROIs
Str = get(hObject, 'String');
CaSignal.AspectRatio_mode = Str{get(hObject,'Value')};
guidata(hObject, handles);
handles = update_image_axes(handles);



% --- Executes during object creation, after setting all properties.
function dispAspectRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dispAspectRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function frame_time_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_time_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in export2avi_button.
function export2avi_button_Callback(hObject, eventdata, handles)

global CaSignal
TrialNo = str2double(get(handles.CurrentTrialNo,'String'));
fname = CaSignal.CaTrials(TrialNo).FileName;
[movieFileName, pathname] = uiputfile([fname(1:end-4) '.avi'], 'Export current trial to an avi movie');
movObj = VideoWriter([pathname filesep movieFileName]);
movObj.FrameRate = 15;

open(movObj);

for i = 1:CaSignal.CaTrials(TrialNo).nFrames
    set(handles.CurrentFrameNoEdit,'String',num2str(i));
    handles = update_image_axes(handles);
    F = getframe(handles.Image_disp_axes);
    writeVideo(movObj, F);
end
close(movObj);
% movie2avi(Mov,[pathname filesep movieFileName],'compression','none');


% --- Executes when selected object is changed in ROI_def.
function ROI_def_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ROI_def 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
% function ICA_ROI_anal_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to ICA_ROI_anal (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in ICA_ROI_anal.
% function ICA_ROI_anal_Callback(hObject, eventdata, handles)
% 
% global CaSignal % ROIinfo ICA_ROIs    
% if get(hObject, 'Value') == 1
%     % load_saved_data_SVD
%     if isempty(CaSignal.ImageArray)
%         error('No Imaging Data loaded. Do this before running ICA!');
%     end
%     % Display mean ICA map
%     if isfield(CaSignal, 'ICA_components') && ~isempty(CaSignal.ICA_components)
%         CaSignal.rois_by_IC = cell(1, size(CaSignal.ICA_components,1)) ;
%         IC_to_remove = inputdlg('IC to remove', 'Remove bad ICs');
%         if ~isempty(IC_to_remove)
%             IC_to_remove = str2num(IC_to_remove{1});
%             CaSignal.ICA_components(IC_to_remove,:) = NaN;
%         end
%         CaSignal.ICA_figs(3) = disp_mean_IC_map(CaSignal.ICA_components);
%     end
%     if isfield(CaSignal, 'ica_data') && ~isempty(CaSignal.ica_data.Data)
%         usr_confirm = questdlg('Display Max Projection of all data is slow and memory intensive. Continue?');
%         if strcmpi(usr_confirm, 'Yes')
% %             Data = LoadData(pwd,CaSignal.CaTrials(1).FileName_prefix,1:50);
%             [CaSignal.ICA_data_norm_max, CaSignal.ICA_figs(4)] = disp_maxDelta_rawData(Data);
%             [CaSignal.ICA_data_norm_max, CaSignal.ICA_figs(4)] = disp_maxDelta_rawData(CaSignal.ica_data.Data);
%             set(gcf,'Name',sprintf('MaxDelta of raw Data (%d~%d)',CaSignal.ica_data.FileNums(1),CaSignal.ica_data.FileNums(end)));
%         end
%     end
%     
%     [fn, pth] = uigetfile('*.mat', 'Load DATA SVD');
%     if fn == 0
%         return
%     end
%     ica_data = load(fullfile(pth,fn));
%     ica_data.Data = ICA_LoadData(ica_data.DataDir, ica_data.FileBaseName, ica_data.FileNums);
%     CaSignal.ica_data = ica_data;
%     CaSignal.currentIC = 1;
% %     handles.ica_data = ica_data;
% %     handles.ICA_datafile = fullfile(pth,fn);
% %     ICA_ROIs = struct;
%     guidata(hObject, handles);
%     runICA_button_Callback(handles.runICA_button, eventdata, handles);
% end


% % --- Executes on button press in prevIC_button.
% function prevIC_button_Callback(hObject, eventdata, handles)
% global CaSignal % ROIinfo ICA_ROIs
% if get(handles.ICA_ROI_anal,'Value') == 1 && CaSignal.currentIC > 1
%     CaSignal.currentIC = CaSignal.currentIC - 1;
%     set(handles.current_ICnum_text, 'String', num2str(CaSignal.currentIC));
% %     guidata(hObject, handles);
%     disp_ICA(handles);
% end


% --- Executes on button press in nextIC_button.
% function nextIC_button_Callback(hObject, eventdata, handles)
% global CaSignal  % ROIinfo ICA_ROIs
% if get(handles.ICA_ROI_anal,'Value') == 1 && CaSignal.currentIC < size(CaSignal.ICA_components,1)
%     CaSignal.currentIC = CaSignal.currentIC + 1;
%     set(handles.current_ICnum_text, 'String', num2str(CaSignal.currentIC));
%     guidata(hObject, handles);
%     disp_ICA(handles);
% end

% --- Executes on button press in runICA_button.
% function runICA_button_Callback(hObject, eventdata, handles)
% global CaSignal % ROIinfo ICA_ROIs
% data = CaSignal.ica_data.Data;
% V = CaSignal.ica_data.V;
% S = CaSignal.ica_data.S;
% ICnum = str2num(get(handles.IC_num_edit,'String'));
% % CaSignal.ICnum = str2num(get(handles.IC_num_edit,'String'));
% CaSignal.ICA_components = run_ICA(CaSignal.ica_data.Data, {S, V, 30, ICnum});
% CaSignal.rois_by_IC = cell(1,ICnum);
% % CaSignal.ICnum_prev = ICnum;
% 
% guidata(handles.figure1, handles);
% disp_ICA(handles);

% 
% function IC_num_edit_Callback(hObject, eventdata, handles)
% runICA_button_Callback(hObject, eventdata, handles);
% 

% --- Executes during object creation, after setting all properties.
% function IC_num_edit_CreateFcn(hObject, eventdata, handles)
% 
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% function disp_ICA(handles)
% global CaSignal % ROIinfo ICA_ROIs
% RowNum = CaSignal.imSize(1);
% ColNum = CaSignal.imSize(2);
% if ~ishandle(CaSignal.ICA_figs)
%     CaSignal.ICA_figs(1) = figure('Position', [123   460   512   512]);
%     CaSignal.ICA_figs(2) = figure('Position',[115    28   512   512]);
% end
% disp_ICAcomponent_and_blobs(CaSignal.ICA_components(CaSignal.currentIC,:),RowNum, ColNum, CaSignal.ICA_figs);
% for i = 1:length(CaSignal.ICA_figs)
%     figure(CaSignal.ICA_figs(i)),
%     plot_ROIs(handles);
%     title(sprintf('IC #%d',CaSignal.currentIC),'FontSize',15);
% end
% 
% function fig = disp_mean_IC_map(IC)
% for i=1:size(IC,1), 
%     IC_norm(i,:) = (IC(i,:)- nanmean(IC(i,:)))./ nanstd(IC(i,:)); 
% end
% IC_norm_mean = nanmax(abs(IC),[],1); % mean(abs(IC_norm),1);
% clim = [0  max(IC_norm_mean)*0.7];
% fig = figure('Position', [123   372   512   512]);
% imagesc(reshape(IC_norm_mean, 128, 512), clim); 
% axis square;

function [data_norm_max,fig] = disp_maxDelta_rawData(data)
% each image data has to be already transformed to 1D
% normalize
data_cell = mat2cell(data,ones(1,size(data,1)));
clear data
data_cell_norm = cellfun(@(x) (x-mean(x))./std(x), data_cell, 'UniformOutput',false);
clear data_cell
data_norm = cell2mat(data_cell_norm);
% for i = 1:size(data,1)
%     data_norm(i,:) = (data(i,:) - mean(data(i,:)))./std(data(i,:));
% end
data_norm_max = max(data_norm,[],1);
clim = [0  max(data_norm_max)*0.7];
fig = figure('Position', [100   100   512   512]);
imagesc(reshape(data_norm_max, 128, 512), clim);
axis square;
% --- Executes during object creation, after setting all properties.
function current_ICnum_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_ICnum_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in ROI_load_button.
function ROI_load_button_Callback(hObject, eventdata, handles)
global CaSignal


% --------------------------------------------------------------------
function Load_Ca_results_Callback(hObject, eventdata, handles)
global CaSignal
[fn pathstr] = uigetfile('*.mat', 'Load Previous CaTrials results', CaSignal.results_path);

if ischar(fn)
    CaSignal.results_path = pathstr;
    CaSignal.results_fname = fullfile(pathstr, fn);
    prev_results = load(CaSignal.results_fname);
    CaSignal.CaTrials = prev_results.CaTrials;
end
handles = update_image_axes(handles);
update_projection_images(handles);

% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Load_ROIinfo_Callback(hObject, eventdata, handles)
global CaSignal
[fn pathstr] = uigetfile('*.mat', 'Load saved ROI info', CaSignal.results_path);

if ischar(fn)
    CaSignal.ROIinfo_fname = fullfile(pathstr, fn);
    load(CaSignal.ROIinfo_fname);
    load_ROIinfo(ROIinfo, handles);    
end

handles = update_image_axes(handles);
update_projection_images(handles);


% --------------------------------------------------------------------
function load_ROIinfo(ROIinfo, handles)
global CaSignal
if iscell(ROIinfo)
    f1 = fieldnames(ROIinfo{1}); f2 = fieldnames(CaSignal.ROIinfo);
    for i = 1:length(ROIinfo)
        for j = 1:length(f1),
            CaSignal.ROIinfo(i).(f2{strcmpi(f2,f1{j})}) = ROIinfo{i}.(f1{j});
        end
    end
else
    CaSignal.ROIinfo = ROIinfo;
end
nROIs_allTrials = arrayfun(@(x) length(x.ROIpos), ROIinfo);

set(handles.nROIsText, 'String', num2str(max(nROIs_allTrials)));


% --------------------------------------------------------------------
% function Load_ICA_results_Callback(hObject, eventdata, handles)
% global CaSignal
% [fn pathstr] = uigetfile('*.mat','Load saved ICA results');
% if ischar(fn)
%     load(fullfile(pathstr, fn)); % load ICA_results
%     fprintf('ICA_results of %s loaded!\n', ICA_results.FileBaseName);
%     CaSignal.ICA_components = ICA_results.ICA_components;
%     CaSignal.currentIC = 1;
%     disp_ICA(handles)
% end



function current_ICnum_text_Callback(hObject, eventdata, handles)
global CaSignal  
newIC_No = str2num(get(hObject, 'String'));
if newIC_No <= size(CaSignal.ICA_components,1)
    CaSignal.currentIC = newIC_No;
    guidata(hObject, handles);
    disp_ICA(handles);
end


% --- Executes on button press in maxDelta_only_button.
function maxDelta_only_button_Callback(hObject, eventdata, handles)
global CaSignal
% if get(hObject,'Value') == 1
%     [fn, pth] = uigetfile('*.mat','Load Max Delta Image Array');
%     
%     
% end


% --- Executes during object creation, after setting all properties.
function ROI_def_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_def (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ROI_modify_button.
function ROI_modify_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ROI_modify_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function roiNo_to_plot_Callback(hObject, eventdata, handles)
% hObject    handle to roiNo_to_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiNo_to_plot as text
%        str2double(get(hObject,'String')) returns contents of roiNo_to_plot as a double


% --- Executes during object creation, after setting all properties.
function roiNo_to_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiNo_to_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_plotAllROIs.
function check_plotAllROIs_Callback(hObject, eventdata, handles)
% hObject    handle to check_plotAllROIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_plotAllROIs


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in import_ROI_from_Trial_checkbox.
function import_ROI_from_Trial_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to import_ROI_from_Trial_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of import_ROI_from_Trial_checkbox
