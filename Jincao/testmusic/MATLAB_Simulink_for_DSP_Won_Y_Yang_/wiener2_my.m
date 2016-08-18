function [u_wf,sigma2_global,mu,sigma2_est]=wiener2_my(u,Nm_Nn,sigma2)
% Space-variant Wiener_filtering with local window of size (Nm x Nn)
if nargin<2,  Nm_Nn=[3 3];  end
[M,N] = size(u); Nm=Nm_Nn(1); Nn=Nm_Nn(2);
if mod(Nm,2)==0, Nm=Nm+1; end;   if mod(Nn,2)==0, Nn=Nn+1; end 
Nm2=(Nm-1)/2; Nn2=(Nn-1)/2; NmNn=Nm*Nn;
u_aug = [zeros(Nm2,N+Nn-1); 
         zeros(M+Nm2,Nn2) [u; zeros(Nm2,N)] zeros(M+Nm2,Nn2)];
for m=1:M
   for n=1:N
      neighbors = u_aug(m:m+Nm-1,n:n+Nn-1);
      mu(m,n) = sum(sum(neighbors))/NmNn; % Eq.(11.12)
      sigma2_est(m,n) = sum(sum(neighbors.^2))/NmNn-mu(m,n)^2; % Eq.(11.13)
   end
end
if nargin>2 % with the 3rd input argument sigma2 (noise variance)
sigma2_global = sigma2; 
else  % without the 3rd input argument sigma2
 sigma2_global = mean2(sigma2_est); 
  sigma2_est = max(sigma2_est,sigma2_global);
end
u_wf = mu + (sigma2_est-sigma2_global)./sigma2_est.*(u-mu); % Eq.(11.11)
