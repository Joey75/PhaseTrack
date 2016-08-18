function z=conv_circular(x,y,N)
% Circular convolution z(n)= (1/N) sum_m=0^N-1 x(m)*y(n-m)
if nargin<3, N=min(length(x),length(y)); end
x=x(1:N); y=y(1:N); y_circulated= fliplr(y);
for n=1:N
   y_circulated= [y_circulated(N) y_circulated(1:N-1)]; 
z(n)= x*y_circulated'/N;
end 
