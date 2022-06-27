clc;
clear;
fs = 25;
n = 4;
Wp = 2*[0.1 0.5]/fs; 
Ws = 2*[0.08 0.6]/fs;
Rp = 3;
Rs = 60;
[~,wn] = buttord(Wp,Ws,Rp,Rs);
[z,p,k] = butter(n,wn);
sos = zp2sos(z,p,k);
freqz(sos,256,fs);
title(sprintf('n = %d Butterworth Lowpass Filter',n));
[b,a]=butter(4,wn,'bandpass');
y_high=filter(b,a,x1);

