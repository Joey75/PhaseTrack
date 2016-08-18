function [u]=waverec2_my(ahvd,S,wname)
% 2-D DWT
% Input
%   ahvd  : Approximation/Horizontal/Vertical/Diagonal DWT coefficients
%   S     : Bookkeeping matrix for the DWT coefficient vector ahvd
%   wname : Wavelet name
% Output
%   u     : Input (image) matrix
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
[gL,gH,gRL,gRH]=wfilters(wname);  % DWT filters
L = size(S,1)-2; % Number of levels
M=S(1,1); N=S(1,2); MN0=M*N; a=ahvd(1:MN0); a=reshape(a,M,N);
for level=L:-1:1
   l=L-level+2; M=S(l,1); N=S(l,2); MN=M*N;
   h=ahvd(MN0+[1:MN]); h=reshape(h,M,N);
   v=ahvd(MN0+MN+[1:MN]); v=reshape(v,M,N);
   d=ahvd(MN0+2*MN+[1:MN]); d=reshape(d,M,N);
   gRL_a_and_gRH_h = [];  gRL_v_and_gRH_d = [];  MN0=MN0+3*MN;
   for n=1:N
      gRL_an = conv(dyadup(a(:,n),0,'r'),gRL); gRL_an = gRL_an(:);
      gRH_hn = conv(dyadup(h(:,n),0,'r'),gRH); gRH_hn = gRH_hn(:);
      gRL_a_and_gRH_h = [gRL_a_and_gRH_h  gRL_an+gRH_hn]; % Eq.(11.8)
      gRL_vn = conv(dyadup(v(:,n),0,'r'),gRL); gRL_vn = gRL_vn(:);
      gRH_dn = conv(dyadup(d(:,n),0,'r'),gRH); gRH_dn = gRH_dn(:);
      gRL_v_and_gRH_d = [gRL_v_and_gRH_d  gRL_vn+gRH_dn]; % Eq.(11.8)
   end
   Nm = size(gRL_a_and_gRH_h,1);
   a = [];
   for m=1:Nm
      gRL_gRL_a_and_gRH_hm = conv(gRL,dyadup(gRL_a_and_gRH_h(m,:),0,'c')); 
      gRH_gRL_v_and_gRH_dm = conv(gRH,dyadup(gRL_v_and_gRH_d(m,:),0,'c'));
      a = [a;  gRL_gRL_a_and_gRH_hm+gRH_gRL_v_and_gRH_dm]; % Eq.(11.8)
   end
   for k=1:size(a,1)-S(l+1,1)
      if sum(abs(a(1,:)))<eps, a=a(2:end,:); end
   end
   for k=1:size(a,2)-S(l+1,2)
      if sum(abs(a(:,1)))<eps, a=a(:,2:end); end
   end
   a = wkeep2(a,S(l+1,:)); % a,h,v,d
end
u = a;  if nargout==0, imagesc(u);  end
