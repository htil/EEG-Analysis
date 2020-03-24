% Define Global Variables
currentDirectory = pwd;
ALLEEG = [];
CURRENTSET = 1;
global SAVE_FIGURE;
SAVE_FIGURE = 0; 

global PLOT_ICA;
PLOT_ICA = 0;

global PLOT_CHANNEL;
PLOT_CHANNEL = 0;

global COMPONENT_COUNT;
COMPONENT_COUNT = 3;

global FILE_COUNT;
FILE_COUNT = -1;

% Directory that stores raw files
rawDirectory = strcat(pwd, "/raw/");

% Directory that stores raw files
cleanDirectory = char(strcat(pwd, "/clean/"));

% Binlister file 
binListerFile = char(strcat(pwd, "/erplab_events/binlister_brain_butler.txt"));

% Directory that stores figures
global figureDirecory
figureDirecory = char(strcat(pwd, "/figs/"));

% CSV File
eegFiles = dir(fullfile(rawDirectory,'*.csv'));

% File to assist with source localization (ICA)
elpFile = char(strcat(pwd, "/res/standard-10-5-cap385.elp"));

% Channel Locations
channelLocationFile = char(strcat(pwd, "/res/muse.ced"));

%

% Sample Rate
sampleRate = 220;

% Number of Channels; 
numChannels = 4;

% Get set files
setFiles = dir(fullfile(cleanDirectory,'*.set'));

% Process Files

eeglab("redraw")
for k = 1:getFileCount(setFiles)
     baseFileName = setFiles(k).name;
     EEG = pop_loadset('filename', baseFileName, 'filepath', cleanDirectory );
     
    % Create New Set
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', setFiles(k).name,'gui','off');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    newStr = split(baseFileName,".");
    fileName = char(newStr(1));
    
    erplab_eventlist_file_loc =  strcat(pwd, "/erplab_events/", fileName, "_elist.txt");
    disp(erplab_eventlist_file_loc)

    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', char(erplab_eventlist_file_loc) );
    
    %EEG  = pop_binlister( EEG , 'BDF', char(binListerFile), 'ExportEL', char(erplab_eventlist_file_loc), 'IndexEL',  1, 'SendEL2', 'Text', 'Voutput', 'EEG' );
    
    
    % Create Binlister file
    EEG  = pop_binlister( EEG , 'BDF', char(binListerFile), 'ExportEL', char(erplab_eventlist_file_loc), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    
    % Extract Epochs
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    
    % Artifact Rejection
    EEG  = pop_artmwppth( EEG , 'Channel',  1:4, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 795.5], 'Windowsize',  200, 'Windowstep',  100 );
    
    % Analyze ERP
    
    % Average ERP
    ERP = pop_averager( ALLEEG , 'Criterion', 1, 'DSindex',  CURRENTSET, 'SEM', 'on');
    
    % Filter ERP
    ERP = pop_filterp( ERP,1:4 , 'Cutoff',30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',2 );
    
    pop_ploterps( ERP, [ 1, 2],1:4, 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on'                ...
        , 'Blc', 'pre', 'Box', [ 4 4], 'ChLabel', 'on', 'FontSizeChan',10, 'FontSizeLeg',10           ...
        , 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',1, 'Maximize', 'on'             ...
        , 'Position', [ 102.833 9.375 108.667 35.125], 'Style', 'Matlab'                              ...
        , 'xscale', [ -200.0 798.0 -100:170:750], 'YDir', 'normal', 'yscale', [ -10.0 10.0 -10:5:10]  );
    
    % Save ERP file
    erpFileName = strcat(fileName, '.erp');
    erpFileSetname = strcat(fileName, '.set');
    erpFileLocation = char(strcat(pwd, "/erps/", erpFileName));
    ERP = pop_savemyerp( ERP, 'erpname', erpFileSetname, 'filename', erpFileLocation);
    
    eeglab("redraw")
end

% Get File Count
function fileCount = getFileCount(setFiles)
    global FILE_COUNT
    
    if FILE_COUNT == -1
        fileCount = length(setFiles);
    else
        fileCount = FILE_COUNT;
    end 
end