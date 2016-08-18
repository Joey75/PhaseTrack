function P=MUSIC_EV(y,Ns,f,opt)
% Spectral estimation Using MUSIC or EV (Eigenvector) method
% Inputs:  y   = A signal
%          Ns  = Signal subspace dimension
%          f   = Digital frequencies normalized to 1 (for pi)
%          opt = 'eig' for Eigenvector method
% Outputs: P   = Power spectrum vs. f 
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use
if nargin==3&&isnumeric(f)==0, opt=f; end
if nargin<3||(nargin==3&&isnumeric(f)==0)
  if norm(imag(y))<eps, f=[0:128]/128; else f=[0:255]/128;  end
end
M=2*Ns; X=corrmtx(y,M-1,'cov'); R=X'*X; % MxM Autocorrelation matrix
% Alternatively, phi = xcorr(y,y,'biased'); phi=phi((length(phi)+1)/2:end);
% R = toeplitz(phi(1:M)); % MxM Autocorrelation matrix
[V,Lam]=eig(R); 
[lambdas,idx]=sort(diag(Lam)); % Eigenvalues in ascending order
%[dmax,Nn] = max(diff(log10(lambdas+1e-3))); % Noise space dimension
Nn=M-Ns;  Vn = V(:,idx(1:Nn));  % Eigenvectors in the noise subspace
exp_jmW = exp(j*pi*f(:)*[0:M-1]); % NfxM matrix (Nf=length(f))
if exist('opt')==1&lower(opt(1))=='e' % EV method
  P = 1./(abs(exp_jmW*conj(Vn)).^2*(1./lambdas(1:Nn))); % Eq.(6.66b)
 else  % MUSIC method
  P = 1./sum(abs(exp_jmW*conj(Vn)).^2,2); % Eq.(6.66a)
end 
if size(f,1)==1, P=P.'; end
if nargout==0,  P_dB=10*log10(P); plot(f,P_dB,'r');  end
