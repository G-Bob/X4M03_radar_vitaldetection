function [Fre_fft] = Rate_estimation_fft(xb,Fs,type)
N = length(xb);            % samples
dF = Fs/N;                 % hertz per sample
f = 0:dF:Fs/2-dF + (dF/2)*mod(N,2);      % hertz
Y1_fft = fftshift(fft(xb))/N;
fft_abs = Y1_fft(floor(length(Y1_fft)/2)+1:end);
plot(f,abs(fft_abs));
xlim([0 max(f)]);
hold on
grid on
%% Peak detection
lv = 1:length(f);
min_dist = ceil(20*dF);
[pks, locs]=findpeaks(abs(fft_abs(lv)),'MinPeakDistance', min_dist);
plot(f(locs), pks, 'or');
Fre_fft = f(locs);

xlabel('Frequency (Hz)')
ylabel('CSI Amplitude')
title(sprintf('Peak search in time domain - Average frequency of %s: %.2f Hz', type, Fre_fft))


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

