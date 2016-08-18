%ds03e06.m : for Example 3.6
% Auto-Periodogram of a 2-Tone Signal
clear, clf
N=32; A1=2; A2=1; k1=5; k2=10; Om1=2*pi*k1/N; Om2=2*pi*k2/N;  
Nx=32;  n=0:Nx-1; % Length and Duration of signal data x[n]
x = A1*sin(Om1*n) + A2*cos(Om2*n); % x[n] Eq.(E3.6.1)
subplot(311), stem(n,x,'MarkerSize',5), xlabel('n'), ylabel('x[n]')
k=[0:N-1]; X=fft(x,N); Pxx=X.*conj(X)/N; % DFT and Periodogram (3.24)
subplot(312), stem(k,abs(X)), xlabel('k'), ylabel('|X(k)|')
set(gca,'xtick',[0 k1 k2 N/2 N-k2 N-k1 N-1],'fontsize',9)
subplot(313), stem(k,Pxx), xlabel('k'), ylabel('X(k)X^*(k)/N')
set(gca,'xtick',[0 k1 k2 N/2 N-k2 N-k1 N-1],'fontsize',9)
