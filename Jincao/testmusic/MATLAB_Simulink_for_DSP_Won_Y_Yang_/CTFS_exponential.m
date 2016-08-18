function [c,kk]=CTFS_exponential(x,P,N)
% Find the complex exponential Fourier coefficients c(k) for k=-N:N
% x: A periodic function with period P
% P: Period,  N: Maximum frequency index to specify the frequency range
w0=2*pi/P; % the fundamental frequency [rad/s]
xexp_jkw0t_= [x '(t).*exp(-j*k*w0*t)']; 
xexp_jkw0t= inline(xexp_jkw0t_,'t','k','w0');
kk=-N:N; tol=1e-6; % the frequency range tolerance on numerical error 
for k=kk 
  c(k+N+1)= quadl(xexp_jkw0t,-P/2,P/2,tol,[],k,w0); % Eq.(1.1a)
end
