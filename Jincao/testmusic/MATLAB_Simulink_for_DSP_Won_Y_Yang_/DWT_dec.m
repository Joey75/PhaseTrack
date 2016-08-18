function xad=DWT_dec(ad,l,wname)
% make a matrix xad each row of which has approximation-detail components 
% of a signal with DWT coefficient vector ad and its length vector l
Length_of_l=length(l); M=Length_of_l-2; % The (deepest) level of DWT
N=l(Length_of_l); % Length of the (original) sequence to reconstruct
xad=zeros(M+1,N);
xad(1,:)=wrcoef('a',ad,l,wname,M); % xaM
for k=2:M+1
  % wavelet reconstruction from DWT (approximation/detail) coefficients
  xad(k,:)=wrcoef('d',ad,l,wname,M+2-k); % xd(M+2-k)
end
