function [y,w]=filter_lat_r(r,p,x,w) 
% Recursive lattice filtering of input x to yield the output y 
% w contains past history of internal state .., w(n-1), w(n) 
N= length(r); % Order of the lattice filter
if nargin<4,  w=[];  end
if length(w)<N,  w=[zeros(1,N-length(w)) w];  end
for n=1:length(x)
   vi=x(n); % Current Input 
   for i=N:-1:1, vi=vi-r(i)*w(i); w(i+1)=w(i)+r(i)*vi; end % Eq.(4.4)
   w(1)= vi;   y(n) = p(:).'*w(:);  % Eq.(4.6)
end  
