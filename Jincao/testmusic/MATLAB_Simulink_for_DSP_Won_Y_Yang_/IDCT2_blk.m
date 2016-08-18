function u = IDCT2_blk(U,block_size,mask_block)
% 2-D Blockwise IDCT of a Discrete Cosine tansformed matrix U
% Input : U          = KL transformed matrix of u
%         block_size = [Mb Nb] to partition u into MBxNB subblocks 
%                       of size MbxNb
%         mask_block = 1xMbNb vector with 1/0 to keep/discard coeff 
% Output: u          = Matrix reconstructed from KL transformed U
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use [M,N] = size(U);
Mb=block_size(1); Nb=block_size(2);  MbNb=Mb*Nb;
M1 = rem(M,Mb);  N1 = rem(N,Nb);
if M1+N1>0
  error(['U must be a matrix partioned into '  ... 
  num2str(Mb) 'x' num2str(Nb) 'subblocks!']);
end
if nargin<3,  mask_block = ones(Mb,Nb);  end
if size(mask_block,1)==1|size(mask_block,2)==1
  mask_block=izigzag(mask_block,Mb,Nb);  
end
MB = M/Mb; NB = N/Nb; MBNB = MB*NB; % Total number of subblocks
u = zeros(size(U));
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb]; 
      u(mm,nn) = ?????(U(mm,nn).*mask_block);
   end
end
