I = imread('lena_gray.jpg');                  % 512x512?Lena??
im = double(I);
[s,v,d]=svd(im);                              % svd???svd??????v??????????????????????????
recv1=s(:,1:20)*v(1:20,1:50)*d(:,1:50)';      % svd????100????????
recv2=s(:,1:50)*v(1:50,1:100)*d(:,1:100)';    % svd????100????????
recv3=s(:,1:200)*v(1:200,1:200)*d(:,1:200)';  % svd????100????????

subplot(221);imshow(I);
title('??');
subplot(222);imshow(mat2gray(recv1));
title('??????20????50');
subplot(223);imshow(mat2gray(recv2));
title('??????50????100');
subplot(224);imshow(mat2gray(recv3));
title('??????200????200');