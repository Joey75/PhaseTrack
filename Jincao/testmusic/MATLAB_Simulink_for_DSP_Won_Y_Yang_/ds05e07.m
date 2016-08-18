%ds05e07.m 
% to design multiband FIR filters using fir1()/fir2()/firpm()
fn=[0:512]/512; W=fn*pi; % normalized and digital frequency ranges
N=30; M=N/2; % Filter order and its half
nn=[-M:M]; nn1=nn+M; % Duration of filter impulse response 
% Multi pass/stop-band filter using fir1()
ffe=[0.2 0.4 0.6 0.8]; % Band edge frequency vector
B_fir1_DC1=fir1(N,ffe,'DC-1'); % Tap coefficient vector 
G_fir1_DC1_mag=abs(freqz(B_fir1_DC1,1,W)); %Frequency response magnitude
subplot(421), stem(nn1,B_fir1_DC1)
subplot(422), plot(fn,G_fir1_DC1_mag)
% Multi stop/pass-band filter using fir1()
B_fir1_DC0=fir1(N,ffe,'DC-0'); % Tap coefficient vector 
G_fir1_DC0_mag=abs(freqz(B_fir1_DC0,1,W)); %Frequency response magnitude
subplot(423), stem(nn1,B_fir1_DC0)
subplot(424), plot(fn,G_fir1_DC0_mag)
% Multi pass/stop-band filter using fir2()
% Desired piecewise linear frequency response
ffd=[0 0.18 0.22 0.38 0.42 0.58 0.62 0.78 0.82 1]; % Band edges in pairs
GGd=[1 1    0    0    1    1    0    0    1    1];
B_fir2=fir2(N,ffd,GGd);  G_fir2_mag=abs(freqz(B_fir2,1,W)); 
subplot(425), stem(nn1,B_fir2)
subplot(426), plot(fn,G_fir2_mag, ffd,GGd,'k:')
% Multiband pass/stop filter using firpm()
B_firpm=firpm(N,ffd,GGd); % The number of frequency points must be even
B_firls=firls(N,ffd,GGd); % The number of frequency points must be even
G_firpm_mag=abs(freqz(B_firpm,1,W)); G_firls_mag=abs(freqz(B_firls,1,W));
subplot(427), stem(nn1,B_firpm), hold on, stem(nn1,B_firls,'r.')
subplot(428), plot(fn,G_firpm_mag, fn,G_firls_mag,'r-.', ffd,GGd,'k:')
