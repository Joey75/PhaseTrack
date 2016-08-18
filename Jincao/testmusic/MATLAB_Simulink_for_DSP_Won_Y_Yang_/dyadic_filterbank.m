function [y,V]=dyadic_filterbank(h0,h1,g0,g1,L,x,thr)
% L-level asymmetric dyadic (octave) bank
% Input
%   h0,h1/g0,g1 : Tap coefficients of LPF,HPF for analysis/synthesis
%   L           : Number of levels
%   x           : Input
%   thr      : threshold for each subband signal v_L for deadzone operation
% Output
%   y           : Output of the filter bank to the input x
%   V           : Subband signal matrix of L+1 rows with low-to-high band 
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<7, thr = zeros(1,L);  end % Virtually, no deadzone operation
if length(thr)<L, error('thr must be of length L (number of levels)'); end
N1=length(h0); N=N1-1; % Length and Order of filter
[h0max,imaxh]=max(h0); [g0max,imaxg]=max(g0);
lagv=imaxh-1; lagw=imaxh+imaxg-2;
V(L+1,:) = downsample(filter(h1,1,x),2);
y1 = filter(g1,1,upsample(wthresh(V(L+1,:),'s',thr(end-L+1)),2));
v_L = downsample(filter(h0,1,x),2);
if L<2,  y0 = filter(g0,1,upsample(v_L,2)); V(1,:)=v_L;
 else
  [w_L,V_L_1] = dyadic_filterbank(h0,h1,g0,g1,L-1,[v_L zeros(1,N)],thr);
  y0 = filter(g0,1,upsample(w_L,2));
  V(1:L,:) = [V_L_1  zeros(L,length(v_L)-size(V_L_1,2))];
  y1 = [zeros(1,2*lagw*(2^(L-1)-1))  y1(1:end)];
end
Ly = min(length(y0),length(y1));  y = y1(1:Ly) + y0(1:Ly);
