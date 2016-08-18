%ds09e05.m
% Adaptive D-step-Ahead Predictor
clear, clf
D=4; M=7; % Delay and Order of adaptive FIR filter
mu=0.01; nf=400;  % Adaptation stepsize and Number of iterations 
b=zeros(M+1,1); % Initial guess of adaptive filter coefficients
s=zeros(1,D+1);  x=zeros(1,M+1); % Initialize buffers for s[n] and x[n]
for n=1:nf
   sn=cos((n-1)*pi/10);  s=[s(2:end) sn];  
   x=[x(2:end) s(end-D)]; % Input to adaptive predictor
   yn = x(end:-1:1)*b; % Output of adaptive predictor
   e(n) = sn-yn;  
   b = b + mu*e(n)*x(end:-1:1).';
end
T=0.01; t=[0:nf-1]*T; plot(t,abs(e))
sim('ds09e05_sim',t(end))
