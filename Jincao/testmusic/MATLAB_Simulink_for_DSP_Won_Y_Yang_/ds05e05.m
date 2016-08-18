%ds05e05.m for digital filter design and frequency response plot
clear, clf, format short e
Fs=5e4; T=1/Fs; % Sampling frequency and sampling period
disp('(a) Digital Butterworth LPF')
wp=2*pi*6000; ws=2*pi*15000; Rp=2; As=25; 
fp=wp*T/pi; fs=ws*T/pi;
[Nb,fcb]= buttord(fp,fs,Rp,As) % Order of analog BW LPF
[Bb_d,Ab_d]= butter(Nb,fcb) % num/den of digital BW LPF system ftn
fn=[0:512]/512; W=pi*fn;
% Plot the frequency response magnitude curve
subplot(221), plot(fn,20*log10(abs(freqz(Bb_d,Ab_d,W))+eps))
[SOS,Kc]= tf2sos(Bb_d,Ab_d)  % Cascade form realization 
[BBp,AAp,Kp]= tf2par_z(Bb_d,Ab_d) % Parallel form realization 
disp('(b) Digital Chebyshev I BPF')
ws1=2*pi*6e3; wp1=2*pi*1e4; wp2=2*pi*12e3; ws2=2*pi*15e3; Rp=2; As=25;
fp=[wp1 wp2]*T/pi; fs=[ws1 ws2]*T/pi; %Normalize edge freq into [0,1]
[Nc1,fcc1]=cheb1ord(fp,fs,Rp,As) % Order & critical passband edge freq
[Bc1_d,Ac1_d]= cheby1(Nc1,Rp,fcc1) % num/den of D-C1 BPF system ftn
% ... To be completed by the readers ...
