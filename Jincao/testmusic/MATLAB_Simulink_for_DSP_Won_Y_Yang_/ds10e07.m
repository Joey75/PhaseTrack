%ds10e07.m
% M-channel DFT (complex-modulated) filter bank
clear, clf
M=4; N=16; N_M=N/M; % Bank order (Number of channels) and Filter length 
% Note that the filter length N must be a multiple of bank order M.
h=zeros(1,N); h(1:M)=1/sqrt(M); delay=M;  % Prototype FIR LPF
H(1,:)=h;  g=h;  G(1,:)=g;
x=zeros(1,N+8); lx=length(x);
x(1:lx-delay) = 2*rand(1,lx-delay)-1;
K=ceil(lx/M); L=K*M; x(lx+1:L)=0; nn=0:L-1;
% Standard DFT filter bank (Fig. 10.17)
[y,Vm]=DFT_filterbank(h,M,x);
% Polyphase DFT filter bank (Fig. 10.18)
[y_p,Vm_p]=DFT_filterbank_poly(h,M,x);
% Note that the reconstructions y[n] and y_p[n] are delayed 
%  by M and M-1 samples compared with x[n], respectively.
Discrepancy1 = norm(x-y(M+1:end-N+M+1))/norm(x)
Discrepancy2 = norm(x-y_p(M:end-N+M))/norm(x)
subplot(311), stem(nn,x), hold on
stem(nn-M,y(1:L),'r.'), stem(nn-M+1,y_p(1:L),'ms')
f=[0:0.001:1]; Omega=2*pi*f; %Frequency range to plot frequency response on 
subplot(312)
H(1,:)=h;  g=h;  G(1,:)=g;
W=exp(j*2*pi/M*[1:M-1].'*[0:N-1]); 
for m=1:M-1,  H(m+1,:)=h.*W(m,:);   end
for m=1:M,  plot(f,abs(freqz(H(m,:),1,Omega))), hold on,  end
