function plot_DWT_dec(x,wname,level,matrix_or_row,ax,ip,title_str)
% plot the DWT analysis results 
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<6, ip=[1  1];  end  % in the 1st column among 1 column
if nargin<5, ax=[];  end
N=length(x); M=level; t=[1:N]; 
% wavelet decomposition for DWT coefficients
[ad,l] = wavedec(x,M,wname);
xad = DWT_dec(ad,l,wname);
x_hat = sum(xad); % reconstructed signal using DWT_dec()
Discrepancy = norm(x-x_hat)
subplot(M+3,ip(1),ip(2))
plot(t,x,'k', t,x_hat,'b'), ylabel('signal')
if nargin>6,  title(title_str);  end
subplot(M+3,ip(1),ip(1)+ip(2))
plot_DWT(ad,l,wname,matrix_or_row)
for k=1:M+1
   subplot(M+3,ip(1),(k+1)*ip(1)+ip(2)), plot(t,xad(k,:))
   if nargin>4&length(ax)==4, axis(ax); end
   if k==1,  ylabel(['xa' int2str(M)])
    else  ylabel(['xd' int2str(M+2-k)])
   end
end
