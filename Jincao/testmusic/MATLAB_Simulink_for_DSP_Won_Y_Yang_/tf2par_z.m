function [BB,AA,K]=tf2par_z(B,A)
% z-Transfer function (Direct form) into Parallel form
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<3, IR=0; end  % For default, inverse z-transform style
EPS= 1e-8; %1e-6;
B= B/A(1); A= A/A(1); 
I= find(abs(B)>EPS); B= B(I(1):end);
if IR==0, [z,p,K]= residuez(B,A);  else  [z,p,K]= residue(B,A);  end     
m=1;  Np=length(p); N=ceil(Np/2);
for i=1:N
   if abs(imag(p(m)))<EPS % Real pole
     if m+1<=Np & abs(imag(p(m+1)))<EPS % Subsequent real pole
       if abs(p(m)-p(m+1))<EPS % Double pole
         BB(i,:)= [z(m)+z(m+1) -z(m)*p(m) 0]; 
         AA(i,:)= [1 -2*p(m) p(m)^2];  m=m+2;
        elseif m+2<=Np&abs(p(m+1)-p(m+2))<EPS %Next two poles are double
         BB(i,:)=[0 z(m) 0]; AA(i,:)=[0 1 -p(m)]; m=m+1; % Single pole 
        else
         BB(i,:)= [real([z(m)+z(m+1) -z(m)*p(m+1)-z(m+1)*p(m)]) 0]; 
         AA(i,:)= [1 real([-p(m)-p(m+1) p(m)*p(m+1)])];  m=m+2;
       end
      else 
       BB(i,:)=[0  z(m) 0]; AA(i,:)=[0  1 -p(m)]; m=m+1; % Single pole 
      end
    else % Two distinct real poles or Complex pole
     BB(i,:)= [real([z(m)+z(m+1) -z(m)*p(m+1)-z(m+1)*p(m)]) 0]; 
     AA(i,:)= [1 real([-p(m)-p(m+1) p(m)*p(m+1)])];  m=m+2;
   end
end 
if IR~=0, BB(:,2:3)= BB(:,1:2); end
