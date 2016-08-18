%ds10_01_04_ifir.m
clear, clf
Fs=1000; Ts=1/Fs; % Sampling frequency and Sampling period
fps=[7/8 1]*100; % Edge frequencies of each band (excluding 0 and Fs/2)
devs=[0.001 0.01]; % Maximum deviations or ripples allowable for each band
% design a (single-stage) filter with narrow transition bandwidth
N=firpmord(fps,[1 0],devs,Fs) % Order of FIR filter with desired freq resp
h=firpm(N,[0 fps/(Fs/2) 1],[1 1 0 0],[1 1]); % Parks-McClellan FIR filter
[hmax,ihmax]=max(h);
No_of_multiplications=length(h) % MPIS (multiplications per input sample)

% design M-fold upsampled filter and Image suppressor filter using ifir() 
M=4; % M must not be greater than 1/fstop=fps(2) (normalized to Fs/2)
[g_ups,g_ims]=ifir(M,'low',fps/(Fs/2),devs);
[g_imsmax,ig_imsmax]=max(g_ims); [g_upsmax,ig_upsmax]=max(g_ups);
% MPIS (multiplications per input sample) for IFIR
N_ims=length(g_ims), N_ups=length(g_ups)
No_of_multiplications_ifir=N_ims+ceil(N_ups/M) 

% Make a test input signal with zeroed tail considering the group delay
tt1=[-30:30]*Ts; tt2=[31:180]*Ts;  tt=[tt1 tt2];
u1=sinc(2*pi*10*tt1)/20; u=[u1 zeros(size(tt2))]; % A signal

% Time responses of single-stage/multistage filters
y = filter(h,1,u); % Single-stage filtering
y_ifir = filter(g_ups,1,filter(g_ims,1,u)); % Multistage filtering
% Multistage filtering to show the reduced computation
gT=downsample(g_ups,M).'; % pick up only nonzero tap coefficients
y_ifir1 = zeros(size(y_ifir));  u_buf=zeros(size(g_ups));
for n=1:length(u)
   u_buf = [u(n) u_buf(1:end-1)];
   y_ifir1 = [y_ifir1(2:end) downsample(u_buf,M)*gT];
end

t=[0:60]*Ts; % Time vector on which to plot the time responses with delay
subplot(511), stem(t,y(ihmax+1+[0:60]),'x'), hold on
stem(t,y_ifir(ig_imsmax+ig_upsmax+2+[0:60]),'rs')
stem(t-0.5*Ts,y_ifir1(ig_upsmax+2+[0:60]))
legend('Single-stage filter output y[n]','IFIR filter output y_{ifir}[n]', 'Simply computed y_{ifir}[n]')

% Frequency responses of single-stage/multistage filters 
f=[0:0.001:1]; W=pi*f; % Half digital frequency range
H_mag = abs(DTFT(h,W)); U_mag = abs(DTFT(u,W)); 
G_relaxed_mag = abs(DTFT(downsample(g_ups,M),W)); 
G_ims_mag=abs(DTFT(g_ims,W));  G_ups_mag=abs(DTFT(g_ups,W));
G_ims_G_ups_mag=G_ims_mag.*G_ups_mag;
subplot(512), plot(f,U_mag,'k:', f,H_mag)
legend('Input signal spectrum','Single-stage filter freq response H[z]')
subplot(513), plot(f,G_relaxed_mag)
legend('M-fold stretched (relaxed) version of H[z]')
subplot(514), plot(f,G_ims_mag, f,G_ups_mag,':')
legend('Impulse suppressor G_{ims}[z]','Upsampled filter G_{ups}[z]')
subplot(515), plot(f,G_ims_G_ups_mag,'r')
legend('Multistage filter frequency response G_{ims}[z]G_{ups}[z]')
