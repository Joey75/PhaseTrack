%ds03e02.m
% Autocorrelation of a noisy single-tone signal for noise reducing effect
clear, clf
A=1; P=1; Noise_Amp=sqrt(12*P);  
M=32; Omega=2*pi/M; N=100;
m=1:3*N;
x(m) = A*sin(Omega*(m-N)) + Noise_Amp*(rand(size(m))-0.5); 
m=N:2*N-1;  nn=-(N-1):(N-1);
for n=nn
   phi_xx(n+N) = x(n+m)*x(m)'/N; % Eq.(3.4)
   psi_xx(n+N) = A^2/2*cos(Omega*n) + P*(n==0); % Eq.(E3.2.5)
end
subplot(221), plot(nn,x(nn+N),'k')
subplot(222), plot(nn,phi_xx,':', nn,psi_xx)
psi_xcorr = xcorr(x(m)); % Autocorrelation using xcorr() Eq.(3.9)
[psi_biased,lags] = xcorr(x(m),'biased'); % Biased correlation Eq.(3.5)
subplot(223), plot(lags,psi_biased), hold on
Discrepancy=norm(psi_biased-psi_xcorr/N) % Compare with Eq.(3.9)
[psi_unbiased,lags]=xcorr(x(m),'unbiased'); % Unbiased correlation (3.7)
subplot(224), plot(lags,psi_unbiased)
