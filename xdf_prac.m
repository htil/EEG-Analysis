

% Sample Rate
sampleRate = 256;

% Number of Channels; 
numChannels = 5;

fileName = 'raw/gazebo_muse_data.xdf';

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Load File
subjectEEGData = loadBriFile(fileName);

% Get Sample Size
sampleSize = getSampleSize(subjectEEGData);

% Import file to EEGLAB
%EEG = pop_importdata('dataformat','array','nbchan', numChannels,'data','subjectEEGData','srate',sampleRate,'pnts', sampleSize,'xmin',0);

%id = getDataID(fileName);
%EEG = pop_importdata('dataformat','array','nbchan',0,'data','subjectEEGData','srate',256,'pnts',0,'xmin',0);
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','test','gui','off'); 
%eeglab('redraw');

% Loads the BRI File
function EEG = loadBriFile(filename)
    delete *.mexmaci64
    streams = load_xdf(filename);
    EEG = streams{1,1}.time_series;
    %EEG = transpose(EEG);
end

function sampleSize = getSampleSize(EEGDATA)
    columnSize = size(EEGDATA);
    sampleSize = columnSize(2);
end


function id = getDataID(filename)
    streams = load_xdf(filename);
    id = streams{1,1}.info.source_id;
end

