%ds05e01.m for analog filter design and frequency response plot
clear, clf, format short e
disp('(a) Butterworth LPF')
wp=2*pi*6000; ws=2*pi*15000; Rp=2; As=25; 
[Nb,wcb] = buttord(wp,ws,Rp,As,'s') % Order, Cutoff freq of analog BW LPF
[Bb,Ab] = butter(Nb,wcb,'s') % num/den of analog BW LPF system function
[SOS,K] = tf2sos(Bb,Ab); % Cascade realization [BBc,AAc]=tf2cas(B,A)
Ns=size(SOS,1); Gm=K^(1/Ns), BBc=SOS(:,1:3), AAc=SOS(:,4:6)
[BBp,AAp] = tf2par_s(Bb,Ab) % Parallel realization ? see Section F.15
f=[0:20:25000]; w=2*pi*f; % Frequency vector
subplot(221), plot(w,20*log10(abs(freqs(Bb,Ab,w))))
title('Butterworth LPF')
disp('(b) Chebyshev I BPF')
ws1=2*pi*6e3; wp1=2*pi*1e4; wp2=2*pi*12e3; ws2=2*pi*15e3; Rp=2; As=25; 
[Nc1,wpc] = cheb1ord([wp1 wp2],[ws1 ws2],Rp,As,'s')
[Bc1,Ac1] = cheby1(Nc1,Rp,wpc,'s')
[SOS,K] = tf2sos(Bc1,Ac1); % Cascade realization 
Ns=size(SOS,1); Gm=K^(1/Ns), BBc=SOS(:,1:3), AAc=SOS(:,4:6)
[BBp,AAp] = tf2par_s(Bc1,Ac1) % Parallel realization
subplot(222), plot(w,20*log10(abs(freqs(Bc1,Ac1,w))))
title('Chebyshev I BPF')
disp('(c) Chebyshev II BSF')
wp1=2*pi*6e3; ws1=2*pi*1e4; ws2=2*pi*12e3; wp2=2*pi*15e3; Rp=2; As=25; 
[Nc2,wsc] = cheb2ord([wp1 wp2],[ws1 ws2],Rp,As,'s')
% ... To be completed by the readers ...
