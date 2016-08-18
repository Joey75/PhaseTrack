%test_median_filter.m
clear, clf
u_original = imread('Younggirl.png'); % read an image and store it 
u = u_original(:,:,1); % A gray-scaled version of Image u
subplot(221), imshow(u), 
un = imnoise(u,'salt & pepper',0.02); % A noisy version of u
subplot(222), imshow(un)
u_mf = medfilt2(un);      % After median filtering
u_mf1 = medfilt2_my(un);  % After median filtering
discrepancy = norm(double(u_mf-u_mf1))
subplot(223), imshow(u_mf)
