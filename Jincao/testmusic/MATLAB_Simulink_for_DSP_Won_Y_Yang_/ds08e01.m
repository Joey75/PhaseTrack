%ds08e01.m: Kalman Filter application for the case of uncorrelated noise
clear, clf
A=0.9; B=0; G=0.8; C=1; % System/Input/Noise/Measurement matrices
sigma_w=0.6; N=size(A,1); Q=sigma_w^2*eye(N); % Plant noise covariance
sigma_v=0.4; M=size(C,1); R=sigma_v^2*eye(M); % Measurement noise cov
I=eye(size(A)); P0=5*I; P_p=P0; % Initial prediction error covariance
xh_p(:,1)=0;  x(:,1)=xh_p(:,1)+2; % Initial state prediction with error=2
e_p=x(:,1)-xh_p(:,1); e2_p(1)=e_p'*e_p; % Initial squared prediction error
nf=100; nn=[0:nf]; nn1=[1:nf]; 
for n=1:nf
   x(:,n+1) = A*x(:,n) + sigma_w*randn(N,1); % Eq.(E8.1.1a)
   y(:,n) = C*x(:,n) + sigma_v*randn(M,1);  % Eq.(E8.1.1b)
   K = P_p*C'/(C*P_p*C'+R); % Eq.(8.27) or (8.31a)
   xh_f(:,n) = xh_p(:,n) + K*(y(:,n)-C*xh_p(:,n)); % Eq.(8.26a)
   e_f=x(:,n)-xh_f(:,n); e2_f(n)=e_f'*e_f; % Filtering error
   P_f = (I-K*C)*P_p; % Eq.(8.26b)
   xh_p(:,n+1) = A*xh_f(:,n); % Eq.(8.28a)
   P_p = A*P_f*A' + G*Q*G'; % Eq.(8.28b)
   e_p=x(:,n+1)-xh_p(:,n+1); e2_p(n+1)=e_p'*e_p; % Prediction error
end
p=roots([C*C' -(A*R*A'+C*G*Q*G'*C'-R) -G*Q*G'*R]); % Eq.(E8.1.3)
P_s=p(find(p>0)); % Positive definite solution of ARE (Eq.(E8.1.4))
K_s=P_s*C'/(C*P_s*C'+R); % Steady-state Kalman gain Eq.(8.33)
[K_dlqe,P_ps,P_fs,E]=dlqe(A,G,C,Q,R); %Discrete Linear Quadratic Estimator
[P_dare,Eigs,L_dare]=dare(A',C',G*Q*G',R); % Discrete-time ARE
Pp__Pf__Pp_Eq_E8_1_4__Pp_dlqe__Pf_dlqe__P_dare= ...
[P_p,P_f,P_s,P_ps,P_fs,P_dare]
K__K_Eq_8_33__K_dlqe__AinvL_dare=[K,K_s,K_dlqe,A\L_dare.']
subplot(311)
plot(nn,xh_p,'bx', nn1,xh_f,'ro', nn,x,'k-')
legend('xh_p[n]','xh_f[n]','x[n]')
subplot(312)
plot(n,e2_p,'-x', nn1,e2_f,':ro'), legend('e2_p','e2_f'), shg
T=0.01; tf=(nf-1)*T; sim('ds08e01_sim',tf)
