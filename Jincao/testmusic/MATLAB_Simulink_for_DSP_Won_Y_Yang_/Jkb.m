function [J,JJ]=Jkb(K,beta)
% The 1st kind of kth-order Bessel function like besselj(K,beta)
tmpk= ones(size(beta));
for k=0:K
   tmp= tmpk;  JJ(k+1,:)= tmp;
   for m=1:100
      tmp=-tmp.*beta.*beta/4/m/(m+k);
      JJ(k+1,:)= JJ(k+1,:)+tmp; % Eq.(P1.6.4)
      if norm(tmp)<0.001, break; end
   end
   tmpk=tmpk.*beta/2/(k+1);  
end 
J=JJ(K+1,:);
