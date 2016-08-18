function P=DoA_DAS(R,d_norm,phs)
% DAS (Delay and Sum) DoA estimation method
% Input:  
%   R      = MxM correlation matrix of a received signal
%   d_norm = Normalized antenna spacing (d/lambda)
%   phs    = Range of Azimuth angle phi[rad]
% Output: 
%   P      = Spatial spectrum vs. azimuth angle phis
% Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
if nargin<3,  phs=[0:360]*(pi/360);  end
if nargin<2,  d_norm=0.5;   end
M = size(R,1); mm = [0:M-1].'; % Number of antennas and Index vector
if max(phs)>6.3,  phs_deg=phs; phs=pi/180*phs;  
 else phs_deg=180/pi*phs; 
end
for i=1:length(phs)
   a = exp(j*2*pi*d_norm*cos(phs(i))*mm); % Steering vector Eq.(7.19)
   P(i) = a'*R*a; % Eq.(7.23)
end
if nargout==0
  P_dB=10*log10(abs(P)); P_dB=p_dB-max(P_dB);
  plot(phs_deg,P_dB)
  axis([min(phs_deg) max(phs_deg) -50 0]), grid on
end
