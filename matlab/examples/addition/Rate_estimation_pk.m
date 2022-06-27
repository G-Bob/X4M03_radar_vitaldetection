function [avg_acf,avg_pd,a1,a2] = Rate_estimation_pk(xb,fs,type,blechar)
xc = hampel(xb(:,:),2,1)-mean(xb(:,:));% Static components removal
T=1/fs;  %Sample frequency
N1 = length(xc);
t = 0:T:(N1-1)*T; %采样时间

[ac, lag] = xcorr(xc);
min_dist = ceil(0.9*fs); % sec*fs represents least respiration gap
[pks, loc] = findpeaks(ac, 'MinPeakDistance', min_dist);

%% Average distance/frequency from acf
avg_dt = mean(gradient(loc))*T;
avg_acf = 1/avg_dt;
% 
% % subplot(211);
% 
% plot(lag*T, ac);
% hold on
% grid on
% plot(lag(loc)*T, pks, 'xr');
% title(sprintf('ACF - Average frequency of %s : %.2f Hz',type, avg_acf));
% hold off
%% Simple peak finding in time domain
%[pkst, loct] = findpeaks(xb, 'MinPeakDistance', min_dist, 'MinPeakHeight', 0.5*max(xb));
% 
[pkst, loct] = findpeaks(xc,'MinPeakHeight', 0.1*(max(xc)-min(xc)));
avg_dt2 = mean(gradient(loct))*T;
avg_pd = 1/avg_dt2;
% avg_acf = 0;
% avg_pd = 0;

% avg_fft = FFT_estimation(xc,fs);
name1 = [num2str(avg_pd),'Hz (',num2str(60*avg_pd),'bpm) of Measurement'];

% figure;
% etime = length(xc)/fs;
% T=1/fs;  %Sample frequency
% N1 = length(xc);
% t = 0:T:(N1-1)*T; %采样时间

if type == 'h'
    plot(t,xc(:,:),'r','LineWidth',3);
    ylabel('Magnitude');  xlabel('Time (s)');
    %xlim([0,max(t)]);
    xlim([0,10]);
    grid on;
    title('Real-time heartbeat signal');

    ref_freq = Heartdetect(blechar)/60;
    name2 = [num2str(ref_freq),'Hz (',num2str(60*ref_freq),'bpm) of Reference'];
    dim = [.66 .24 .1 .2];
    a1 = annotation('textbox',dim,'String',name1,'FitBoxToText','on','Color','red');
    dim = [.67 .19 .1 .2];
    a2 = annotation('textbox',dim,'String',name2,'FitBoxToText','on');
    drawnow;

else
    if type == 'r'
        %% plot the signal
        plot(t,xc(:,:),'LineWidth',3);
        ylabel('Magnitude');  xlabel('Time (s)');
        % xlim([0,max(t)]);
        xlim([0,10]);
        grid on;
        title('Real-time respiration signal');
        
        ref_freq = readResp();
        name2 = [num2str(ref_freq),'Hz (',num2str(60*ref_freq),'bpm) of Reference'];
        dim = [.66 .72 .1 .2];
        a1 = annotation('textbox',dim,'String',name1,'FitBoxToText','on','Color','blue');
        dim = [.67 .67 .1 .2];
        a2 = annotation('textbox',dim,'String',name2,'FitBoxToText','on');
        drawnow;
    end
end

% subplot(311);
% plot(xc);
% title('Orignial CSI data')
% subplot(211);
% plot(t,xc);
% title('CSI data after preprocessing')

% subplot(212);
% 
% grid on
% plot(t,xc);
% hold on
% plot(loct*T, pkst, 'xr');
% xlabel('t [s]')
% ylabel('CSI Amplitude')
% title(sprintf('Peak search in time domain - Average frequency of %s: %.2f Hz', type, avg_pd))
% hold off
end

