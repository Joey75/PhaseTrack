function [y,w]=filter_lat_nr(r, x, w) 
% Nonrecursive lattice filtering of input x to yield the output y
% w contains the past history of internal state ...,w(n-1),w(n)
N=length(r); % Order of lattice filter with reflection coefficients r
if  nargin<3,  w=[];  end
if  length(w)<N,  w=[zeros(1,N-length(w)) w];  end
r = r(:).';
for n=1:length(x)
   vi= x(n)+r*w(1:N)';  y(n)= vi; 
   for i=N:-1:1,  vi=vi-r(i)*w(i);  w(i+1)=w(i)+r(i)*vi;  end
   w(1)= x(n); 
end  
