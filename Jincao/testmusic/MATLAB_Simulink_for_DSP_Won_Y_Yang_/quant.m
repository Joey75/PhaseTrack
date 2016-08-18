function x=quant(x,q,b_or_d,sat)
if nargin>2
  if b_or_d==1, q=2^q; elseif b_or_d==2, q=10^q; end
  if nargin>3,  x = min(sat-q,max(x,-sat));  end
end
[M,N]=size(x); % Row and Column size
for m=1:M
   for n=1:N,  x(m,n) = floor(x(m,n)/q+0.5)*q;  end
end 
