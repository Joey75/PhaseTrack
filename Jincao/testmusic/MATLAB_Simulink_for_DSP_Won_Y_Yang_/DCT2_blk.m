function [U,Eavg_across_blks] = DCT2_blk(u,block_size)
% 2-D DCT (Discrete Cosine Transform) of an image matrix u
% Input : u          = Image matrix of size MxN
%         block_size = [Mb Nb] to partition u into MBxNB subblocks 
%                       of size MbxNb
% Output: U          = KL transformed matrix of u
%   Eavg_across_blks = Mean of subblocks of size MbxNb
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use 
[M,N] = size(u);
Mb=block_size(1); Nb=block_size(2);  MbNb=Mb*Nb;
M1 = rem(M,Mb);  N1 = rem(N,Nb);
if M1+N1>0
   u = padarray(u,[Mb-M1 Nb-N1],'symmetric','post'); 
   M = M+Mb-M1;  N = N+Nb-N1;  
end
MB = M/Mb; NB = N/Nb;  MBNB = MB*NB; % Total number of subblocks
Eavg_across_blks = zeros(Mb,Nb);
for m=1:MB
   mm = (m-1)*Mb+[1:Mb];
   for n=1:NB
      nn = (n-1)*Nb+[1:Nb]; Umn = ????(u(mm,nn)); U(mm,nn) = Umn;
      Eavg_across_blks = Eavg_across_blks + Umn.^2;
   end
end   
Eavg_across_blks = Eavg_across_blks/MBNB; 
