function [Fre_fft] = FFT_estimation(xb,Fs)
N = length(xb);            % samples
dF = Fs/N;                 % hertz per sample
f = 0:dF:Fs/2-dF + (dF/2)*mod(N,2);      % hertz
Y1_fft = fftshift(fft(xb))/N;
fft_abs = Y1_fft(floor(length(Y1_fft)/2)+1:end);
%% Peak detection
lv = 1:length(f);
min_dist = ceil(20*dF);
[pks, locs]=findpeaks(abs(fft_abs(lv)),'MinPeakDistance', min_dist);

% plot(f(locs), pks, 'or'); % plot a circle

index = find(pks == max(pks));

Fre_fft = f(locs(index));
end

