function [U,block_mean,KLT_matrix] = KLT2(u,block_size)
% 2-D KLT (Karhunen-Loeve Transformation) of an image matrix u
% Input : u          = Image matrix of size MxN
%         block_size = [Mb Nb] to partition u into MBxNB subblocks 
%                       of size MbxNb
% Output: U          = KL transformed matrix of u
%         block_mean = Mean of subblocks of size MbxNb
%    KLT_matrix = KLT matrix of size MbNbx1 for each subblock vector
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use [M,N] = size(u);
Mb=block_size(1); Nb=block_size(2);  MbNb=Mb*Nb;
M1 = rem(M,Mb);  N1 = rem(N,Nb);
if M1+N1>0
   u = padarray(u,[Mb-M1 Nb-N1],'symmetric','post'); 
   M = M+Mb-M1;  N = N+Nb-N1;  
end
MB = M/Mb; NB = N/Nb;  MBNB = MB*NB; % Total number of subblocks
blk_vectors = zeros(MB*NB,MbNb); nB=0;
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb];  nB = nB+1;
      blk_vectors(nB,:) = reshape(u(mm,nn),1,MbNb);
   end
end   
if size(blk_vectors,1)>1, blk_vector_mean = mean(blk_vectors);
 else blk_vector_mean = zeros(size(blk_vectors));
end
blk_vectors_0_mean = blk_vectors-repmat(blk_vector_mean,MBNB,1);
C = blk_vectors_0_mean'*blk_vectors_0_mean/MBNB; % Eq.(P11.3.1)
[V,lambdas] = eig(C);  % KL transform matrix
[lambdas_sorted,ids] = sort(diag(lambdas),'descend');
KLT_matrix = V(:,ids)'; 
KL_transformed_vectors = KLT_matrix*blk_vectors_0_mean'; %Eq.(P11.3.2)
nB = 0;
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb];  nB = nB+1;
      U(mm,nn) = reshape(KL_transformed_vectors(:,nB),Mb,Nb);
   end
end 
block_mean = reshape(block_vector_mean,Mb,Nb);
