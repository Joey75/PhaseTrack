function phi_deg_estimates=DoA_Root_MUSIC(R,d_norm,phs)
% Root-MUSIC DoA estimation 
% Inputs:
%   R       = MxM correlation matrix of a received signal
%   d_norm  = Normalized antenna spacing
%   phs     = Range of Azimuth angle phi[rad]
% Outputs:  
%   phi_deg_estimates = Azimuth angle estimates in degrees
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only

if nargin<3,  phs=[0:360]*(pi/360);  end
if nargin<2,  d_norm=0.5;   end
M = size(R,1);  % Number of antennas

% Eigendecomposition or Spectral decomposition
[V,Lam] = eig(R);         % Eq.(7.29)
[lambdas,idx] = sort(abs(diag(Lam))); 
[dmax,K]=max(diff(log10(lambdas+1e-3))); % Noise subspace dimension
Vn = V(:,idx(1:K)); % MxK matrix made of presumed noise eigenvectors
C = Vn*Vn';
for k=-M+1:M-1
   m=max(k+1,1); n0=max(1,1-k);  
   Qz(k+M)=C(m,n0); % q(k): the sum of kth (sub)diagonal of C(m,l)
   for l=1:M-abs(k)-1
      Qz(k+M)=Qz(k+M)+C(m+l,l+n0); % Eq.(7.33)
   end
end   
%Qz = fliplr(Qz); 

roots_of_Qz = roots(Qz); % Roots of Q[z]=0 of degree 2M-2
distinct_roots = roots_of_Qz(1);
for i=2:2*M-2
   root = roots_of_Qz(i); 
   if min(abs(root-distinct_roots))>0.05
     distinct_roots = [distinct_roots  root];
   end
end
% To find the L=M-K closest roots to the unit circle
[sorted,inds] = sort(abs(abs(distinct_roots)-1));
z = distinct_roots(inds(1:M-K)); % L=M-K closest roots to the unit circle
phi_deg_estimates = rad2deg(acos(angle(z)/(2*pi*d_norm))); % Eq.(7.34)
