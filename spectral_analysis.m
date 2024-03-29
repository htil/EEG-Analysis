%https://raphaelvallat.com/bandpower.html


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

% Total samples
global totalSamples
totalSamples = 220 * 2;

% Sample Rate
global sampleRate
sampleRate = 220;

% Number of Channels; 
global numChannels
numChannels = 4;

global epochLen
epochLen = 1000;

% Get set files
setFiles = dir(fullfile(cleanDirectory,'*.set'));

% Process Files
globalTable = {};

eeglab("redraw")
for k = 1:getFileCount(setFiles)
     baseFileName = setFiles(k).name;
     EEG = pop_loadset('filename', baseFileName, 'filepath', cleanDirectory );
     EEG=pop_chanedit(EEG, 'changefield',{1 'labels' 'TP9'}, 'changefield',{2 'labels' 'AF7'},'changefield',{3 'labels' 'AF8'}, 'changefield', {4 'labels' 'TP10'});
     
     
    % Create New Set
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', setFiles(k).name,'gui','off');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    %EEG = pop_saveset( EEG, 'filename', baseFileName,'filepath', cleanDirectory);
    
    newStr = split(baseFileName,".");
    fileName = char(newStr(1));
    
    erplab_eventlist_file_loc =  strcat(pwd, "/erplab_events/", fileName, "_elist.txt");
    disp(erplab_eventlist_file_loc)
    
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', char(erplab_eventlist_file_loc));    
    
    % Create Binlister file
    EEG  = pop_binlister( EEG , 'BDF', char(binListerFile), 'ExportEL', char(erplab_eventlist_file_loc), 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    
    % Extract Epochs
    EEG = pop_epochbin( EEG , [-500  1500],  'pre');
    %[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off'); 
    
    % Artifact Rejection
    EEG  = pop_artmwppth( EEG , 'Channel',  1:4, 'Flag',  1, 'Threshold',  100, 'Twindow', [-500  1500], 'Windowsize',  200, 'Windowstep',  100 );
    rej = getRejects();
    EEG = pop_rejepoch( EEG, rej,0);
    
    % Store Auto Artifact rejection files. (Use only after manually
    % reviewing epochs
    participantName = split(fileName, "_");
    participantName = participantName(1);
    fileName = char(strcat(participantName, "_ar.set"));
    fileLocation = char(strcat(pwd, '/spectral_analysis/'));
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
    %plotEpoch(1)
    
    %{
    bin = EEG.event(1).bini
    s = size(bin)
    disp(s(2))
    
    for type = 1:s(2)
        target = bin(type);
        out = strcat('==> ', num2str(target))
        disp('hello')
    end
    %}
    
    for epoch = 1:1
        for channel = 1:numChannels
            data = getEpochData(channel,epoch);
            
            bins = getBins(epoch);
            s = size(bins);
            for index = 1:s(2)
                type = bins(index);
                storeEpoch(data, false, epoch, participantName, type);
            end

            

            %res = isBin(8, epoch)
           
            %[power, freq] = spectopo(data, 0, 220, 'limits', [0 30], 'title', char(type), 'freqrange', [0 30]);
            

            % Get spectral info
            %{
            res = getWelch(data, sampleRate, false);  
            f = res(:,2);
            pxx = res(:,1);
            pxx = 10*log10(pxx);
            delta = bandpower(pxx, f, [1 3], 'psd');
            theta = bandpower(pxx, f, [4 6], 'psd');
            alpha = bandpower(pxx, f, [7 13], 'psd');
            beta = bandpower(pxx, f, [14 25], 'psd');
            gamma = bandpower(pxx, f, [26 30], 'psd');
            channelLabel = getChannelLabel(channel);

            t = table({char(participantName)}, {type}, {channelLabel}, {delta}, {theta}, {alpha}, {beta}, {gamma}, 'VariableNames',{'Participant', 'Type', 'Electrode', 'Delta', 'Theta', 'Alpha','Beta', 'Gamma'});
            globalTable = [globalTable; t];
            %}
            
        end
    end
    
    %EEG = pop_saveset( EEG, 'filename',fileName,'filepath',fileLocation);
    
    eeglab("redraw")
end

%fileName = char(strcat(pwd, "/spectral_analysis/spectral.txt"));
%writetable(globalTable, fileName);


function storeEpoch(data, plotGraph, epoch, participantName, type)
    global globalTable;
    global sampleRate;
    
    
    
    
    res = getWelch(data, sampleRate, plotGraph);
    freq = res(:,2);
    pxx = res(:,1);
    pxx = 10*log10(pxx);
    delta = bandpower(pxx, freq, [1 3], 'psd');
    theta = bandpower(pxx, freq, [4 6], 'psd');
    alpha = bandpower(pxx, freq, [7 13], 'psd');
    beta = bandpower(pxx, freq, [14 25], 'psd');
    gamma = bandpower(pxx, freq, [26 30], 'psd');
    disp(gamma)
     
    
    % Start here adding rows for each epoch type. 
    % Maybe just save duplicates to make analyzing in R easier
    %{
    
    % Get array of types
    types = char(getEpochType(epoch));
    
    % Loop through array and store epochs
    
    res = getWelch(data, sampleRate, plotGraph);
    f = res(:,2);
    pxx = res(:,1);
    pxx = 10*log10(pxx);
    delta = bandpower(pxx, f, [1 3], 'psd');
    theta = bandpower(pxx, f, [4 6], 'psd');
    alpha = bandpower(pxx, f, [7 13], 'psd');
    beta = bandpower(pxx, f, [14 25], 'psd');
    gamma = bandpower(pxx, f, [26 30], 'psd');
    channelLabel = getChannelLabel(channel);
    t = table({char(participantName)}, {type}, {channelLabel}, {delta}, {theta}, {alpha}, {beta}, {gamma}, 'VariableNames',{'Participant', 'Type', 'Electrode', 'Delta', 'Theta', 'Alpha','Beta', 'Gamma'});
    %}
end



function bins = getBins(epoch)
    global EEG
    bins = EEG.event(epoch).bini;
end

function res = isBin(binID, epoch)
    global EEG
    bins = EEG.event(epoch).bini;
    res = any(bins(:) == binID);
end 

function label = getChannelLabel(channelID)
    global EEG
    label = EEG.chanlocs(:,channelID).labels;
end

function epochs = getEpochCount()
    global EEG
    s = size(EEG.data);
    epochs = s(3);
end

function c = rep(count, val)
    c = cell(1,count);
    c(:) = {val};
    c = c';
end


function psd = getWelch(signal, sampleRate, plot)
     % If interested in higher frequency resolution try:
     % periodogram(data, hamming(length(data)), [], sampleRate, 'onesided');
     [pxx,w] = pwelch(signal, [],[], [], sampleRate);
     if (plot == true)
         figure
         pwelch(signal, [],[], [], sampleRate);
     end
     psd = [pxx w];
end

function epoch = getEpochData(channel, epoch)
    global EEG
    epoch = EEG.data(channel,:,epoch);
end

function plotEpoch(epoch)
    global sampleRate;
    global numChannels;
    global epochLen;
    global totalSamples;
    for i = 1:numChannels
        data = getEpochData(i,epoch);
        disp("data Size");
        size(data)
        channel = getChannelLabel(i);
        x = (1:totalSamples)*(epochLen/sampleRate);
        figure
        plot(x,data)
        title(channel)
    end 
end

function epochType = getEpochType(epoch)
    global EEG
    type = EEG.event(epoch).type;
    type = split(type, ",");
    epochType = type(1);
end

function rej = getRejects()
    global EEG
    r = EEG.reject.rejmanual;
    rej = find(r==1);
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