function P=DoA_MUSIC_UCA(R,r_norm,phs)
% MUSIC DoA estimation 
% Inputs: 
%   R       = MxM covariance matrix of a received signal
%   r_norm  = Normalized radius of UCA
%   phs     = Range of Azimuth angle phi[rad]
% Outputs: 
%   P       = Spatial spectrum vs. azimuth angle phis
% Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
if nargin<3,  phs=[0:360]*(pi/360);  end
if nargin<2,  r_norm=1/(4*sin(pi/M));  end % so that d_norm=1/2
M = size(R,1); mm = [0:M-1].'; % Number of antennas and Index vector
if max(phs)>6.3,  phs_deg=phs; phs=pi/180*phs;  
 else phs_deg=180/pi*phs; 
end
[V,L] = eig(R);      % Eq.(7.29)
[lambdas,idx] = sort(abs(diag(L)));
[dmax,K] = max(diff(log10(lambdas+1e-3)));
Vn = V(:,idx(1:K)); j2pir=j*2*pi*r_norm; pi2M=2*pi/M;
for i=1:length(phs)
   a = exp(?????*cos(phs(i)-????*mm)); % Steering vector of UCA
   P(i) = 1/(a'*Vn*Vn'*a+eps);
end
if nargout==0
  P_dB=10*log10(abs(P)); P_dB=p_dB-max(P_dB);
  plot(phs_deg,P_dB), axis([min(phs_deg) max(phs_deg) -50 0]), grid on
end
