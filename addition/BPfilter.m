function [y_high] = BPfilter(x1,fs,inside, outside)
    Wp = 2*inside/fs; %����Wp1-Wp2֮����ͨ��
    Ws = 2*outside/fs; %����0-Ws1,Ws2-������֮�������
    Rp = 3;
    Rs = 10;
    [~,wn] = buttord(Wp,Ws,Rp,Rs);
    %[z,p,k] = butter(n,wn);
    %sos = zp2sos(z,p,k);
    %freqz(sos,512,fs);
%    title(sprintf('n = %d Butterworth Lowpass Filter',n));
    [b,a]=butter(4,wn,'bandpass');
    y_high=filter(b,a,x1);
%     subplot(2,1,1);
%     plot(x1);
%     subplot(2,1,2);
%     plot(y_high);
    
end

