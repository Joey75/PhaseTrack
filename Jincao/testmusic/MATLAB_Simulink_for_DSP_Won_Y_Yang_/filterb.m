function [y,y0]=filterb(B, A, x, y0)
% Input:  x = [x(-NB+2),..,x(0),x(1),..,x(n)]: Past/future input 
%         y0= [y(-NA+2),..,y(-1)]: Past output 
% Output: y = [y(1),..,y(n)]: Output to the input [x(1),..,x(n)].
%         y0= [y(n-NA+2),..,y(n)]: Last output  
%          to be used for successive processing of the same filter
if  nargin<4,  y0=[];  end
NA= length(A);  A1=A; 
for i=1:NA, if A(i)==0, A1=A(i+1:NA); else break;  end;   end  
A=A1; NA=length(A); NB=length(B);  N=NA-1; Ny0= length(y0);  
if length(x)<NB,  x=[x zeros(1,NB-length(x))];  end
if Ny0<=N, y0= [zeros(1,N-Ny0) y0]; % Initial values of the output
 else  y0= y0(Ny0-N+1:Ny0); 
end
A1= A(NA:-1:2);   if A(1)~=1,  B= B/A(1); A1= A1/A(1);  end
for n= 1: length(x)-NB+1
   y(n)= B*x(n+NB-1:-1:n)';
   if NA>1,  y(n)= y(n)-A1*y0';  end
   y0= [y0(2:N) y(n)];
end
