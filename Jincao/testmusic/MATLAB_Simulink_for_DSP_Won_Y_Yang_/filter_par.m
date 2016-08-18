function y=filter_par(B,A,x)
[Nsection,NB]=size(B);  y= zeros(1,length(x));
for k=1:Nsection
   Bk= B(k,:); Ak= A(k,:);
   %while length(Bk)>1&abs(Bk(1))<eps, Bk=Bk(2:end); end
   while length(Ak)>1&abs(Ak(1))<eps, Ak=Ak(2:end); Bk=Bk(2:end); end
   if sum(abs(Bk))>eps,  y = y + filter(Bk,Ak,x);  end  
end
