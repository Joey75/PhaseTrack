function [y,AD]=DWT_filterbank(h0,h1,g0,g1,M,x)
% DWT/IDWT Using an M-level asymmetric dyadic (octave) bank
% Input : h0,h1/g0,g1 : Tap coefficients of LPF,HPF for analysis/synthesis
%         M           : Number of levels,     x    : Input
% Output: y           : Output of the filter bank to the input x
%         AD          : Approximation/Detail DWT coefficients
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
N1=length(h0); % Length of filter
AD(M+1,:) = dyaddown(conv(h1,x));
y1 = conv(g1,dyadup(AD(M+1,:)));
AD_M = dyaddown(conv(h0,x)); 
if M<2,  y0 = conv(g0,dyadup(AD_M)), AD(1,:)=AD_M;
 else   [w_M,AD_M_1] = DWT_filterbank(h0,h1,g0,g1,M-1,AD_M);
   y0 = conv(g0,dyadup(w_M)); AD_M_1 = upsample(AD_M_1.',2).';
   Nc_AD_M1=size(AD_M_1,2); Nc_AD=size(AD,2);
   if Nc_AD_M1>Nc_AD,  AD(1:M,:) = AD_M_1(:,1:Nc_AD);  
    else AD(1:M,:) = [AD_M_1  zeros(M,Nc_AD-Nc_AD_M1)];
   end
end
Ly0=length(y0); Ly1=length(y1); Ly=min(Ly0,Ly1); 
y = y1(N1:Ly) + y0(N1:Ly);
