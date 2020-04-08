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
cleanDirectory = char(strcat(pwd, "/clean/artifact_rejected"));

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
global sampleRate
sampleRate = 220;

% Number of Channels; 
global numChannels
numChannels = 4;

% Get set files
setFiles = dir(fullfile(cleanDirectory,'*.set'));

% Process Files
globalTable = {};

comp = 630;
compStr = 'p600';

eeglab("redraw")

for k = 1:getFileCount(setFiles)
    baseFileName = setFiles(k).name;
    participantName = split(baseFileName, "_");
    participantName = participantName(1);
    EEG = pop_loadset('filename', baseFileName, 'filepath', cleanDirectory );
    EEG=pop_chanedit(EEG, 'changefield',{1 'labels' 'TP9'}, 'changefield',{2 'labels' 'AF7'},'changefield',{3 'labels' 'AF8'}, 'changefield', {4 'labels' 'TP10'});
     
    % Create New Set
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'setname', setFiles(k).name,'gui','off');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    t = addComponent(comp, 1, 'Fact', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 2, 'Procedure', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 3, 'Dark', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 4, 'Light', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 5, 'Tone', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 6, 'No Tone', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 8, 'Fact No Stimuli', compStr, participantName);
    globalTable = [globalTable; t];
    t = addComponent(comp, 9, 'Procedure No Stimuli', compStr, participantName);
    globalTable = [globalTable; t];
    
    %{
    for i = 1:4
        %epoch1_channel1 = EEG.data(i,:,2);
        epoch1_channel1 = getEpochData(i,1);
        x = 1:220;
        x = x*(1000/sampleRate);
        figure
        plot(x,epoch1_channel1)
        title(num2str(i))
    end
    %}

    eeglab("redraw")
end

fileName = char(strcat(pwd, "/erps/", compStr, ".txt"));
writetable(globalTable, fileName);

function t = addComponent(component, bin, type, componentString, participantName)
    %global globalTable;
    
    component = getComponentVal(component, bin);
    s = size(component.TP9(:));
    rows = s(1);
    participantArray = rep(rows, participantName);
    typeArray = rep(rows, type);
    componentArray = rep(rows, componentString);
    t = table(participantArray, componentArray, typeArray, component.TP9(:), component.AF7(:), component.AF8(:), component.TP10(:), 'VariableNames',{'Participant', 'Component', 'Type', 'TP9', 'AF7','AF8', 'TP10'});
    %globalTable = [globalTable;t];
end



function epoch = getEpochData(channel, epoch)
    global EEG
    epoch = EEG.data(channel,:,epoch);
end

function plotEpoch(epoch)
    global sampleRate;
    global numChannels;
    for i = 1:numChannels
        data = getEpochData(i,epoch);
        channel = getChannelLabel(i);
        x = (1:sampleRate)*(1000/sampleRate);
        figure
        plot(x,data)
        title(channel)
    end 
end

function component = getComponentVal(comp, targetType)
    global sampleRate;
    global EEG;
    s = size(EEG.data);
    epochCount = s(3);
    component = {};
    offset = 200 + comp;
    global numChannels;
    gap = 1000/sampleRate;
    sample = round(offset / gap);
    labels = {};
    
    for i = 1:numChannels
        label = getChannelLabel(i);
        component.(label) = [];
        labels(i) = {label};
        eCount = 1;
        %currentElectrodeCell = [];
        for x = 1:epochCount
            epochType = getEpochType(x);
            %res = isBin(targetType,x);
            %disp(strcat(epochType, " ", targetType))
            if isBin(targetType,x)
                data = getEpochData(i,x);
                val = data(sample);
                component.(label)(eCount) = val;
                eCount = eCount + 1;
                %disp(strcat(num2str(x), " ", label, " ", num2str(val)));
            end
        end 
    end
end

function c = rep(count, val)
    c = cell(1,count);
    c(:) = {val};
    c = c';
end

function label = getChannelLabel(channelID)
    global EEG
    label = EEG.chanlocs(:,channelID).labels;
end

function res = isBin(binID, epoch)
    global EEG
    bins = EEG.event(epoch).bini;
    res = any(bins(:) == binID);
end 


function epochType = getEpochType(epoch)
    global EEG
    type = EEG.event(epoch).type;
    type = split(type, ",");
    epochType = type(1);
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