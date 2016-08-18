function P=DoA_MUSIC(R,d_norm,phs)
% MUSIC DoA estimation 
% Inputs: 
%   R       = MxM correlation matrix of a received signal
%   d_norm  = Normalized antenna spacing
%   phs     = Range of Azimuth angle phi[rad]
%   lam_thd = lambda_min threshold factor (>1) 
% Outputs: 
%   P       = Spatial spectrum vs. azimuth angle phis
% Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
if nargin<3,  phs=[0:360]*(pi/360);  end
if nargin<2,  d_norm=0.5;   end
M = size(R,1); mm = [0:M-1].'; % Number of antennas and Index vector
if max(phs)>6.3,  phs_deg=phs; phs=pi/180*phs;  
 else phs_deg=180/pi*phs; 
end
% Eigendecomposition or Spectral decomposition
[V,Lam] = eig(R);      % Eq.(7.29)
[lambdas,idx] = sort(abs(diag(Lam)));
[dmax,Nn] = max(diff(log10(lambdas+1e-3)));
Vn=V(:,idx(1:Nn)); % MxNn matrix made of presumed noise eigenvectors (7.30)
for i=1:length(phs)
   a = exp(j*2*pi*d_norm*cos(phs(i))*mm); % Steering vector
   P(i) = 1/(a'*Vn*Vn'*a+eps);  % Eq.(7.31)
end
if nargout==0
  P_dB=10*log10(abs(P)); P_dB=p_dB-max(P_dB);
  plot(phs_deg,P_dB), axis([min(phs_deg) max(phs_deg) -50 0]), grid on
end
