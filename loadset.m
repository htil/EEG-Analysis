
%% Define Global Variables
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

% Directory that stores figures
global figureDirecory
figureDirecory = char(strcat(pwd, "/figs/"));

% CSV File
eegFiles = dir(fullfile(rawDirectory,'*.csv'));

% File to assist with source localization (ICA)
elpFile = char(strcat(pwd, "/res/standard-10-5-cap385.elp"));

% Channel Locations
channelLocationFile = char(strcat(pwd, "/res/muse.ced"));

% Sample Rate
sampleRate = 220;

% Number of Channels; 
numChannels = 4;

% Get set files
setFiles = dir(fullfile(cleanDirectory,'*.set'));

%% Process Files

eeglab("redraw")
for k = 1:getFileCount(setFiles)
     baseFileName = setFiles(k).name;
     EEG = pop_loadset('filename', baseFileName, 'filepath', cleanDirectory );
     
    % Create New Set
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', setFiles(k).name,'gui','off');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % Plot Figure
    %plotSpectrogram(k, EEG, baseFileName)
    eeglab("redraw")
end

%% Plot Spectrogram
function plotSpectrogram(chanNumber, EEG, baseFileName)
global figureDirecory PLOT_CHANNEL SAVE_FIGURE PLOT_ICA COMPONENT_COUNT

    for i = 1:COMPONENT_COUNT
          
        % ICA
        if PLOT_ICA == 1
            icaCaption = strcat('IC', num2str(i), '_', baseFileName);
            figure; pop_newtimef( EEG, 0, i, [0  10000], [3         0.5] , 'topovec', EEG.icawinv(:,1), 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', icaCaption, 'baseline',[0], 'freqs', [0 30], 'plotphase', 'off', 'padratio', 1);
            
            % Save Figure
            if SAVE_FIGURE == 1
                figFileName = strcat(figureDirecory, icaCaption, ".png"); figFileName = char(figFileName);
                saveas(gcf, figFileName,'png');
            end
        end
        
         % Channel
         if PLOT_CHANNEL == 1
            caption = char(strcat(EEG.chanlocs(i).labels, " - ", baseFileName));
            figure; pop_newtimef( EEG, 1, 2, [0  10000], [3         0.5] , 'topovec', 2, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', caption, 'baseline',[0], 'freqs', [0 30], 'plotphase', 'off', 'padratio', 1);
         
                % Save Figure
                if SAVE_FIGURE == 1
                    figFileName = strcat(figureDirecory, caption, ".png"); figFileName = char(figFileName);
                    saveas(gcf, figFileName,'png');
                end
         end 
    end
end

%% Get File Count
function fileCount = getFileCount(setFiles)
    global FILE_COUNT
    
    if FILE_COUNT == -1
        fileCount = length(setFiles);
    else
        fileCount = FILE_COUNT;
    end 
end

