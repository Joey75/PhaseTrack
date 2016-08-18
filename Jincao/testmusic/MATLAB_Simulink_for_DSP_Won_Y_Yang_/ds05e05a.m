%ds05e05a.m
% Example of digital Butterworth LPF design
clear, clf, format short e
Fs=5e4; T=1/Fs; % Sampling frequency and Sampling period
wp=2*pi*6000; ws=2*pi*15000; Rp=2; As=25; 
% Analog filter design and discretization through bilinear transformation
wp_p=prewarp(wp,T); ws_p=prewarp(ws,T); % Prewarp the edge frequencies
[Nb,wcb]=buttord(wp_p,ws_p,Rp,As,'s'); % Order, cutoff freq of analog BW LPF
[Bb,Ab]= butter(Nb,wcb,'s'); % num/den of analog BW LPF system ftn
[Bb_d0,Ab_d0]= bilinear(Bb,Ab,Fs) % Bilinear transformation
% Direct digital filter design
fp=wp*T/pi; fs=ws*T/pi; % Normalize edge freq into [0,1] (1: pi[rad/sample])
[Nb,fcb]= buttord(fp,fs,Rp,As) % Order of digital BW LPF
[Bb_d,Ab_d]= butter(Nb,fcb) % num/den of digital BW LPF system ftn
% Plot the frequency response magnitude
fn=[0:512]/512; W=pi*fn; % Normalized and digital frequency range
subplot(221), plot(fn,20*log10(abs(freqz(Bb_d,Ab_d,W))+eps))
% To check if the filter specifications are satisfied
hold on, plot(fp,-Rp,'o', fcb,-3,'r+', fs,-As,'rs')
axis([0 1 -60 5]), title('Butterworth LPF')
[SOS,Kc]= tf2sos(Bb_d,Ab_d) % Cascade form realization
[BBp,AAp,Kp]= tf2par_z(Bb_d,Ab_d) % Cascade form realization
