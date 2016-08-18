function plot_DWT(ad,l,wname,mat_or_row)
% ad        : Concatenated vector of approximation/detail coefficients
% l         : Vector consisting of lengths of each component in ad
% wname     : Wavelet name
% mat_or_row: 'mat'/'row' to plot the mage matrix row-wise/globally
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<4 | mat_or_row(1)=='r', mat_or_row = 'row';  
 else mat_or_row = 'mat'; 
end
M=length(l)-2; % the (deepest) level of DWT
N=l(length(l));  cfd=zeros(2^M,N);  m = 1;
for k=1:M
   d = detcoef(ad,l,k); % Level-k detail coefficients
   d = repmat(d,2^k,1); % (2^k x N) matrix made of duplicate row vectors
   Mk = 2^(M-k);
   % To capture only N elements in the center of the super row vector
   cfd(m:m+Mk-1,:) = repmat(wkeep(d(:)',N),Mk,1); 
   m = m + Mk;
end
a = repmat(appcoef(ad,l,wname,M),2^M,1);
cfd(m,:) = wkeep(a(:)',N);
% To display an image matrix with its data scaled to use the full color map
img = imagesc(wcodemat(cfd,128,mat_or_row)); 
set(get(img,'parent'), 'YtickLabel',[]);
ylabels='01 2   3      4              5';
ylabel(ylabels([1:2^(M-0.8)]))
