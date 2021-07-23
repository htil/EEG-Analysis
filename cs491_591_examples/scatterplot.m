% Band Power (Scatter Plot)
figure
s = scatter([alpha, 7],[beta, 5.1]);
xlim([0 10]) 
ylim([0 10])
saveas(gcf,'scatter_alpha_beta_plot.png')


eeglab("redraw")

%pxx = 10*log10(pxx);
%plot(freq,pxx)
%plot(x, epoch)

%[pxx,w] = periodogram(epoch, hamming(length(epoch)), [], sampleRate, 'onesided');
%plot(w(1:10), pxx(1:10))