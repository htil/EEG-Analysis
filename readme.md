# Getting Started with EEGLAB

This following steps should work for the following versions of MATLAB and EEGLAB

**MATLAB: R2018b**

**EEGLAB: 12.1.2**

**Step 1)**

First, be sure to run `npm install`

**Step 2)**

Note: Be sure to store original `*.csv` files in the `/original_gtec_data` directory. Store original events files in the `/original_events` directory

run `node reorganizeEEGData.js`

This will output files with EEG data properly formatted into columns in the `/raw` directory.

**Step 3)**

Run `node latency_calc.js`. Be sure there is a signal file in the `/original_gtec_data` directory and event file in the `/original_events` directory. The latency_calc.js file uses both of these files to compute event latency.

## Working with EEGLAB

1. [Install EEGLAB](instructions/installing_eeglab.pdf)
2. Open MATLAB
3. Run the following command in MATLAB `run preprocess.m`

- This should generate processed files in the `clean` directory.
