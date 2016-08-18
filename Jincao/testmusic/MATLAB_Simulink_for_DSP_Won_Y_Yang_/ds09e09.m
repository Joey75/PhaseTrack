%ds09e09.m
% RLS Adaptive Interference (Noise) Cancellation or Signal Enhancement
KC=1; % Set as 0/1 to use Eqs. (9.56)/(9.57) 
B=[0 1 -2]; A=[1 -1 0.5];  % Plant transfer function
alpha=1; % Forgetting factor
M=7; % Order of adaptive FIR filter
P=10*eye(M+1,M+1); % Initial P matrix
b=zeros(M+1,1); % Initial guess of adaptive filter coefficients
xT=zeros(1,M+1); % Initialize the information vector
w0=zeros(1,max(length(A),length(B))-1); % Zero initial condition
make_ecg; nf=200; % A pseudo ECG signal ecg and Number of iterations
for n=1:nf
   noise=sin((n-1)*pi/4); % Input to RLS interference canceller
   xT=[noise xT(1:end-1)]; % Update input history as information vector
   [vn,w0] = filter(B,A,noise,w0); % Filtered noise
   s(n) = ecg(n); % Information signal
   dn = s(n) + vn; % Desired signal
   if KC==0, P = (P-P*xT'*xT*P/(alpha+xT*P*xT'))/alpha; % Eq.(9.56a)
             K = P*xT';                                 % Eq.(9.56b)
    else     K = P*xT'/(alpha+xT*P*xT'); % Eq.(9.57a)
             P = (P-K*xT*P)/alpha;       % Eq.(9.57c)
   end
   e(n) = dn-xT*b; % Error signal to extract the information s[n]
   b = b + K*e(n); % Eq.(9.56c) or (9.57b)
end
T=0.01; t=[0:nf-1]*T; stairs(t,s), hold on, stairs(t,e,'r')
title('s(t) and e(t) for RLS adaptive interference canceller')
sim('ds09e09_sim',t(end))
