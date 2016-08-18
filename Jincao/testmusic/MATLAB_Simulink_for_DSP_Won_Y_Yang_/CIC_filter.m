%CIC_filter.m
clear, clf
Fs=32000; Ts=1/Fs;   % Original sample frequency 32kHz
M=2;  Ts1=M*Ts;      % Decimation/Interpolation factor
D=1; N=2;           % Differential delay and Number of sections
G_decim = mfilt.cic?????(M,D,N); % Quantized CIC decimator object realizemdl(G_decim);
G_interp = mfilt.cic??????(M,D,N); % Quantized CIC interpolator object
realizemdl(G_interp);
n = 0:99;                    % 100 samples.
x = 0.25*sin(2000*pi*Ts*n);  % Original signal, sinusoid at 1 kHz.
% Decimator output
y_decim = filter(G_decim,x); 
% Scale the decimator output to overlay stem plots correctly.
y_decim=double(y_decim); % fixed-point to double-precision conversion
K1 = fi(1/max(abs(y_decim)),true,8,7);  y_decim = 0.25*K1*y_decim;
% Interpolator output
y_interp = filter(G_interp,y_decim); 
% Scale the decimator output to overlay stem plots correctly.
y_interp=double(y_interp); %fixed-point to double-precision conversion
K2 = fi(1/max(abs(y_interp))); 
y_interp = 0.25*K2*y_interp;
t = n(1:50)*Ts; x = x(1:50);  t1 = n(1:25)*Ts1;  
stem(t,x,'k'); hold on  % Plot the original signal and
delay1=N*(D/2*M)+1; delay2=2*delay1;
stem(t1-delay1*Ts,y_decim(1:25),'rx'); % Plot decimated signal
stem(t-delay2*Ts,y_interp(1:50),'s');  % Plot interpolated signal 
xlabel('Time[sec]'); ylabel('Signal Value');
