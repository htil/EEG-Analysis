%% Directory that stores raw files
rawDirectory = strcat(pwd, "/raw/");

%% CSV File
eegFiles = dir(fullfile(rawDirectory,'*.csv'));

for k = 1:length(eegFiles)
    %% Get file
    currentFile = eegFiles(k).name;
    outputFileName = split(currentFile,"."); outputFileName = outputFileName(1);
    file = strcat(rawDirectory, currentFile);
    disp(file)
    
    %% Load EEG Data
    participantEEG = loadFile(file);
    
    
end

function EEG = loadFile(filename)
    file = csvread(char(filename), 1, 0);
    EEG = transpose(file);
end