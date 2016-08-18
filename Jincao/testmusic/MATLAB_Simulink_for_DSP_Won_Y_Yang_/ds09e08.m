%ds09e08.m
% Adaptive Interference Canceller
B=[0 1 -2]; A=[1 -1 0.5]; % Transfer function of noise path filter
mu=0.05; M=7; % Adaptation stepsize and Order of adaptive FIR filter
b=zeros(M+1,1); % Initial guess of adaptive filter coefficients
x=zeros(1,M+1); w0=zeros(1,max(length(A),length(B))-1); 
make_ecg; nf=200; % A pseudo ECG signal ecg and Number of iterations
for n=1:nf
   noise=sin((n-1)*pi/4); x=[x(2:end) noise]; % Input to adaptive filter
   [vn,w0] = filter(B,A,noise,w0); % filtered noise
   s(n)=ecg(n); % Information bearing signal like a pseudo ECG signal
   dn = s(n)+vn; % Noisy information bearing signal as Desired signal 
   yn = x(end:-1:1)*b; % Output of adaptive filter
   e(n) = dn-yn;  b = b + mu*e(n)*x(end:-1:1).';
end
T=0.01; t=[0:nf-1]*T; stairs(t,s), hold on, stairs(t,e,'r') 
