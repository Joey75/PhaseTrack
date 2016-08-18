function [y,H,lag]=decimate_polyphase(u,M,N)
% Input:  u=Original sequence, M=Decimation factor
%         N=FIR filter length or coefficient vector of length N
% Output: y=Decimated sequence, H=Polyphase FIR filter coefficient matrix
if length(N)==1, h=fir1(N-1,1/M);  else h=N; N=length(h); end
Nu=length(u); u = [u zeros(1,ceil(Nu/M)*M-Nu)]; Nu=length(u);
Nh=length(h); h = [h zeros(1,ceil(Nh/M)*M-Nh)]; Nh=length(h);
H = reshape(h,M,Nh/M); NM2=floor(N/M/2); zeros1=zeros(1,NM2);
for lambda=1:M
if lambda==1,  ulambda=[u(1:M:end) zeros1 0]; 
else ulambda=[0 u(M+2-lambda:M:end) zeros1]; 
end 
Y(lambda,:) = filter(H(lambda,:),1,ulambda);
end
y = sum(Y); y = y(NM2+1:end); lag = N/2-NM2*M; % Eq.(10.15)
% y2 = decimate(u,M,N,'fir'); % Using Signal Processing Toolbox function
