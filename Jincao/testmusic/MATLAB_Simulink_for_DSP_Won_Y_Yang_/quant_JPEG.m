function Uh=quant_JPEG(U,Q)
[M,N] = size(U);  [Mb,Nb] = size(Q);
MB = M/Mb; NB = N/Nb; % Numbers of row/column-wise partitions
Uh = zeros(size(U));
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb];  
      Uh(mm,nn) = round(U(mm,nn)./Q); % Eq.(P11.2.5)
   end
end 
