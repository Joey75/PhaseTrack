function [y,w]=filterq_lat_r(r,p,x,w,q) 
% Quantized recursive lattice filtering the input x 
%   to yield the output y and update w
% w contains the past history of internal state ..,w(n-1), w(n)
r = quant(r,q);  p = quant(p,q); % Coefficient quantization
N= length(r); % Order of the lattice filter
Lw=length(w); if Lw<N,  w=[zeros(1,N-Lw) w];  end
for n=1:length(x)
   vi=quant(x(n),q,0,1); % Current Input quantization
   for i=N:-1:1
      %vi = quant(vi-r(i)*w(i),q,0,1);  % This seems to be right.
      vi = vi-r(i)*w(i);  viq = quant(vi,q,0,1);
      w(i+1) = quant(w(i)+r(i)*viq,q,0,1); % Signal quantization
   end
   w(1)= quant(vi,q,0,1);  
   y(n)= quant(p(:).'*w(:),q,0,1); % Output quantization
end
