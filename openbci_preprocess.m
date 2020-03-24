%% Directory that stores raw files
startRange = getMS(11);
endRange = getMS(12);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','openbci_p1_clean.set','filepath','/Users/chris/Documents/eeg_analysis/clean/');
figure(1); pop_newtimef( EEG, 1, 1, [startRange  endRange], [3         0.5] , 'topovec', 1, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', 'FP1', 'baseline',[0], 'freqs', [0 30], 'plotphase', 'off', 'padratio', 1);
figure(2); pop_newtimef( EEG, 1, 2, [startRange  endRange], [3         0.5] , 'topovec', 1, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', 'FP1', 'baseline',[0], 'freqs', [0 30], 'plotphase', 'off', 'padratio', 1);
figure(3); pop_newtimef( EEG, 1, 3, [startRange  endRange], [3         0.5] , 'topovec', 1, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', 'FP1', 'baseline',[0], 'freqs', [0 30], 'plotphase', 'off', 'padratio', 1)
eeglab('redraw');

function ms = getMS(time)
        ms = time * 60 * 1000;
end