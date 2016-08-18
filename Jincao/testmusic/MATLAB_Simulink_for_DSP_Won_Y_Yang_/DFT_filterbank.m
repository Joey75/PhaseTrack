function [y,Vm]=DFT_filterbank(h,g,M,x)
% Direct DFT filter bank (Fig. 10.17)
% Input
%  h : FIR LPF coefficients or impulse response for analysis
%  g : FIR LPF coefficients or impulse response for synthesis
%  M : Number of channels (analysis-synthesis filter pairs)
%  x : Input sequence
% Output
%  y : Output sequence (delayed by M samples compared with the input x)
%  Vm: M-subband intermediate sequence matrix
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<4,  x=M;  M=g;  g=h;  end
N=length(h);
H(1,:)=h;    G(1,:)=g;
W=exp(j*2*pi/M*[1:M-1].'*[0:N-1]); 
W_=conj(W);  % W_=exp(-j*2*pi/M*[1:M-1].'*[0:N-1]);
for m=1:M-1
   H(m+1,:) = h.*W(m,:); % Eq.(10.52)
   G(m+1,:) = g.*W_(m,:); % Eq.(10.54)
end
G = fliplr(rotate_l(G,M+1));  %
X_buf=zeros(M,N); W_buf=zeros(M,N);  Vm=[]; 
% X_buf and W_buf have the states of filters H and G.
lx=length(x); K=ceil(lx/M); L=K*M;
for n=1:L+N-1
   if n<=lx
     xn=repmat(x(n),M,1);
    else  
     xn=zeros(M,1);
   end
   X_buf = [xn  X_buf(:,1:N-1)];
   Hx = sum(H.*X_buf,2); % Analysis filter bank outputs
   if mod(n-1,M)==0
     Vm=[Vm Hx]; Wm=Hx; % Downsampling
    else 
     Wm=zeros(M,1); % Upsampling
   end
   W_buf = [Wm  W_buf(:,1:N-1)];
   Gw = sum(G.*W_buf,2); % Synthesis filter bank outputs
   y(n) = sum(Gw);
end

