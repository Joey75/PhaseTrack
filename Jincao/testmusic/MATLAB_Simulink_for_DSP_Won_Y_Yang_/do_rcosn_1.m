%do_rcosn_1.m 
% Raised-cosine impulse/frequency response in Fig. P2.6.1
clear, clf
r=0.5; pi2=pi*2; % Roll-off factor, etc
Ts=1; M=4; T=Ts/M; % Sampling interval (period) of filter output
Fd=1/Ts; Fs=Fd*M; % Sampling frequency of filter input/output
x=[1]; % Impulse input
% design a raised cosine filter and implement it by using rcosflt()
grc1=rcosflt(x,Fd,Fs,'fir',r).'; grc2=rcosflt(x,Fd,Fs,'iir',r).';
[Max,im]=max(grc1); N=im-1; 
nn=-N:N; tt=nn*T; N_nn=N*2+1; % Time range
Wc=pi/M; % Cutoff frequency of raised-cosine filter to be designed
n=nn+eps; 
grc=sinc(Wc*n/pi).*cos(n*r*Wc)./(1-(???????????).^2); % Eq.(P2.6.8)
W=[-32:32]*(pi/32); Grc = DTFT(grc,W,-N); % DTFT of grc[n]
subplot(221), stem(tt,grc1(1:N_nn),':ks'), hold on
stem(tt,grc2(1:N_nn),':rx'), stem(tt,grc)
r2=2*r; W1=(1-r)*Wc; W2=(1+r)*Wc;
for k=1:length(W)
   absWk=abs(W(k)); 
   if absWk<W1, Grc_theory(k)=M; % Eq.(P2.6.4a)
    elseif absWk<W2  % Eq.(P2.6.4b)
      Grc_theory(k)=M*(1+cos(pi/r2*(?????????????)))/2; 
    else Grc_theory(k)=0; %1e-5 to take the logarithm for dB scale
   end
end
subplot(222), plot(W,Grc_theory,'k', W,real(Grc),'-r+')
