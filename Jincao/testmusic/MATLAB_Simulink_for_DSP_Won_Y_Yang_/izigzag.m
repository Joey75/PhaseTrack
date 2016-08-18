function u = izigzag(v,M,N)
% returns the MxN matrix made of elements of vector v in zigzag order
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use 
lv=length(v); if nargin==1,  M=floor(sqrt(lv));  end
if nargin<3,  N=M;  end
MN=M*N;  Ms=num2str(M); Ns=num2str(N); s;
if lv~=MN, error(['Length of v must be MxN=' num2str(MN) '!']); end
m=1; n=1; u(m,n)=v(1);  d='r';
for i=2:M*N
   switch d
     case 'u',  m=m-(m>1); n=n+(n<N); u(m,n) = v(i);  
                if n==N,  d='d';  elseif m==1, d='r'; end
     case 'l',  m=m+(m<M); n=n-(n>1); u(m,n) = v(i);  
                if m==M, d='r'; elseif n==1, d='d'; end  
     case 'd',  m=m+(m<M); u(m,n) = v(i);   
                if n==1,  d='u';  else  d='l';  end
     case 'r',  n=n+(n<N); u(m,n) = v(i);
                if m==1,  d='l';  else d='u';  end
   end
end
