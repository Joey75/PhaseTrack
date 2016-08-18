%ds02e01.m
% Use 2-point/3-point DFT for computing a (linear) convolution
x= [1 0.5]; y= [0.5 1]; 
z= conv(x,y) % Linear convolution
for N=2:4 % with DFT size N=2,3, or 4
   XN= fft(x,N); YN=fft(y,N); % DFTs of two sequences (Eq.(2.12a))
   ZN= XN.*YN; % Multiplication of two DFT sequences (Eq.(2.12b))
   zN= ifft(ZN) % Circular convolution (Eq.(2.12c))
end
% This is expected to agree with one period of the linear convolution.
% Sometimes, you had better take the real part of IDFT result 
%  by using real(ifft(ZN)) to make sure of its being real-valued.
