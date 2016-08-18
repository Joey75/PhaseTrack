%test_filtering.m
[x,Fs]=wavread('melody.wav'); 
N=2^17; x=x(end-N+1:end,1).'; % convert into row vector 
soundsc(x,Fs); 
Ts=1/Fs; t=(0:N-1)*Ts;  nn=1:N/32; tt=t(nn); % time vector
subplot(4,2,1), plot(tt,x(nn)), axis([tt([1 end]) -2 2])
xlabel('time[s]'), ylabel('signal x[n]')
X=fftshift(fft(x,N)); X_mag=20*log10(abs([X X(1)]));
f=(-N/2:N/2)*(Fs/N); fkHz=f/1000; % frequency vector
subplot(4,2,2), plot(fkHz,X_mag), axis([-5 5 -40 100])  
xlabel('f[kHz]'), ylabel('20*log10|X(k)|[dB]')
% Add a High Frequency Noise
omega=2*pi*3900*Ts; % convert 3.9 kHz into digital (DT) frequency 
%omega=2*pi*5000*Ts; % convert 5 kHz into digital (DT) frequency 
n=0:N-1; noise=0.5*cos(omega*n); xn = x + noise; 
soundsc(xn,Fs); 
subplot(4,2,3), plot(tt,xn(nn)), axis([tt([1 end]) -3 3])
xlabel('time[s]'), ylabel('noise-contaminated signal xn[n]')
Xn=fftshift(fft(xn,N)); Xn_mag=20*log10(abs([Xn Xn(1)]));
subplot(4,2,4), plot(fkHz,Xn_mag), axis([-5 5 -40 100]) 
xlabel('f[kHz]'), ylabel('20*log10|Xn(k)|[dB]')
% Butterworth LPF Design 
Rp=3; As=40; % Passband Ripple and Stopband Attenuation in dB 
fp=3600*Ts*2; fs=3900*Ts*2; % passband/stopband edge frequency  
[Nb,fcb]=buttord(fp,fs,Rp,As); [Bb,Ab]=butter(Nb,fcb);
H=fftshift(freqz(Bb,Ab,N,'whole')); 
H_mag=20*log10(abs([H; H(1)]));
subplot(4,2,6), plot(fkHz,H_mag), axis([-5 5 -100 5]) 
xlabel('f[kHz]'), ylabel('20*log10|H(k)|[dB]'),
% Filtering to remove the 10kHz noise  
xf=filter(Bb,Ab,xn);  
soundsc(xf,Fs);
subplot(4,2,7), plot(tt,xf(nn)), axis([tt([1 end]) -2 2])
xlabel('time[s]'), ylabel('filetred signal xf[n]')
Xf=fftshift(fft(xf,N)); Xf_mag=20*log10(abs([Xf Xf(1)]));
subplot(4,2,8), plot(fkHz,Xf_mag); axis([-5 5 -40 100])
xlabel('f[kHz]'), ylabel('20*log10|Xf(k)|[dB]'), shg
