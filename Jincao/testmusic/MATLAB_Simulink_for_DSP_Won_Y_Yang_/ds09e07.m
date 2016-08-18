%ds09e07.m
% Adaptive Equalizer - Inverse Filter
clear, clf
B=[0 1 2]; A=[1 -1 0.5];  % Plant transfer function
mu=0.01; % Adaptation stepsize
D=1; M=7; % Delay and Order of adaptive FIR filter
b=zeros(M+1,1); % Initial guess of adaptive filter coefficients
s=zeros(1,D+1); x=zeros(1,M+1); % Initialize buffers for s[n] and x[n]
w0=zeros(1,max(length(A),length(B))-1);  
randn('seed',0)
nf=201;  % Number of iterations
for n=1:nf
   sn=cos((n-1)*pi/10);  s=[s(2:end) sn];  dn=s(end-D); 
   [vn,w0] = filter(B,A,sn,w0); % Output from plant
   xn = vn + 0.1*randn;  x=[x(2:end) xn]; % Input to adaptive filter
   yn = x(end:-1:1)*b; % Output of adaptive equalizer
   e(n) = dn-yn;  b = b + mu*e(n)*x(end:-1:1).';
end
T=0.01; t=[0:nf-1]*T; stairs(t,abs(e))
title('Error signal |e(t)| for adaptive identifier')
sim('ds09e07_sim',t(end))
