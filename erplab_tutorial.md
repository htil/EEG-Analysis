# ERPLAB

**Note**: Original scripts and data from Ethan's study is located in `Documents > EEGLAB`. For more details see the [tutorial video](https://youtu.be/zTdjgtmdKE8). To install ERPLAB see [this video](https://youtu.be/nHZ16IR9moU). 

Adding an EventList: Assigning events to Bins with BINLISTER
Epoching the Continuous EEG

The Following menu options are located in EEGLAB

### Creating EEG Event List: 

`ERPLAB > EventList > Create EEG EVENTLIST`

`EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', '/Users/chris/Documents/eeg_analysis/erplab_events/p1_elist.txt' );`

### Assign Events to Bins
[Overview of BINLISTER](https://github.com/lucklab/erplab/wiki/Assigning-Events-to-Bins-with-BINLISTER)

`ERPLAB > Assign bins (BINLISTER)`

`EEG  = pop_binlister( EEG , 'BDF', '/Users/chris/Documents/eeg_analysis/erplab_events/binlister_brain_butler.txt', 'ExportEL', '/Users/chris/Documents/eeg_analysis/erplab_events/binlister_brain_butler2.txt', 'IndexEL',  1, 'SendEL2', 'Text', 'Voutput', 'EEG' );`

### Epoch Data
`ERPLAB > Extract bin-based epochs`
`EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre');`

### Artifact Rejection
`ERPLAB > Artifact Detection in epoched data > Moving window peak-to-peak threshold`

`EEG  = pop_artmwppth( EEG , 'Channel',  1:4, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 795.5], 'Windowsize',  200, 'Windowstep',  100 );`

### Averaging
For more details see [these instructions](https://github.com/lucklab/erplab/wiki/Creating-Averaged-ERPs)

`ERPLAB > Compute Averaged ERPS`

`ERP = pop_averager( ALLEEG , 'Criterion', 1, 'DSindex',  CURRENTSET, 'SEM', 'on');`

### Filter Signal
`ERPLAB > Filter & frequency tools > Filters for ERP data`
` ERP = pop_filterp( ERP,1:4 , 'Cutoff',30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',2 );`

### Plotting ERP Waveforms
`ERPLAB > Plot ERP waveforms`

`  pop_ploterps( ERP, [ 1, 2],1:4, 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on'                ...
        , 'Blc', 'pre', 'Box', [ 4 4], 'ChLabel', 'on', 'FontSizeChan',10, 'FontSizeLeg',10           ...
        , 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',1, 'Maximize', 'on'             ...
        , 'Position', [ 102.833 9.375 108.667 35.125], 'Style', 'Matlab'                              ...
        , 'xscale', [ -200.0 798.0 -100:170:750], 'YDir', 'normal', 'yscale', [ -10.0 10.0 -10:5:10]  );`

### ERP Measurements
For more details see [these instructions.](https://github.com/lucklab/erplab/wiki/ERP-Measurement-Tool)

For scripting information see [this resource](https://github.com/lucklab/erplab/wiki/Measuring-amplitudes-and-latencies-with-the-ERP-Measurement-Tool)

`ERPLAB > ERP Measurement Tool`






