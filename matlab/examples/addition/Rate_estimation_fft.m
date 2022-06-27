function [Fre_fft, ref_freq] = Rate_estimation_fft(xb,Fs,type,blechar)
N = length(xb);            % samples
dF = Fs/N;                 % hertz per sample
f = 0:dF:Fs/2-dF + (dF/2)*mod(N,2);      % hertz
Y1_fft = fftshift(fft(xb))/N;
fft_abs = Y1_fft(floor(length(Y1_fft)/2)+1:end);
plot(f,abs(fft_abs));
xlim([0 2.5]);
hold on
grid on
%% Peak detection
lv = 1:length(f);
min_dist = ceil(200*dF);
[pks, locs]=findpeaks(abs(fft_abs(lv)),'MinPeakDistance', min_dist);

% plot(f(locs), pks, 'or'); % plot a circle

index = find(pks == max(pks));

Fre_fft = f(locs(index));
xline(Fre_fft,'r--',{'Measurement'})

name1 = [num2str(Fre_fft),'Hz (',num2str(60*Fre_fft),'bpm) of Measurement'];

xlabel('Frequency (Hz)')
ylabel('Frequency response')
title(sprintf('Peak search in time domain - Average frequency: %.2f Hz', Fre_fft))
if type == 'h'
    ref_freq = Heartdetect(blechar)/60;
    xline(ref_freq,'b--',{'GroundTruth'});
    name2 = [num2str(ref_freq),'Hz (',num2str(60*ref_freq),'bpm) of Reference'];
    legend('FFT response',name1,name2);
    leg1 = legend('FFT response',name1,name2);
    title(leg1,'Heartbeat rate comparison')
else
    if type == 'r'
        ref_freq = readResp();
        xline(ref_freq,'b--',{'GroundTruth'});
        name2 = [num2str(ref_freq),'Hz (',num2str(60*ref_freq),'bpm) of Reference'];
        leg1 = legend('FFT response',name1,name2);
        title(leg1,'Respiration rate comparison')
    end
end
% [ac, lag] = xcorr(f);
% min_dist = ceil(2*dF); % sec*fs represents least respiration gap
% [pks, loc] = findpeaks(ac, 'MinPeakDistance', min_dist);
% %avg_dt = mean(gradient(loc))*f;
% %avg_acf = 1/avg_dt;
% plot(loc, ac);
hold off

% 
% grid on
% plot(t,xc);
% hold on
% plot(loct*T, pkst, 'xr');
% xlabel('t[s]')
% ylabel('CSI Amplitude')
% title(sprintf('Peak search in time domain - Average frequency of %s: %.2f Hz', type, avg_pd))
% hold off
end

