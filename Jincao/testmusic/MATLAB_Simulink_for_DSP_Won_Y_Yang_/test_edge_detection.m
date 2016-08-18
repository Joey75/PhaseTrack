%test_edge_detection.m
clear, clf
u_original = imread('Younggirl.png'); % read an image and store it
u = u_original(:,:,1); % extract a gray-scaled version of Image
ud = double(u);
subplot(241), imshow(u), title('Original')
[uedge_sobel,thld] = edge(ud,'sobel');  
subplot(242), imshow(uedge_sobel), title('Sobel')
ux_sob = imfilter(ud,[-1 0 1;-2 0 2;-1 0 1]); % Fig.11.7(a1)
uy_sob = imfilter(ud,[1 2 1;0 0 0;-1 -2 -1]); % Fig.11.7(a2)
u_sob = ux_sob.^2+uy_sob.^2; % Eq.(11.12) %u_sob=abs(ux_sob)+abs(uy_sob); 
u_sob_normalized = u_sob/max(max(u_sob));
thld=0.1162; % obtained from edge(u,'sobel')
uedge_sob = u_sob_normalized>thld^2; 
subplot(243), imshow(uedge_sob), title('Sobel using ux^2+uy^2')
uedge_prewitt = edge(u,'prewitt');  
subplot(244), imshow(uedge_prewitt), title('Prewitt')
u_hpf = imfilter(ud,[-1 -1 -1;-1 8 -1;-1 -1 -1]); % Fig.11.6(a)
u_hpf_normalized = u_hpf/max(max(u_hpf));
uedge_hpf = u_hpf_normalized>0.05;
subplot(245), imshow(uedge_hpf), title('Highpass filtered')
uedge_roberts = edge(u,'roberts');  
subplot(246), imshow(uedge_roberts), title('Roberts')
uedge_log = edge(u,'log'); % Laplacian of Gaussian method
subplot(247), imshow(uedge_log), title('Log: Laplacian of Gaussian')
uedge_canny = edge(u,'canny');
subplot(248), imshow(uedge_canny), title('Canny')
