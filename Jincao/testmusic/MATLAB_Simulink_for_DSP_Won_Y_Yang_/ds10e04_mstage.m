%ds10e04_mstage.m
clear, clf
Fs=1000; Ts=1/Fs; % Sampling frequency[Hz] and Sampling period
fp=40/(Fs/2);  % 40Hz
fs=50/(Fs/2);  % 50Hz
Rp=0.0436; % 0.0436dB=10^(0.0436/20)=1.005 (maximum passband ripple 0.005)
As=40;    % 40dB=10^(-40/20)=0.01 : Minimum stopband attenuation
M = 8;    % Decimation factor of 8
% To construct a decimator/interpolator design object 
%      with a 'DecimationFactor' of M.
Hfd = fdesign.decimator(M,'lowpass',fp,fs,Rp,As);  % Decimator
Hfi = fdesign.interpolator(M,'lowpass',fp,fs,Rp,As); % Interpolator
 
% Make a test input signal with zeroed tail considering the group delay
tt1=[-50:50]*Ts; tt2=[51:330]*Ts;  tt=[tt1 tt2];
u1=sinc(2*pi*10*tt1)/2; u=[u1 zeros(size(tt2))]; % Original signal

% Single-stage multirate filtering
Hm_decim = design(Hfd,'equiripple') % Design a Single-stage decimator
Hm_interp = design(Hfi,'equiripple') % Design a Single-stage interpolator
y = filter(Hm_decim,u);  % Single-stage decimator output
x = filter(Hm_interp,y); % Single-stage interpolator output
% Multistage multirate filtering
Hm_decim_multi=design(Hfd,'multistage') %Design a multistage decimator
Hm_interp_multi=design(Hfi,'multistage') %Design a multistage interpolator
y_multi = filter(Hm_decim_multi,u);  % Multistage decimator output
x_multi = filter(Hm_interp_multi,y_multi); % Multistage interpolator out
 
L=length(u); t=tt(1:L); Mt=tt([1:M:L]); LM=length(Mt);
subplot(411), stem(t,u(1:L),'k.'), hold on
stem(t-236*Ts,x(1:L),'s:'), stem(Mt-118*Ts,y(1:LM),'r')
% 118 is the group delay found from the 'Analysis' pulldown menu and 
% 236 is the filter order seen in the filter information box of the window 
% opened by typing fvtool(Hm_decim) or importing the filter object
%  from the workspace into the FDATool.
legend('Input signal u','Interpolator output','Decimator output')
axis([tt1([1 end]) -0.2 0.6]), set(gca,'fonts',9)

subplot(412), stem(t,u(1:L),'.'), hold on
stem(t-277*Ts,x_multi(1:L),'s:'), stem(Mt-138.5*Ts,y_multi(1:LM),'r')
legend('Input signal u','Interpolator output','Decimator output')
axis([tt1([1 end]) -0.2 0.6]), set(gca,'fonts',9)

% To plot the frequency responses of the decimation filters
f=[0:0.001:1]; W=pi*f; % Half digital frequency range
subplot(413) 
Hm_decim_multi.Stage(1), Hm_decim_multi.Stage(3), Hm_decim_multi.Stage(3)
M1=2; M2=2; M3=2; % Decimation/Interpolation factor of each stage
h1=Hm_decim_multi.stage(1).numerator; H1_mag=abs(DTFT(h1,W));
h2=Hm_decim_multi.stage(2).numerator; H2_mag=abs(DTFT(h2,M1*W));
h3=Hm_decim_multi.stage(3).numerator; H3_mag=abs(DTFT(h3,M1*M2*W));
H123_mag = H1_mag.*H2_mag.*H3_mag;
plot(f,H1_mag, f,H2_mag,'r', f,H3_mag,'m', f,H123_mag,'k:')
legend('|H1(W)|','|H2(M1*W)|','|H3(M1*M2*W)|','|H1(W)H2(M1*W)H3(M1*M2*W)|')
subplot(414), plot(f,20*log10(H123_mag)), axis([0 1 -82 3]), grid on
