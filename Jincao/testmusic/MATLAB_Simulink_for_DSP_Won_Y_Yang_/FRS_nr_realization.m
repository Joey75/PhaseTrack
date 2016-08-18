function B=FRS_nr_realization(Gd,N,sym,ftype)
% Nonrecursive FRequency Sampling Filter with linear-phase characteristic
% {Gd(k),k=1:floor(N/2)+1}: Desired mag response each at (2k-(3-ftype))pi/N
% N         : Length of FRS filter with order N-1
% sym=0/-1  : Symmetric/Anti-Symmetric Impulse Response - No HPF/LPF 
% ftype=1/2 : Type 1/2 Nonrecursive FRS Filter (see Problem 4.4)
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<4, ftype=1; end
if nargin<3|Gd(1)>0.01, sym=1; end
Nodd = (N~=floor(N/2)*2); Neven = 1-Nodd;  % 1/0 if N=even/odd
if length(Gd)<floor(N/2)+Neven, error('Length of Gd must be >=N/2+1!'); end 
if sym<0&Gd(end)>0.01&Neven==1,  N=N+1; Neven=0;  end
MA=(N-1)/2;  N1=floor((N+1)/2);  M=N1-1;
if ftype==1  % Type 1 FRS filter coefficients 
  if sym>=0  % with +ve symmetry 
    for n=0:M  % Eq.(4.52a)
      B(n+1) = Gd(1); 
      for k=1:M, wk=2*pi*k/N; B(n+1)=B(n+1)+2*Gd(k+1)*cos(wk*(n-MA)); end
      B(n+1) = B(n+1)/N;
    end
   else  % with -ve (anti-)symmetry 
    for n=0:M  % Eq.(4.52b)
      B(n+1) = Neven*Gd(N1+1)*sin(pi*(MA-n)); % for N:even only 
      for k=1:M, wk=2*pi*k/N; B(n+1)=B(n+1)+2*Gd(k+1)*sin(wk*(MA-n)); end
      B(n+1) = B(n+1)/N; % Gd(1) must be zero for sym=-1
    end
  end
 else % if ftype>1 (Type 2 FRS filter coefficients)
  if sym>=0  % with +ve symmetry 
    for n=0:M
      B(n+1) = Nodd*Gd(M+1)*cos((n-MA)*pi);
      for k=0:M-Nodd, B(n+1)=B(n+1)+2*Gd(k+1)*cos((2*k+1)*(n-MA)*pi/N); end
      B(n+1)= B(n+1)/N;
    end
   else  % with -ve (anti-)symmetry */
    MA = N/2;
    for n=0:M
      B(n+1) = -Nodd*Gd(M+1)*sin(((n-MA)/N+0.5)*pi);
      for k=0:M-Nodd, B(n+1)=B(n+1)-2*Gd(k+1)*sin((2*k+1)*(n-MA)*pi/N); end
      B(n+1)= B(n+1)/N;
    end
  end
end
for i=0:N1-1
   if sym>=0, B(N-i)=B(i+1); else B(N-i)=-B(i+1); end % (Anti-)Symmetry 
end
if Nodd==1&sym<0, B(N1)=0; end
