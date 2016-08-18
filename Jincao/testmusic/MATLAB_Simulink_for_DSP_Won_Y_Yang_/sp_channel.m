function [y,ch_buf]=sp_channel(x,ch_tap,tap_phi_deg,M,d_norm,ch_buf)
% Simple DoA-based spatial channel
% Inputs:  x           = Channel input
%          ch_tap      = Channel tap coefficient vector
%          tap_phi_deg = Azimuth angles
%          M           = Number of antennas
%          d_norm      = Normalized interelement spacing of ULA
%          ch_buf      = Channel buffer (Initial value should be zeros)
% Outputs: y           = Channel output
%          ch_buf      = Updated channel buffer
% Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
Np=size(ch_tap,1);  j2pi=j*2*pi;  % Number of multipaths
for n=1:length(x)
   ch_buf=circshift(ch_buf,[1 1]); % circular shift down/right by 1/1
   ch_buf(1)=x(n);
   for m=1:M
      y(m,n)=0;
      for k=1:Np
         tmp = cos(deg2rad(tap_phi_deg(k,:))); 
         y(m,n)=y(m,n)+ch_buf*(ch_tap(k,:).*exp(j2pi*(m-1)*d_norm*tmp)).';
      end
   end
end
