function [y_pass] = Pfilter(x1,side,fc,fs,class)
    wn=2*fc/fs;
    [b,a]=butter(class,wn,side);%保留频率高于fc的振动
    y_pass=filter(b,a,x1);
%     subplot(2,1,1);
%     plot(x1(:,1));
%     subplot(2,1,2);
%     plot(y_pass(:,1));
end

