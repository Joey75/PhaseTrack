function [Bc,Ac,B,A,N,sym]=FRS_realization(Gd,N,sym,r,ftype)
% Recursive FRequency Sampling Filter with linear-phase characteristic
% Input:
%  {Gd(k),k=1:floor(N/2)+1}: Desired mag response each at (2k-(3-ftype))pi/N
%  sym=0/-1 : Symmetric/Anti-Symmetric Impulse Response - No HPF/LPF
%  r        : Multiplying factor to push resonator poles inside unit circle
%  ftype=1/2: A zero at z=1 or not (see Problem 4.4)
% Output:
%  Bc/Ac    : Numerator/Denominator of the comb filter
%  B/A      : Numerator/Denominator matrices with each row for resonators
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<5, ftype=1; end
if nargin<4, r=1; end
if nargin<3|Gd(1)>0.01, sym=1; end
Neven = (N==floor(N/2)*2); % 1/0 if N=even/odd
if length(Gd)<floor(N/2)+Neven, error('Length of Gd must be >=N/2+1!'); end 
if sym<0&Gd(end)>0.01&Neven==1, N=N+1; Neven=0; end
if ftype>1,  ftype=-1;  end
Bc=[1 zeros(1,N-1)  -ftype*r^N];  Ac=N; % Comb Filter 
k0 = 0;
if ftype>0,  B(1,:)=[Gd(1)  0]; A(1,:)=[1  -r  0]; k0=k0+1;  end
M = floor((N-1)/2);
for k=1:M
   A(k+k0,:)= [1  -2*r*cos((2*k-(ftype<0))*pi/N)   r*r]; % Eq.(4.50)
   th1=(N-1)*pi*k/N; th2 = pi/N*((ftype<0)-k*(N+1)); 
   if sym<0,  th1=th1+pi/2; th2=th2+pi/2;  end  % In case of anti-symmetry
   B(k+k0,:) = 2*Gd(k+k0)*[cos(th1) -r*cos(th2)];
end
if (ftype<0|(Neven==1&length(Gd)>k0+M))
  B(k0+M+1,:)= [Gd(k0+M+1) 0];  A(k0+M+1,:)= [1  r  0];
end
