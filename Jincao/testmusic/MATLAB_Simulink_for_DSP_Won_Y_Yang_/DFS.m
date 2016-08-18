function [X,ph]=DFS(x,N,n0)
% N-point DFS/DFT of x[n] regarding the 1st sample as the n0-th one.
if nargin<3, n0 = 0; end
n=n0+[0:length(x)-1]; k=[0:N-1];
X= x*exp(-j*2*pi*n'*k/N); % Eq.(1.14)
if nargout==2, ph=angle(X); X=abs(X);  end
