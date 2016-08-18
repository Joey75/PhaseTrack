function y=filter_cas(B,A,x)
[Nsection,NB]=size(B);  y=x;
for k=1:Nsection
   Bk= B(k,:);  Ak= A(k,:);
   if abs(B(k,1))+abs(A(k,1))<1e-10, Bk= B(k,2:3); Ak= A(k,2:3);  end
   %if B(k,3)==0&A(k,3)==0, Bk=B(k,1:2); Ak=A(k,1:2); end
   %if B(k,2)==0&A(k,2)==0, Bk=B(k,1); Ak=A(k,1); end
   %if Bk(1)==0; Bk=Bk(2:length(Bk)); end
   y=filterb(Bk,Ak,[zeros(1,length(Bk)-1) y]);
end
