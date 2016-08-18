%try_using_DWT2.m
% tries using 2-D DWT for image compression
clear, clf
u = double(imread('Younggirl.png'));
u = u(:,:,1);  umax = max(max(u));  u = u/umax;
figure(1), clf
subplot(221), imshow(u); % imagesc(u);  %
axis equal tight; colormap(gray); title('Original image')
wname='Haar'; L=2; % Wavelet type and Number of levels
% 2-D DWT analysis (decomposition)
[ahvd,S] = wavedec2(u,L,wname);
% 2-D IDWT synthesis (reconstruction) using waverec2() or waverec2_my()
u_rec = waverec2(ahvd,S,wname);
u_rec_my = waverec2_my(ahvd,S,wname);
subplot(223), imagesc(u_rec);  % imshow(u_rec);
axis equal tight; colormap(gray);
title('Image reconstructed using waverec2-my()')
% To check if waverec2()/waverec2_my() commonly performed the IDWT well.  
discrepancy_u_waverec2 = norm(u-u_rec)/norm(u)
discrepancy_u_waverec2_my = norm(u-u_rec_my)/norm(u)
% To plot the DWT analysis (decomposition) matrix
subplot(224)
DWT2_dec(u,L,wname); % DWT2_dec(ahvd,S,wname); 
axis equal tight;  title('Image reconstructed using waverec2()')
% Image Compression and reconstruction
Na = S(1,1)*S(1,2); % Number of approximate coefficients
hvd = ahvd(Na+1:end); % excludes the approximation coefficients
hvd_sorted = sort(abs(hvd));
P=90;  % zeroes lower P[%] of detail coefficients
Th = hvd_sorted(floor(length(hvd)*P/100)); % Threhold for 90% compression
hvd_c = hvd;  
hvd_c(find(abs(hvd)<Th)) = 0; % compressed HVD coefficients
ahvd_c = [ahvd(1:Na) hvd_c]; % compressed DWT coefs with App preserved
u_c = waverec2(ahvd_c,S,wname); % Image reconstructed from compressed coefs
discrepancy_uc_waverec2 = norm(u-u_c)/norm(u)
subplot(222), imagesc(u_c);  % imshow(u_c);  
axis equal tight; colormap(gray);
title('Image reconstructed from compressed DWT coefficients')
% An alternative to compress the image using a built-in function wdencmp()
sh='h';  % Hard thresholding with Th
keepapp=1; % To keep the approximate coefficients
[u_c1,ahvd_c1,S_c1] = wdencmp('gbl',u,wname,L,Th,'h',keepapp);
discrepancy_uc_wdencmp = norm(u_c-u_c1)/norm(u_c)
discrepancy_ahvd_wdencmp = norm(ahvd_c-ahvd_c1)/norm(ahvd_c)
set(gcf,'Color','w') % To set the background color to white
