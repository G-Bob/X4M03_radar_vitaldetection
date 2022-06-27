function FrequencyResponse_plot(xx,fs)
%xa = Pfilter(xx,'low',0.7,fs);
xa = xx;
N = length(xa);
dt = 1/fs;
t = 0:dt:((N-1)/fs);
T = t(end);
nfft=128;
%*********ACF*******************
%[f_pd,f_acf] = Rate_estimation(xx(:,subInd),fs);
%***********************方波的傅里叶变换************************************
%close;
%function [] = fftTest(x1,fs)
%xa = hampel(x2(500:,1),5,0.1);

%st = [ones(1,N_sample/2), -ones(1,N_sample/2)];%一个周期的方波
figure(3);

% PSD_csi(xa,nfft,fs);
% figure(4);

[f,sf] = DFT_T2F(t,xa);
% subplot(211);
% plot(t,xa);
% %axis([0 1 -2 end]);
% xlabel('t');
% ylabel('s(t)');
% subplot(212);
plot(f,abs(sf));
%hold on;
%axis([-10 10 0 10]);
xlim([0 2]);
xlabel('f');
ylabel('|S(f)|');

% %根据傅里叶变换计算得到的信号频谱相应的位置的抽样值
% sff = T^2*1i*pi*f*0.5.*exp(-1i*2*pi*f*T).*sinc(f*T*0.5).*sinc(f*T*0.5);
% plot(f,abs(sff),'r--')

%使用FFT函数计算信号的傅里叶变换
function [f,sf] = DFT_T2F(t,st)

dt = (t(2) - t(1));
T = t(end);
df = 1/T;
N = length(st);
f = -N/2*df:df:N/2*df-df;
sf = fft(st);
sf = T/N*fftshift(sf);
end

function [] = PSD_csi(xw,nfft,fs)
% Estimate PSD of the short-time segment
N = length(xw);
Sxw = fft(xw, nfft);
Sxdb = 20*log10(abs(Sxw(1:nfft/2))) - 10*log10(N);
% subplot(2,1,1);
% plot(xw); 
% 
% ylabel('Amplitude');  xlabel('Time (n)'); 
f = (0:nfft/2-1)*fs/nfft;%取前一半 后一半是翻转
%subplot(2,1,2);
plot(f, Sxdb);
ylabel('Magnitude (dB)');  xlabel('Frequency (Hz)');
%xlim([0 0.002]);
end
end