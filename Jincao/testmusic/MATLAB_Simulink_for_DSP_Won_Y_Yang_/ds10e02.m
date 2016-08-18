%ds10e02.m 
% to see the sampling rate conversion done by resample()
clear, clf
x = inline('sin(2*pi*300*t+pi/8)','t');
Fs=10000; Fs1=15000; % For sampling rate conversion from 10kHz to 15kHz
Ts=1/Fs; Ts1=1/Fs1; % Sampling intervals
T=1e-5; t=[0:100]*T; % Like a continuous time vector
nTs=[0:Ts:t(end)]; xn=x(nTs); % sampled every Ts seconds 
L=3; M=2; % Interpolation/Decimation factor for 15000/1000=3/2
x1n = resample(xn,L,M); % sampled every Ts1=M/L*Ts seconds
nTs1 = [0:length(x1n)-1]*Ts1; % Time vector for resampled version
% Alternative resampling using interp() and decimate() 
x2n = decimate(interp(xn,L),M); 
plot(t,x(t), nTs,xn,'o', nTs1,x1n,'rx', nTs1,x2n,'rs'), shg
