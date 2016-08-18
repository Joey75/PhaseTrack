function y=filterq_cas(B,A,x)
y=x;  [Nsection,NB]=size(B);
for k=1:Nsection
   Bk= B(k,:);  Ak= A(k,:);
   if abs(B(k,1))+abs(A(k,1))<1e-10, Bk=B(k,2:3); Ak=A(k,2:3);  end
   y=filterq_DF2t(Bk,Ak,[zeros(1,length(Bk)-1) y]);
end
