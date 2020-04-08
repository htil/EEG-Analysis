global totalSamples
totalSamples = 220;

global totalEpochs
totalEpochs = 109

global sampleRate
sampleRate = 220

% Do not include * 

% Create a matlab function that generates and saves line plots of 3 epochs
% (4 channels per epoch). The function should save a total of 12 images.

%saveEpochs(1,4)
compareBandPower(32)
%getHighestAlpha()

function saveEpochs(numEpochs, numChannels)
    global EEG;
    global totalSamples;
    
    ts = (1:totalSamples);
    for i = 1:numEpochs
        for y = 1:numChannels
            epoch = EEG.data(y,:,i);
            figure
            plot(ts, epoch);
            strEpoch = num2str(i);
            strChannels = num2str(y);
            title = [strEpoch '_' strChannels '.png'];
            saveas(gcf,title)
        end
    end
end



% Complete the function below to generate 4 bar plots that compares delta, theta, alpha, and beta band
% power of 1 epoch. Each bar plot should reflect a different channel.



function compareBandPower(epochNumber)
    global sampleRate;
    global EEG;
    
    for channel = 1:4
        epoch = EEG.data(channel,:,epochNumber);
        [pxx, freq] = pwelch(epoch, [],[], [], sampleRate);
        delta = bandpower(pxx, freq, [1 3], 'psd');
        theta = bandpower(pxx, freq, [4 8], 'psd');
        alpha = bandpower(pxx, freq, [9 14], 'psd');
        beta = bandpower(pxx, freq, [15 30], 'psd');
        x = categorical({'Delta', 'Theta', 'Alpha', 'Beta'});
        x = reordercats(x,{'Delta', 'Theta', 'Alpha', 'Beta'});
        y = [delta theta alpha beta];
        figure
        bar(x, y);
        title(['Channel ' num2str(channel)])
        
        %disp(alpha)
    end
end

% Create a matlab function that finds the epoch with the highest alpha
% power in channel. The function should print out the epoch number and
% alpha value.

function getHighestAlpha()
    global totalEpochs 
    global EEG;
    global sampleRate;
    
    currentEpoch = 0
    currentMaxAlpha = 0
    for x = 1:totalEpochs
        epoch = EEG.data(1,:,x);
        [pxx, freq] = pwelch(epoch, [],[], [], sampleRate);
        alpha = bandpower(pxx, freq, [9 14], 'psd');
        if alpha > currentMaxAlpha
           currentMaxAlpha = alpha;
           currentEpoch = x;
        end
    end

    disp([ currentEpoch currentMaxAlpha])
end




% Turn in a paper explaining your process for each tasks. The paper should
% have the following sections. 

% 1)
% 2)
% 3)



