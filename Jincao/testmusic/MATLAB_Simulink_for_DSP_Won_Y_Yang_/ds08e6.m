%ds08e6.m
% illustrates the use of Extended Kalman filter (EKF) 
clear, clf
N=2; M=1;  % Numbers of states/measurements
sigma_w=0.2; Q=sigma_w^2*eye(N); % Plant noise covariance
sigma_v=0.1; R=sigma_v^2*eye(M); % Measurement noise covariance
f=@(x)[x(1)+x(2); -0.1*x(1)*x(2)]; G=eye(N); % Nonlinear state equation
h=@(x)sin(x(1)/2);  I=eye(N);                % Measurement equation
xh_p(:,1) = [0; 0];                      % Initial prediction
x(:,1) = xh_p(:,1) + [1; -1]; % Initial state with noise
e_p = x(:,1)-xh_p(:,1); e2_p(1) = e_p'*e_p; 
P_p = 10*eye(N);           % Initial prediction covariance
nf=100; nn=0:nf; nn1=[0:nf-1]; % Number of iterations
randn('state',0);
for n=1:nf
   xn = x(:,n);
   x(:,n+1) = f(xn) + G*randn(N,1)*sigma_w';
   y(:,n) = h(xn) + sigma_v*randn(M,1); % Measurement
   C = jacob(h,xh_p(:,n)); % Linearized measurement matrix Eq.(8.60b)
   K = P_p*C'/(C*P_p*C'+R); % Eq.(8.27)/(8.58)                        
   xh_f(:,n) = xh_p(:,n) + K*(y(:,n)-h(xh_p(:,n))); % Eq.(8.57a)
   e_f = x(:,n)-xh_f(:,n);  e2_f(n)=e_f'*e_f;
   P_f = (I-K*C)*P_p; % Eq.(8.26b)/(8.57b)
   xh_p(:,n+1) = f(xh_f(:,n)); % Eq.(8.59a)
   A = jacob(f,xh_f(:,n)); % Linearized system matrix Eq.(8.60a)
   P_p = A*P_f*A' + G*Q*G'; % Eq.(8.28b)/(8.59b)
   e_p = x(:,n+1)-xh_p(:,n+1); e2_p(n+1) = e_p'*e_p;
end
plot(nn,xh_p(1,:),'bx', nn1,xh_f(1,:),'ro', nn,x(1,:),'k-')
