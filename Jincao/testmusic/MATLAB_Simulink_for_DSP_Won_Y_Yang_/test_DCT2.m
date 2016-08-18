%test_DCT2.m
clear, clf
u_original = imread('Younggirl.png'); % read an image and store it 
% in an array named u_original (png: Portable Network Graphics)
u = u_original(:,:,1); % extract a gray-scaled version of Image
[M,N]=size(u);
subplot(411), imshow(u), title('u[m,n]') % display the image
subplot(423), U_dft=fft2(u); imshow(abs(U_dft),[0 255]) %, colorbar
title('|Udft| = 2D FFT (magnitude) of u[m,n]')
U1_dft = U_dft; 
thld = 0.002*max(max(abs(U1_dft)));
U1_dft(abs(U1_dft)<thld) = 0;  
u1_idft = ifft2(U1_dft);
Compression_ratio_dft=(M*N)/(M*N-sum(sum(abs(U1_dft)<thld)));
U_dct=dct2(u); 
U1_dct = U_dct; thld = 0.002*max(max(abs(U1_dct)));
U1_dct(abs(U1_dct)<thld) = 0;  
u1_idct = idct2(U1_dct);
Compression_ratio_dct=(M*N)/(M*N-sum(sum(abs(U1_dct)<thld)));
Compression_ratios=[Compression_ratio_dft Compression_ratio_dct]
subplot(424), imshow(abs(U_dct),[0 255]) %, colorbar
title('|Udct| = 2D DCT (magnitude) of u[m,n]')
subplot(425), imshow(abs(U1_dft),[0 255]), title('|U1 dft(k,l)|')
subplot(427), imshow(u1_idft,[0 255]), title('u1 idft[m,n]')
subplot(426), imshow(abs(U1_dct),[0 255]), title('|U1 dct(k,l)') 
subplot(428), imshow(u1_idct,[0 255]), title('u1 idct[m,n]')
ud = double(u);
Restoration_errors=[norm(ud-u1_idft), norm(ud-u1_idct)]/norm(ud)
set(gcf,'Color','w') % To set the background color to white
