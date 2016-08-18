function u_mf=medfilt2_my(u,Nm_Nn)
if nargin<2,  Nm_Nn=[3 3];  end
[M,N] = size(u); Nm=Nm_Nn(1); Nn=Nm_Nn(2);
if mod(Nm,2)==0, Nm=Nm+1; end
if mod(Nn,2)==0, Nn=Nn+1; end
Nm2=(Nm-1)/2; Nn2=(Nn-1)/2;
u_aug = [zeros(Nm2,N+Nn-1); 
         zeros(M+Nm2,Nn2) [u; zeros(Nm2,N)] zeros(M+Nm2,Nn2)];
for m=1:M
   for n=1:N
      neighbors = u_aug(m:m+Nm-1,n:n+Nn-1);
      u_mf(m,n) = median(sort(neighbors(:)));
   end
end
