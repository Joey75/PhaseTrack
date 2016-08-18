function  [y,y0]=filterbq(B, A, x, y0, q)
%Quantized Block Filtering routine
% Input:  x = [x(-NB+1),..,x(0),x(1),..,x(n)]: Past/future input 
%         y0= [y(-NA+1),..,y(-1)]: Past output 
%         q = LSB value (Quantum) for quantization
% Output: y = [y(0),y(1),..,y(n)]: Output to the input [x(0),.., x(n)].
%         y0= [y(n-NA+1),..,y(n)]: Last output  
%         to be used for successive processing of the same filter
if  nargin<5,  q=1/128;  end
if  nargin<4,  y0=[];  end
NA= length(A);  N= NA-1; % the order of filter
NB= length(B);  Ny0= length(y0);
if length(x)<NB
 error('...needs more input including its past history!');
end
y0= quant(y0,q);
if Ny0<=N % Initial values of the output
  y0= [zeros(1,N-Ny0)  y0]; 
 else  y0= y0(Ny0-N+1:Ny0); 
end
A1= A(NA:-1:2);   if A(1)~=1,  B= B/A(1);  A1= A1/A(1);  end
B= quant(B,q);  A1= quant(A1,q); % Coefficient quantization
for n=1:length(x)-NB+1
   tmp=0;
   for nB=1:NB
      x1=quant(x(NB-nB+n),q); % Input quantization
      tmp= tmp+quant(B(nB)*x1,q); % Product quantization
   end
   for nA=1:N, tmp=tmp-quant(A1(nA)*y0(nA),q); end % Product quantization
   y(n)=quant(tmp,q);  y0 = [y0(2:N) y(n)]; % Output quantization
end
