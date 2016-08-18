%ds09e06.m
% Adaptive Identifier
clear, clf
B=[0 1 2]; A=[1 -1 0.5];  % Plant transfer function
mu=0.01; % Adaptation stepsize
M=7;  % Order of adaptive FIR filter
b=zeros(M+1,1); % Initial guess of adaptive filter coefficients
x=zeros(1,M+1); % Initialize buffers for x[n]
w0=zeros(1,max(length(A),length(B))-1); % Zero initial condition
nf=400;  % Number of iterations
for n=1:nf
   xn=cos((n-1)*pi/10); x=[x(2:end) xn]; % Input to adaptive identifier
   [dn,w0] = filter(B,A,xn,w0);
   yn = x(end:-1:1)*b; % Output of adaptive identifier
   e(n) = dn-yn;  b = b + mu*e(n)*x(end:-1:1).';
end
T=0.01; t=[0:nf-1]*T; plot(t,abs(e))
title('Error signal |e(t)| for adaptive identifier')
