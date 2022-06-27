n = 10;
f = 0.5;

[zb,pb,kb] = butter(n,2*pi*f,'s');
[bb,ab] = zp2tf(zb,pb,kb);
[hb,wb] = freqs(bb,ab,256);

[z1,p1,k1] = cheby1(n,3,2*pi*f,'s');
[b1,a1] = zp2tf(z1,p1,k1);
[h1,w1] = freqs(b1,a1,256);

[z2,p2,k2] = cheby2(n,30,2*pi*f,'s');
[b2,a2] = zp2tf(z2,p2,k2);
[h2,w2] = freqs(b2,a2,256);

[ze,pe,ke] = ellip(n,3,30,2*pi*f,'s');
[be,ae] = zp2tf(ze,pe,ke);
[he,we] = freqs(be,ae,256);

plot(wb/(2*pi),mag2db(abs(hb)))
hold on
plot(w1/(2*pi),mag2db(abs(h1)))
plot(w2/(2*pi),mag2db(abs(h2)))
plot(we/(2*pi),mag2db(abs(he)))
axis([0 4 -40 5])
grid
xlabel('Frequency (Hz)')
ylabel('Attenuation (dB)')
legend('butter','cheby1','cheby2','ellip')