%ds09e03.m
Nx = 10000; % Number of data samples for computing R and p
a0=0.7;  a1=-0.1;  sigma=1/4;  noise_amp=sigma*sqrt(12);
noise = noise_amp*(rand(1,Nx)-0.5);
x(1)=noise(1); x(2)=a0*x(1)+noise(2);
sx2=x(1)^2+x(2)^2;  sx12=x(2)*x(1);  sx13=0;
for n=2:Nx-1
   x(n+1) = a0*x(n)+a1*x(n-1) + noise(n+1); % Eq.(E9.3.1)
   sx2=sx2+x(n+1)^2; sx12=sx12+x(n+1)*x(n); sx13=sx13+x(n+1)*x(n-1);
end
sx2 = sx2/Nx;  sx12 = sx12/(Nx-1); sx13 = sx13/(Nx-2);
R=[sx2 sx12; sx12 sx2]; p=[sx12; sx13]; % Eq.(E9.3.3) and (E9.3.4)
disp('Optimal coefficient vector'), bo = R\p  % Eq.(9.5)/(9.11)
b0=[1.5; -3.5]; % Initial guess of the optimal filter coefficient vector 
% LMS method
mu=0.05; r=0; bn = b0;
for n=2:2000
   x(n+1) = a0*x(n)+a1*x(n-1) + noise_amp*(rand-0.5); % Eq.(E9.3.1)
   b = bn; e = x(n+1) - x([n n-1])*b; % Error signal
   bn = (1-mu*r)*b + mu*e*x([n n-1])'; % Eq.(9.22)/(9.31)
   plot([b(1) bn(1)],[b(2) bn(2)],'r'), hold on
end
% Steepest descent method
mu=0.05; bn = b0;
for n=1:2000
   b = bn;  bn = b - mu*(R*b-p); % Eq.(9.15)
   plot([b(1) bn(1)],[b(2) bn(2)],'k'), hold on
end
% Newton method
mu=1; bn = b0;
for n=1:2
   b = bn;  bn = b - mu*R\(R*b-p); % Eq.(9.19)
   plot([b(1) bn(1)],[b(2) bn(2)],'b')
end
