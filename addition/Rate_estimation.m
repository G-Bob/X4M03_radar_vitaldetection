function [avg_acf,avg_pd] = Rate_estimation(xb,fs,type)
%xb = cp_h1(:,subInd1);
xc = hampel(xb(:,:),2,1)-mean(xb(:,:))% Static components removal
T = 1/fs;
[ac, lag] = xcorr(xc);
min_dist = ceil(0.5*fs); % sec*fs represents least respiration gap
[pks, loc] = findpeaks(ac, 'MinPeakDistance', min_dist);

%% Average distance/frequency from acf
avg_dt = mean(gradient(loc))*T;
avg_acf = 1/avg_dt;

subplot(211);


plot(lag*T, ac);
hold on
grid on
plot(lag(loc)*T, pks, 'xr');
title(sprintf('ACF - Average frequency of %s : %.2f Hz',type, avg_acf));
hold off
%% Simple peak finding in time domain
%[pkst, loct] = findpeaks(xb, 'MinPeakDistance', min_dist, 'MinPeakHeight', 0.5*max(xb));
[pkst, loct] = findpeaks(xc,'MinPeakHeight', 0.01*(max(xc)-min(xc)));
avg_dt2 = mean(gradient(loct))*T;
avg_pd = 1/avg_dt2;

% figure;
% etime = length(xc)/fs;
T=1/fs;  %Sample frequency
N1 = length(xc);
t = 0:T:(N1-1)*T; %采样时间



% subplot(311);
% plot(xc);
% title('Orignial CSI data')
% subplot(211);
% plot(t,xc);
% title('CSI data after preprocessing')

subplot(212);

grid on
plot(t,xc);
hold on
plot(loct*T, pkst, 'xr');
xlabel('t [s]')
ylabel('CSI Amplitude')
title(sprintf('Peak search in time domain - Average frequency of %s: %.2f Hz', type, avg_pd))
hold off
end

