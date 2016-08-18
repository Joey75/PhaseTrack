function [phi,lags]=xcorr_my(x,y,opt)
% Crosscorrelation of x and y as phi(1:Nx+Ny-1) by Eq.(3.5) or (3.7)
if nargin<3, opt='reg'; if nargin<2, y=x; end, end
Nx=length(x); Ny=length(y); N=max(Nx,Ny);
x=x(:).'; y=y(:).'; % To make them row vectors
for n=1:Nx-1
   N1=min(Nx-n,Ny); m=1:N1; phi(n+Ny)= x(m+n)*y(m)'; % (3.9a)
   if opt(1:3)=='unb', phi(n+Ny)= phi(n+Ny)/N1; end % Unbiased (3.7a)
end
for n=1-Ny:0
   N2=min(Nx,Ny+n); m=1:N2; phi(n+Ny)= x(m)*y(m-n)'; % (3.9b)
   if opt(1:3)=='unb', phi(n+Ny)= phi(n+Ny)/N2; end % Unbiased (3.7b)
end
if opt(1)=='b', phi= phi/N; % Biased correlation (3.5)
 elseif opt(1)=='c', phi=phi/sqrt((x*x')*(y*y')); % Coefficient (3.10)
end
lags=[-(Ny-1):(Nx-1)]; % The corresponding time index vector
