function  [y,y0]=filterq_DF2t(B,A,x,y0,q,qs)
% Quantized filtering routine in Direct Form II transposed form
% Input:  x = Past/future input [x(-NB+2), ..,x(0),x(1),.., x(n)].  
%         y0= Past output [y(-NA+2),.., y(0)]. 
%         q/qs= Quanta for coefficient/signal quantization
% Output: y = Output of system to the input  [x(1),.., x(n)].
%         y0= Last output [y(n-NA+2),..,y(n)].  
%              to be used for successive processing of the same filter
if nargin<6,  qs=q;   end
NA=length(A); N=NA-1; % Order of filter
NB=length(B); NB1=NB-1; Ny0=length(y0);
y0=quant(y0,qs); % quantize the initial values of output
if Ny0<=N,  y0=[zeros(1,N-Ny0)  y0];  else   y0=y0(Ny0-N+1:Ny0); end
if A(1)~=1,  B= B/A(1);  A= A/A(1);  end
B=quant(B,q);  A=quant(A,q); % quantize the coefficients
w=filtic(B,A,fliplr(x(1:NB-1)),fliplr(y0)); % Initial conditions
x=quant(x(NB:end),qs,0,1); % quantize the input signals
min_NB_N=min(NB,N);
for n=1:length(x)
   y(n) = quant(w(1)+B(1)*x(n),qs,0,1); % quantize the output signals
   w(2:NB1) = w(2:NB1)+B(2:NB1)*x(n);  
   % quantize the intermediate signals
   w(1:N-1) = quant(w(2:N)-A(2:N)*y(n),qs,0,1); 
if NB<N+1, w(N) = quant(-A(NA)*y(n),qs,0,1);
    else    w(N) = quant(-A(NA)*y(n)+B(NB)*x(n),qs,0,1); 
   end
   y0 = [y0(2:N) y(n)];
end
