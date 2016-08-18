%ds10e08_CMFB.m
% test an M-channel cosine-modulated filter bank 
clear, clf
M=4; % Bank order (Number of channels)
r=0.2; N_T=4; Rate=2*M; T=1; 
h=rcosfir(r,N_T,Rate,T,'sqrt')/sqrt(2); 
% B = rcosfir(R, N_T, Rate, T, Filter_Type)
% R    : Rolloff factor of (squareroot) raised cosine shape 
%        (frequency response H=DTFT(h))
% N_T  : If N_T is specified as a scalar, then the filter length is 
%         2*N_T+1 input samples or 2*N_T*Rate+1 output samples.
% Rate : Number of points in each input symbol period of length T.
% T    : Input symbol period.
N=length(h); % 2*N_T*Rate+1
delay=N-1; x=zeros(1,N+delay); lx=length(x);
x(1:lx-delay) = rand(1,lx-delay)-0.5;
K=ceil(lx/M); L=K*M; x(lx+1:L)=0; nn=0:L-1;
[y,Vm,H]=CM_filterbank(h,M,x); % Cosine-modlated filter bank
subplot(411), nn=0:N-1; stem(nn,h,'k.')
subplot(412), f=[-1:0.001:1]; W=pi*f;
plot(f,abs(DTFT(h,W,0)),'k'), hold on
gss=['k:';'b:';'r:';'m:';'k.';'b.';'r.';'m.'];
for m=1:M,  plot(f,abs(DTFT(H(m,:),W,0)),gss(m,:));  end
axis([-1 1 0 4]), set(gca,'XTick',-1:1/M:1)
legend('H(f)','H_0(f)','H_1(f)','H_2(f)','H_3(f)')
subplot(413), nn=0:L-1; stem(nn,x)
hold on, stem(nn-delay,y(1:end-N+1),'rx')
legend('Input to the CMFB','Output from the CMFB'), shg
