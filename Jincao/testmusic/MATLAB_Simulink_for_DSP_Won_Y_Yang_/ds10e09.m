%ds10e09.m
clear, clf
N=128;  t=1:N;
x_chirp=chirp(t,0,100,0.15); % generate a chirp signal
load leleccum % load from Matlab\toolbox\wavelet\wavedemo
wname='db2'; M=3; % Wavelet type and Number of levels
matrix_or_row='row'; colormap('gray')
for i=1:2
   if i==1, x = x_chirp; 	else  x = leleccum;   end
   plot_DWT_dec(x,wname,M,matrix_or_row,[],[2 i])
end
