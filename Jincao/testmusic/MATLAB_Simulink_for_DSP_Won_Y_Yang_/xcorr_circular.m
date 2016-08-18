function phi=xcorr_circular(x,y,N)
% Circular (cyclic) correlation of x and y with period N 
if nargin<2, y=x; end
Nx = length(x); Ny = length(y);
if nargin<3, N=max(Nx,Ny); end
if Nx<N, x = [x zeros(1,N-Nx)]; elseif N<Nx, x = x(1:N); end
if Ny<N, y = [y zeros(1,N-Ny)]; elseif N<Ny, y = y(1:N); end 
for n=1:N,  phi(n) = x*y'/N; y = [y(N) y(1:N-1)];  end
