%ds10_01_05_hband.m
clear, clf
% 4th-Band Nyquist filter design object
M=4; tbw=0.1; As=40; H4N=fdesign.nyquist(M,tbw,As); % Filter design object
% Nyquist M or 4th-band filter with transition bandwidth 0.1 & As 40dB
H_4Nyq=design(H4N,'equiripple'); % Filter object
h_4Nyq=H_4Nyq.Numerator; % Filter tap coefficients or impulse response
Lh=length(h_4Nyq); nn=-(Lh-1)/2+[0:Lh-1]; % Time vector
subplot(411), stem(nn,h_4Nyq,'.')
% To plot the signal spectra and frequency response of Nyquist 4 filter
f=[0:0.001:1]; W=pi*f; % Half digital frequency range
HW_4Nyq = DTFT(h_4Nyq,W,-(Lh-1)/2); 
HW_4Nyq1 = DTFT(h_4Nyq,W-2*pi/M,-(Lh-1)/2);
HW_4Nyq2 = DTFT(h_4Nyq,W-4*pi/M,-(Lh-1)/2);
HW_4Nyq3 = DTFT(h_4Nyq,W-6*pi/M,-(Lh-1)/2);
Sum_of_HW = HW_4Nyq+HW_4Nyq1+HW_4Nyq2+HW_4Nyq3; % Partial sum of Eq.(10.24)
subplot(412), plot(f,abs(HW_4Nyq), f,abs(HW_4Nyq1),':')
hold on, plot(f,abs(HW_4Nyq2),':', f,abs(Sum_of_HW),'r-.')
title('2k*pi-shifted freq responses of 4th Nyquist filter & their sum')
% Half-band filter
tbw=0.1; As=20; Hh=fdesign.halfband(tbw,As); % Filter design object
% Equiripple half-band filter with transition bandwidth 0.2 and As 20dB
H_half=design(Hh,'equiripple'); % Filter object
h_half=H_half.Numerator; % Filter tap coefficients or impulse response
Lh=length(h_half); nn=-(Lh-1)/2+[0:Lh-1]; % Time vector
subplot(413), stem(nn,h_half,'.')
% To plot the frequency response of the half-band filter
ff=[0:0.001:1]; W=pi*ff; % Half digital frequency range
HW_half = real(DTFT(h_half,W,-(Lh-1)/2));
subplot(414), plot(f,HW_half, f,fliplr(1-HW_half),'r'), hold on 
plot(ff([1 end]),[0.5 0.5],'k:'), plot([0 0.5 0.5 1],[1 1 0 0],'k:')
title('Frequency response of a Half-band filter')
