%ds10_01_04_mstage.m
clear, clf
Fs=1000; Ts=1/Fs; % Sampling frequency and Sampling period
fps=[4/5 1]*50; % Edge frequencies of each band (excluding 0 and Fs/2)
ripples=[0.01 0.001]; % Maximum ripples allowable for pass/stop bands
M1=4; M2=2; M=M1*M2; % Down/Up-sampling factor
N=firpmord(fps,[1 0],ripples,Fs) % determine the adequate filter order
N=ceil(N/M/2)*M*2 % make filter length adaptable to decimate_polyphase()
h=firpm(N,[0 fps/(Fs/2) 1],[1 1 0 0],[1 1]); % design the filter H[z]
No_of_multiplications=(N+1)/M*2 % MPIS in polyphase form
 
% Make a test input signal with zeroed tail considering the group delay
tt1=[-50:50]*Ts; tt2=[51:250]*Ts;  tt=[tt1 tt2];
u1=sinc(2*pi*10*tt1)/20; u=[u1 zeros(size(tt2))]; % Original signal
 
% Single-stage multirate filtering
[y,H,lag]=decimate_polyphase(u,M,h); 
g=M*h; [x,G]=interpolate_polyphase(y,M,g);
L=min(length(u),length(x)); t=tt(1:L); Mt=tt([1:M:L]); LM=length(Mt);
subplot(411), stem(t,u(1:L),'.'), hold on
stem(Mt-lag*Ts,y(1:LM),'s:')
stem(t-lag*Ts,x(1:L),'r')  % for x by interpolating y
legend('Input signal u','Decimator output','Interpolator output')
axis([tt1([1 end]) -0.02 0.06])
% To plot the signal spectra and frequency response of decimation filter
f=[0:0.001:1]; W=pi*f; % Half digital frequency range
H_mag = abs(DTFT(h,W,0)); U_mag=abs(DTFT(u,W,-50));
Y_mag = abs(DTFT(upsample(y,M),W));
subplot(412), plot(f,U_mag,'k:', f,H_mag,'b', f,Y_mag,'m')
legend('Spectrum of input signal u','Freq Response of interpolator', ...
'Spectrum of decimator output')
 
% 2-stage multirate filtering
Fs1=Fs; fps1=[fps(1) 2/M1*(Fs1/2)-fps(2)]; % IFIR approach
N1=firpmord(fps1,[1 0],ripples,Fs1) % Decimation factor and filter order
h1 = firpm(N1,[0 fps1/(Fs1/2) 1],[1 1 0 0],[5 1]); % design H1[z]
Fs2=Fs/M1; fps2=fps;  
N2=firpmord(fps2,[1 0],ripples,Fs2) 
h2 = firpm(N2,[0 fps2/(Fs2/2) 1],[1 1 0 0],[5 1]); % design H2[z]
No_of_multiplications_2stage=((N1+1)/M1+(N2+1)/M1/M2)*2
[y1,H1,lag1]=decimate_polyphase(u,M1,h1);
[y2,H2,lag2]=decimate_polyphase(y1,M2,h2);
g2=M2*h2; [x2,G2]=interpolate_polyphase(y2,M2,g2);
g1=M1*h1; [x1,G1]=interpolate_polyphase(x2,M1,g1);
L=min(length(u),length(x1)); t=tt(1:L); Mt=tt([1:M:L]); LM=length(Mt);
subplot(413), stem(t,u(1:L),'.'), hold on
stem(Mt-(lag1+lag2*M1)*Ts,y2(1:LM),'s:','Markersize',5), 
stem(t-(lag1+lag2*M1+3.5)*Ts,x1(1:L),'r')  % M1=4, M2=2;
legend('Input signal u','Decimator2 output','Interpolator1 output')
axis([tt1([1 end]) -0.02 0.06])
% To plot the frequency responses of decimation filters and overall one
H1_mag = abs(DTFT(h1,W,0)); H2_mag = abs(DTFT(h2,W,0)); 
HM2_mag = abs(DTFT(h2,M1*W,0)); Y2_mag = abs(DTFT(y2,M*W,0));
H12_mag = H1_mag.*HM2_mag; 
subplot(414)
plot(f,H1_mag,'k-.', f,H2_mag, f,HM2_mag,'b:', f,H12_mag,'r')
legend('|H1(W)|','|H2(W)|','H2(M*W)','|H1(W)H2(M*W)'), shg
