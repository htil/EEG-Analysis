% Importing EEG Data
EEG = pop_loadset('filename', 'p1.set', 'filepath', pwd );

% Edit Channels
EEG = pop_chanedit(EEG, 'changefield',{1 'labels' 'TP9'}, 'changefield',{2 'labels' 'AF7'},'changefield',{3 'labels' 'AF8'}, 'changefield', {4 'labels' 'TP10'});

% Define variables
epochIndex = 1;
channelNumber = 2;
totalSamples = 220;
epochLen = 1000;
sampleRate = 220;

% Get Epoch
epoch = EEG.data(channelNumber,:,epochIndex);

% Get power density estimate
[pxx, freq] = pwelch(epoch, [],[], [], sampleRate);

% Get Band power
alpha = bandpower(pxx, freq, [9 14], 'psd');
beta = bandpower(pxx, freq, [15 30], 'psd');

% Plot Band Power (Bar Plot)
x = categorical({'Alpha', 'Beta'});
x = reordercats(x,{'Beta', 'Alpha'});
y = [alpha beta];

% Create Figure
figure
bar(x,y)
title(['Channel ' num2str(channelNumber)])

% Save plot
saveas(gcf,'alpha_beta_plot.png')