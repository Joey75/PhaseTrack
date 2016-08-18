function [ahvd,S]=wavedec2_my(u,L,wname)
% 2-D DWT analysis to get the DWT coefficients
% Input
%   u     : Input (image) matrix,     L : Number of levels
%   wname : Wavelet name
% Output
%   ahvd  : Approximation/Horizontal/Vertical/Diagonal DWT coefficients
%   S     : Bookkeeping matrix for the DWT coefficient vector ahvd
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
[gL,gH]=wfilters(wname);  % LPF/HPF filter coefficients for 2-D DWT
ahvd = [];  S = size(u); a = u;  
for level=1:L
   gL_a = [];  gH_a = [];  [M,N]=size(a);
   for m=1:M
      gL_a = [gL_a;  dyaddown(conv(gL,a(m,:)))];
      gH_a = [gH_a;  dyaddown(conv(gH,a(m,:)))]; 
   end
   S2 = size(gH_a,2);  gHgH_a = []; gLgH_a = []; gHgL_a = []; gLgL_a = [];
   for n=S2:-1:1 % Diagonal/Vertical/Horizontal/Approximate coefficients
      gLgL_an=dyaddown(conv(gL,gL_a(:,n))); gLgL_a=[gLgL_an gLgL_a]; % a
      gLgH_an=dyaddown(conv(gL,gH_a(:,n))); gLgH_a=[gLgH_an gLgH_a]; % v
      gHgL_an=dyaddown(conv(gH,gL_a(:,n))); gHgL_a=[gHgL_an gHgL_a]; % h
      gHgH_an=dyaddown(conv(gH,gH_a(:,n))); gHgH_a=[gHgH_an gHgH_a]; % d
   end % Eq.(11.7a,b,c,d)
   ahvd = [gHgL_a(:).' gLgH_a(:).' gHgH_a(:).' ahvd]; 
   S = [size(gHgH_a);  S];
   a = gLgL_a;
end
ahvd = [gLgL_a(:).' ahvd];  S = [size(gLgL_a); 
