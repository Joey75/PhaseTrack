%test_xcorr2.m
% computes the 2-D crosscorrelation and convolution of 2 matrices u and v
clear
u=rand(4,3);  v=rand(2,3);
w=xcorr2(u,v);  w1=xcorr2_my(u,v);
discrepancy=norm(w-w1)
w=conv2(u,v);  w1=conv2_my(u,v); w2=xcorr2(u,fliplr(flipud(conj(v))));
discrepancy1=norm(w-w1), discrepancy2=norm(w-w2)
