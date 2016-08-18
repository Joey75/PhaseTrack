function v=conv2_my(h,u)
% 2-D convolution of two matrices h and u
[Mh,Nh]=size(h); [Mu,Nu]=size(u); 
u_=[zeros(Mh-1,Nu+2*Nh-2);
    zeros(Mu+Mh-1,Nh-1) [u; zeros(Mh-1,Nu)] zeros(Mu+Mh-1,Nh-1)];
for m=1:Mu+Mh-1
   mm=m+[Mh-1:-1:0];
   for n=1:Nu+Nh-1
      nn=n+[Nh-1:-1:0]; v(m,n) = sum(sum(h.*u_(mm,nn))); % Eq.(11.9)
   end
end
%v = xcorr2(h,fliplr(flipud(u))); % Alternatively
