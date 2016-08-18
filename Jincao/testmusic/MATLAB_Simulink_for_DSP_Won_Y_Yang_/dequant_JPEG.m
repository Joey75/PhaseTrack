function Udq=dequant_JPEG(Uh,Q)
[M,N] = size(Uh);  [Mb,Nb] = size(Q);
MB = M/Mb; NB = N/Nb; % Numbers of row/column-wise partitions
Udq = zeros(size(Uh));
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb];  
      Udq(mm,nn) = round(Uh(mm,nn).*Q); % Reverse of Eq.(P11.2.5)
   end
end 
