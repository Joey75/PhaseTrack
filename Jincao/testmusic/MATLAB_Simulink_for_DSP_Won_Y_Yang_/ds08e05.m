%ds08e05.m
% Kalman Filter application for Example 8.5 (Perfect Measurement).
clear, clf
% Reformulation of perfect measurement into correlated case
A=[0.8 -0.1; 0.1 0.6]; G=eye(size(A)); C=[1 1]; % System matrices
Q=[0.2 0.1; 0.1 0.2]; sgm_w1=sqrt(Q(1,1)-Q(1,2)); % Plant noise cov
sgm_w2=sqrt(Q(2,2)-Q(1,2)); sgm_w12=sqrt(Q(1,2)); % Measurement noise cov
D=[0  1]; M1M2=inv([C;D]); M1=M1M2(:,1); M2=M1M2(:,2:end); % Eq.(8.46)
CD_M1M2=norm([C;D]*[M1 M2]-eye(size(A))) % Check if [C;D]*[M1 M2]=I
A1=D*A*M2; B1=D*A*M1; 
G1=eye(size(A1)); C1=C*A*M2; D1=C*A*M1;
Q1=D*G*Q*G'*D'; S=D*G*Q*G'*C'; 
R1=C*G*Q*G'*C'; I=eye(size(A1));%Eq.(8.49)
P_p=10; % Initial prediction error covariance of q
xh_p(:,1)=[0; 0]; % Initial state
x(:,1)=xh_p(:,1)+[2; -2]; % Initial state prediction
qh_p(:,1)=D*xh_p(:,1); % Eq.(8.45) 
e_p=x(:,1)-xh_p(:,1); e2_p(1)=e_p'*e_p; % Initial prediction error
nf=100;  nn=[0:nf]; nn1=[0:nf-1];
for n=1:nf+1
   w12=sgm_w12*randn; w=w12+[sgm_w1*randn; sgm_w2*randn]; 
   x(:,n+1) = A*x(:,n) + G*w; % Eq.(E8.5.1a)
   y(:,n) = C*x(:,n);  % Eq.(E8.5.1b)
   if n>1
     K = P_p*C1'/(C1*P_p*C1'+R1); % Eq.(8.51)
     z(:,n) = y(:,n)-D1*y(:,n-1);
     qh_f(:,n-1) = qh_p(:,n-1) + K*(z(:,n)-C1*qh_p(:,n-1)); % Eq.(8.50a)
     xh_f(:,n-1) = M1*y(:,n-1) + M2*qh_f(:,n-1); % Eq.(8.47)
     e_f = x(:,n-1)-xh_f(:,n-1); e2_f(n-1) = e_f'*e_f;
     P_f = (I-K*C1)*P_p; % Eq.(8.50b)
     L = (A1*P_p*C1'+S)/(C1*P_p*C1'+R1);  % Eq.(8.53)
     ALC = A1-L*C1; 
     qh_p(:,n) = ALC*qh_p(:,n-1) + B1*y(:,n) + L*z(:,n); % Eq.(8.52)
     xh_p(:,n) = M1*y(:,n) + M2*qh_p(:,n); % Eq.(8.47)
     P_p = ALC*P_p*ALC' + Q1 + L*R1*L' - S*L' - L*S'; % Eq.(8.54)
     e_p = x(:,n)-xh_p(:,n); e2_p(n) = e_p'*e_p; 
   end
end
[P_dare,Eigs,L_dare]=dare(A1',C1',Q1,R1,S); % Discrete-time ARE
P_f__P_p__P_dare=[P_f,P_p,P_dare]
K__L__L_dare=[K,L,L_dare.']
subplot(311)
plot(nn,xh_p(1,:),'bx', nn1,xh_f(1,:),'ro', nn,x(1,1:nf+1),'k-')
legend('xh_p[n]','xh_f[n]','x[n]')
subplot(312)
plot(nn,e2_p,'bx-', nn1,e2_f,'ro:')
legend('e^2_p[n]','e^2_f[n]'), shg
