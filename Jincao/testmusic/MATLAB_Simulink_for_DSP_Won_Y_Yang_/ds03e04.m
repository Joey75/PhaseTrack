%ds03e04.m
% Correlation/Convolution and Matched Filter (plots Fig. 3.3)
clear, clf
M=50; Ts=1/M;
x1=repmat([1  1],M,1); x1=x1(:).'; Nx=length(x1);
x2=repmat([1 -1],M,1); x2=x2(:).'; 
g1=fliplr(x1); g2=fliplr(x2);
x=[x1 zeros(1,M) x2 zeros(1,M) x1 zeros(1,M) x2]; % A signal to transmit
length_x=length(x); Nbuffer= min(M*11,length_x); tt=[0:Nbuffer-1]*Ts;
% Noise_amp=0.3; x = x + Noise_amp*randn(1,length_x);
xbuffer=zeros(1,Nbuffer); ybuffer=zeros(2,Nbuffer); 
for n=1:length_x
   xbuffer= [x(n) xbuffer(1:end-1)]; 
   y= [g1; g2]*xbuffer(1:Nx).'*Ts;  
   ybuffer= [ybuffer(:,2:end) y];
   subplot(312), plot(tt,ybuffer(1,:))
   subplot(313), plot(tt,ybuffer(2,:))
   pause(0.01), if n<length_x, clf; end % Motion picture
end
y1=xcorr(x,x1)*Ts; y2=xcorr(x,x2)*Ts; % Ts multiplied to simulate CT 
y1=y1([end-Nbuffer+1:end]-Nx); % Correlation delayed by Nx
y2=y2([end-Nbuffer+1:end]-Nx); 
subplot(312), hold on, plot(tt,y1,'m') % only for cross-check 
subplot(313), hold on, plot(tt,y2,'m')
