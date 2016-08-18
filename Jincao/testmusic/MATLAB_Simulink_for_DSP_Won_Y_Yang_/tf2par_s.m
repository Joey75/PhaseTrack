function [BB,AA,K]=tf2par_s(B,A)
% s-Transfer function (Direct form) into Parallel form
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
EPS= 1e-8; 
B= B/A(1); A= A/A(1); 
I= find(abs(B)>EPS); K= B(I(1)); B= B(I(1):end);
p= roots(A); p= cplxpair(p,EPS); Np= length(p);
NB= length(B); N= length(A); M= floor(Np/2);
for m=1:M
   m2= m*2; AA(m,:) = [1 -p(m2-1)-p(m2) p(m2-1)*p(m2)]; 
end
if Np>2*M
AA(M+1,:)= [0 1 -p(Np)]; % For a single pole
end
M1= M+(Np>2*M); b= [zeros(1,Np-NB) B]; KM1= K/M1;
% In case B(s) and A(s) has the same degree, we let all the coefficients 
%  of the 2nd-order term in the numerator of each SOS be Bi1=1/M1:
if NB==N, b= b(2:end); end
for m=1:M1
   polynomial = 1; m2=2*m;
   for n=1:M1 
      if n~=m, polynomial = conv(polynomial,AA(n,:)); end
   end
   if m<=M
     if M1>M, polynomial = polynomial(2:end); end  
     if NB==N, b = b - [polynomial(2:end)*KM1 0 0]; end
     Ac(m2-1,:) = [polynomial 0];  Ac(m2,:) = [0 polynomial];
    else 
     if NB==N, b = b - [polynomial(2:end)*KM1 0]; end
     Ac(m2-1,:) = polynomial;
   end
end
Bc = b/Ac; Bc(find(abs(Bc)<EPS)) = 0;
for m=1:M1
   m2= 2*m;
   if m<=M
     BB(m,:) = [0 Bc(m2-1:m2)]; if NB==N, BB(m,1) = KM1; end
    else
     BB(m,:) = [0 0 Bc(end)]; if NB==N, BB(m,2) = KM1; end
   end
end
