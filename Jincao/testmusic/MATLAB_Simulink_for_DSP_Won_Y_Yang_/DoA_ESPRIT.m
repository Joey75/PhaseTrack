function phi_deg_estimates=DoA_ESPRIT(R,d_norm,tls)
% ESPRIT DoA estimation
% Inputs:  R      = Correlation matrix of received signal
%          d_norm = Normalized antenna spacing
%          tls    = 1/0 for LS/TLS(Total Least Squares)-based method
% Output : DoA_deg_estimates = DoA estimates in degree
% Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
if nargin<3,  tls=0;  end
M=size(R,1); [Vr,Lam]=eig(R);
[lambdas,idx]=sort(abs(diag(Lam)),'descend');
[dmax,L]=max(diff(-log10(lambdas+1e-3))); % Number of impinging signals
Vs=Vr(:,idx(1:L)); % A matrix made of column vectors spanning signal space
V0=Vs(1:M/2,:);  V1=Vs(M/2+1:end,:); % Eq.(7.38)
if tls==0 % Total Least-Square(TLS) based
  [V,Lam]=eig([V0';V1']*[V0 V1]); % Eq.(7.39)
  [L_arranged,idx]=sort(abs(diag(Lam)),'descend'); V=V(:,idx);
  V12=V(1:L,L+1:end); V22=V(L+1:end,L+1:end); 
  PSI=-V12*inv(V22); % Eq.(7.40)
 else   % Least-Square (LS) based
  PSI=(V0'*V0)\V0'*V1;  
end 
exp_jGam=eig(PSI); Gam=angle(exp_jGam); 
phi_deg_estimates=rad2deg(acos(Gam/(2*pi*d_norm))); % Eq.(7.41)
