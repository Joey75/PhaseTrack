%ds08e07.m
% illustrates the use of Unscented Kalman filter (UKF) 
clear, clf
N=2; M=1;  % Numbers of states/measurements
sigma_w=0.2; Q=sigma_w^2*eye(N); % Plant noise covariance
sigma_v=0.1; R=sigma_v^2*eye(M); % Measurement noise covariance
f=@(x)[x(1)-0.2*x(2)^2; -0.1*x(1)*x(2)]; G=eye(N); % Nonlinear state eqs
h=@(x)sin(x(1)/2);  I=eye(N);    % Measurement equation
xh_p(:,1)=[0; 0]; mx=xh_p(:,1);  % Initial prediction
mxN=repmat(mx,1,N);  mx2N1 = [mx mxN mxN];
x(:,1) = xh_p(:,1) + [1; -1]; % Initial state with noise
e_p = x(:,1)-xh_p(:,1); e2_p(1) = e_p'*e_p; 
P_p = 10*eye(N);              % Initial prediction covariance
nf=100; nn=0:nf; nn1=[0:nf-1]; % Number of iterations
a=0.01; b=2; kappa=1e-3; 
c2=a^2*(N+kappa); lambda=c2-N; c=sqrt(c2); % Eq.(8.63)
wm = [lambda; 0.5+zeros(2*N,1)]/(N+lambda);  % Eq.(8.64)
wc = wm; wc(1) = wc(1)+1-a^2+b;  % Eq.(8.64)
Iw = eye(2*N+1)-repmat(wm,1,2*N+1); W = Iw*diag(wc)*Iw.'; % Eq.(8.65)
randn('state',0);
for n=1:nf
   xn = x(:,n);
   x(:,n+1) = f(xn) + sigma_w*G*randn(N,1); % Plant Eq.(8.61a)
   y(:,n) = h(xn) + sigma_v*randn(M,1);   % Measurements Eq.(8.61b)
   c_sqP_p = c*chol(P_p,'lower'); 
   Xp = [mx  mxN+c_sqP_p  mxN-c_sqP_p];   % Eq.(8.66)
   for k=1:2*N+1,  Yp(:,k)=h(Xp(:,k));  end  % Eq.(8.67)
   my = Yp*wm;  % Eq.(8.68)
   my2N1 = repmat(my,1,2*N+1);  Ye = Yp-my2N1;
   S = Ye*W*Ye.' + R; C = (Xp-mx2N1)*W*Ye.';   % Eq.(8.69)/(8.70)
   K = C/S;  % Eq.(8.71)
   xh_f(:,n) = xh_p(:,n) + K*(y(:,n)-my); % Eq.(8.72)
   P_f = P_p - K*S*K.'; % Eq.(8.73)
   mf=xh_f(:,n); mfN=repmat(mf,1,N); c_sqP_f=c*chol(P_f,'lower'); 
   Xf = [mf mfN+c_sqP_f mfN-c_sqP_f]; % Eq.(8.74)
   for k=1:2*N+1,  Xp(:,k)=f(Xf(:,k));  end  % Eq.(8.75)
   mx = Xp*wm;  xh_p(:,n+1) = mx;   % Eq.(8.76)
   mxN = repmat(mx,1,N);  mx2N1 = [mx mxN mxN]; Xpe = Xp-mx2N1;
   P_p = Xpe*W*Xpe.' + Q;  % Eq.(8.77)
   e_f = x(:,n)-xh_f(:,n);  e2_f(n) = e_f'*e_f;
   e_p = x(:,n+1)-xh_p(:,n+1);  e2_p(n+1) = e_p'*e_p;
end
subplot(311)
plot(nn,xh_p(1,:),'bx', nn1,xh_f(1,:),'ro', nn,x(1,:),'k-')
legend('xh_p[n]','xh_f[n]','x[n]')
subplot(312), plot(nn,e2_p,'-x', nn1,e2_f,':ro')
legend('e^2_p[n]','e^2_f[n]'), shg
