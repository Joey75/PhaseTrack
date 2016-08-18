function [y,ch_buf]=sp_channel_UCA(x,ch_tap,tap_phi_deg,M,r_norm,ch_buf)
% Simple DoA-based spatial channel
% Inputs:  x           = Channel input
%          ch_tap      = Channel tap coefficient vector
%          tap_phi_deg = Azimuth angles
%          M           = Number of antennas
%          r_norm      = Normalized radius of UCA
%          ch_buf      = Channel buffer (Initial value should be zeros)
% Outputs: y           = Channel output
%          ch_buf      = Updated channel buffer
% Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
Np=size(ch_tap,1);  % Number of multipaths
j2pir=j*2*pi*r_norm;  pi2M=2*pi/M;
for n=1:length(x)
   ch_buf=circshift(ch_buf,[1 1]); % circular shift down/right by 1/1
   ch_buf(1)=x(n);
   for m=1:M
      y(m,n)=0;
      for k=1:Np
         tmp = cos(deg2rad(tap_phi_deg(k,:))-(m-1)*????); 
         y(m,n)=y(m,n)+ch_buf*(ch_tap(k,:).*exp(?????*tmp)).';
      end
   end
end
