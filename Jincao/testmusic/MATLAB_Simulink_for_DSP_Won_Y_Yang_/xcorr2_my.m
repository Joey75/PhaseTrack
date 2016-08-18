function phi_uv=xcorr2_my(u,v)
% 2-D crosscorrelation between two matrices u and v
if nargin<2, v=u; end
[Mu,Nu]=size(u);  [Mv,Nv]=size(v); 
u_=[zeros(Mv-1,Nu+2*Nv-2);
    zeros(Mu+Mv-1,Nv-1)  [u; zeros(Mv-1,Nu)]  zeros(Mu+Mv-1,Nv-1)];
for m=1:Mu+Mv-1
   mm=m+[0:Mv-1];
   for n=1:Nu+Nv-1
      nn=n+[0:Nv-1]; phi_uv(m,n)=sum(sum(u_(mm,nn).*conj(v))); % Eq.(11.10)
   end
end
