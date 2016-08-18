function u = IKLT2(U,KLT_matrix,block_size,block_mean,mask_block)
% 2-D IKLT (Inverse Karhunen-Loeve Transform) of a KLTed matrix U
% Input : U          = KL transformed matrix of u
%         KLT_matrix = KLT matrix of size MbNbx1 for each supervector
%         block_size = [Mb Nb] to partition u into MBxNB subblocks 
%                       of size MbxNb
%         block_mean = Mean of subblocks of size MbxNb
%         mask_block = 1xMbNb vector with 1/0 to keep/discard 
%                       corresponding coeff 
% Output: u          = Image matrix reconstructed from KLTed matrix U
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use 
[M,N] = size(U);
Mb=block_size(1); Nb=block_size(2);  MbNb=Mb*Nb;
if rem(M,Mb)+rem(N,Nb)>0
error(['U must be a matrix partioned into ' num2str(Mb) 'x' ... 
num2str(Nb) 'subblocks']);
end
if nargin<5,  mask_block = ones(1,MbNb);  end
mask_block = reshape(mask_block,1,MbNb);
MB = M/Mb; NB = N/Nb;  MBNB = MB*NB; % Total number of subblocks
Blk_vectors = zeros(MB*NB,MbNb); nB=0;
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb];  nB = nB+1;
      Blk_vectors(nB,:) = reshape(U(mm,nn),1,MbNb).*mask_block;
   end
end   
blk_vector_mean = reshape(block_mean,1,MbNb);
blk_vectors = Blk_vectors*KLT_matrix ...
+ repmat(blk_vector_mean,MBNB,1); % Eq.(P11.3.3)
nB = 0;
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb];  nB = nB+1;
      u(mm,nn) = reshape(blk_vectors(nB,:),Mb,Nb);
   end
end
