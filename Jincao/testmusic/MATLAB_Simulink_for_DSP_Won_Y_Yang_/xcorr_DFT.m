function [phi_xy,lags]=xcorr_DFT(x,y,N,KC)
% To compute the correlation phi_xy between x[n] and y[n] by using DFT-IDFT
Nx=length(x); Ny=length(y);
if nargin<4,  KC = 0;  end
if nargin<3|isempty(N),  LOG2N=nextpow2(Nx+Ny-1); N=pow2(LOG2N);  end
X = fft(x,N); Y = fft(y,N); % N-point DFT
phi_xy_DFT = ifft(X.*conj(Y)); % Eq.(3.55): N-point IDFT
phi_xy = rotate_r(phi_xy_DFT,Ny-1); % Right-rotate by (Ny-1) after DFT
if KC>0 % to check if it conforms with other methods like xcorr() 
  X1 = fft([zeros(1,Ny-1) x],N); % Shift right x[n] by (Ny-1) before DFT
  phi_xy1 = ifft(X1.*conj(Y)); % Eq.(3.55): N-point IDFT
  Discrepancy1 = norm(phi_xy-phi_xy1)
  Discrepancy2 = norm(phi_xy(1:Nx+Ny-1)-xcorr(x,y))
end
lags = -(Ny-1):Nx-1;  phi_xy = phi_xy(Ny+lags);
if nargout==0, stem(lags,real(phi_xy));  end
