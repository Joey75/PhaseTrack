function [y,Vm]=DFT_filterbank_poly(h,g,M,x)
% Polyphase DFT filter bank (Fig. 10.18)
% Input
%  h : FIR LPF coefficients or impulse response for analysis
%  g : FIR LPF coefficients or impulse response for synthesis
%  M : Number of channels (analysis-synthesis filter pairs)
%  x : Input sequence
% Output
%  y : Output sequence (delayed by M-1 samples compared with the input x)
%  Vm: M-subband intermediate sequence matrix
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<4, x=M; M=g; g=h; end
N=length(h); N_M=ceil(N/M); 
% To make sure that the filter length N is a multiple of M
if N_M*M>N,  h(N+1:N_M*M)=0; g(N+1:N_M*M)=0;  N=N_M*M;  end 
Hp=reshape(h,M,N_M);     Gp=reshape(g,M,N_M);  % Polyphase filters
x_buf=zeros(M,1);     y_buf=zeros(M,1);
X_buf=zeros(M,N_M);   W_buf=zeros(M,N_M);  Vm=[];
% X_buf and W_buf have the states of filters Hp and Gp.
lx=length(x); K=ceil(lx/M); L=K*M;
for n=1:L+N-1
   if n<=lx, xn=x(n); else xn=0; end
   x_buf = [xn; x_buf(1:M-1)]; % Mx1 vector
   if mod(n-1,M)==0
     X_buf=[x_buf X_buf(:,1:N_M-1)]; % Downsampling (MxN_M matrix)
     Hx=sum(Hp.*X_buf,2); % Analysis filter bank outputs (Mx1 vector)
     V = M*ifft(Hx); Vm=[Vm V];
     W_buf=[fft(V) W_buf(:,1:N_M-1)];
     Gw=sum(Gp.*W_buf,2); % Synthesis filter bank outputs
    else
     Gw=zeros(M,1); % Upsampling
   end
   y_buf = [Gw(1); y_buf(1:M-1)+Gw(2:M)];
   y(n) = y_buf(M);
end
