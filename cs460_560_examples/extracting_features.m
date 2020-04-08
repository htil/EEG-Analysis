% Importing EEG Data
EEG = pop_loadset('filename', 'p1.set', 'filepath', pwd );

% Edit Channels
EEG = pop_chanedit(EEG, 'changefield',{1 'labels' 'TP9'}, 'changefield',{2 'labels' 'AF7'},'changefield',{3 'labels' 'AF8'}, 'changefield', {4 'labels' 'TP10'});

% Define variables
epochIndex = 1;
channelNumber = 2;
sampleRate = 220;

% Get power density estimate
epoch = EEG.data(channelNumber,:,epochIndex);
[pxx, freq] = pwelch(epoch, [],[], [], sampleRate);

% Get Alpha Power
alpha = bandpower(pxx, freq, [9 14], 'psd');
beta = bandpower(pxx, freq, [15 30], 'psd');
disp(beta)
