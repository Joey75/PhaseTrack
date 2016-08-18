function y=filterq_par(B,A,x)
[Nsection,NB]=size(B);
y= zeros(1,length(x));
for k=1:Nsection
   Bk= B(k,:); Ak= A(k,:);
   while length(Ak)>1&abs(Ak(1))<eps
     Ak=Ak(2:end); Bk=Bk(2:end); 
   end
   if sum(abs(Bk))>eps 
     y  =y + filterq_DF2t(Bk,Ak,[zeros(1,length(Bk)-1) x]);
   end  
end
