%ds08e02.m
% Kalman Filter application for Example 8.2 with correlated noise.
clear, clf
A=0.9; G=1; C=1; H=0.5; % System matrices
sigma_w=0.6; N=size(A,1); Q=sigma_w^2*eye(N); % Plant noise covariance
sigma_v=0.4; M=size(C,1); R=sigma_v^2*eye(M); % Measurement noise cov
S=Q*H'; Ro=H*Q*H'+R; F=G*S/Ro; Ao=A-F*C; Qo=Q-S/Ro*S'; I=eye(N);
P_p=5*I;  % Initial prediction error covariance
xh_p(:,1)=0; % Initial state prediction
x(:,1)=xh_p(:,1)+2; % Initial state
e_p=x(:,1)-xh_p(:,1); e2_p(1)=e_p'*e_p; % Initial prediction error
nf=100;  nn=[0:nf]; nn1=[0:nf-1];
for n=1:nf
   w=sigma_w*randn(N,1); x(:,n+1) = A*x(:,n) + G*w; % Eq.(E8.2.1a)
   y(:,n) = C*x(:,n) + H*w + sigma_v*randn(M,1); % Eq.(E8.2.1b)
   K = P_p*C'/(C*P_p*C'+Ro); % Eq.(8.37)
   xh_f(:,n) = xh_p(:,n) + K*(y(:,n)-C*xh_p(:,n)); % Eq.(8.36a)
   e_f=x(:,n)-xh_f(:,n); e2_f(n) = e_f'*e_f; % Filtering error
   P_f = (I-K*C)*P_p; % Eq.(8.36b)
   L=(A*P_p*C'+G*S)/(C*P_p*C'+Ro); ALC=A-L*C; % Eq.(8.42)
   xh_p(:,n+1) = ALC*xh_p(:,n) + L*y(:,n); % Eq.(8.41)
   P_p = ALC*P_p*ALC'+G*Q*G'+L*Ro*L'-G*S*L'-L*S*G'; % Eq.(8.43)
   e_p=x(:,n+1)-xh_p(:,n+1); e2_p(n+1)=e_p*e_p'; % Prediction error
end
[K_dlqew,P_ps,P_fs]=dlqew(A,G,C,H,Q,R); % Discrete LQ estimator correlated
[P_dare,Eigs,L_dare]=dare(A',C',G*Q*G',Ro,G*S); % Discrete-time ARE
Pp__Pf__Pps_dlqew__Pfs_dlqew__P_dare=[P_p,P_f,P_ps,P_fs,P_dare]
K__L__AK_dlqew__L_dare=[K,L,A*K_dlqew,L_dare.']
subplot(311), plot(nn,xh_p,'bx', nn1,xh_f,'ro', nn,x,'k-')
legend('xh_p[n]','xh_f[n]','x[n]'), shg
subplot(312), plot(nn,e2_p,'b-x',nn1,e2_f,'ro:')
legend('e^2_p','e^2_f')
T=0.01; tf=(nf-1)*T; sim('ds08e02_sim',tf)
