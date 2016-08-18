%ds01e01.m
% to plot Fig. 1.3 for Example 1.1 (Relationship between CTFT and DTFT)
Tp=0.01; t=[-6:Tp:14]; % Time segment width and Time range
xt = t.*(0<t&t<=2) + (4-t).*(2<t&t<=6) + (t-8).*(6<t&t<=8); % Signal
N=400; fd=[-500:500]/N; W=(2*pi)*fd; % Digital frequency range
Xw=inline('j*8*sin(2*w).*sinc(w/pi).^2.*exp(-j*4*w)','w'); % CTFT Eq.(E1.1.4)
X_DTFTa= j*4*sin(2*W).*(1+cos(W)).*exp(-j*4*W); % DTFT by Eq.(E1.1.6)
Ts=[1 0.5]; % Sampling periods
M=1; % Number of terms to be summed up for computing Eq.(1.11)
for i=1:2
   T=Ts(i); w=W/T; fa=fd/T; % Sampling period and analog frequency range
   nn=1:round(T/Tp):length(t); tn=t(nn); xn=xt(nn);
   X_CTFT=Xw(w); % Eq.(E1.1.4)
   Sum_X_CTFTs=Xw(w)/T; % Eq.(1.11)
   for m=1:M
      Sum_X_CTFTs=Sum_X_CTFTs+(Xw(w+2*m*pi/T)+Xw(w-2*m*pi/T))/T; % Eq.(1.11)
   end
   n0=t(1)/T; X_DTFT=DTFT(xn,W,n0); % Eq.(1.4a)
   if i==1, Discrepancy_between_DTFTs=norm(X_DTFTa-X_DTFT)/norm(X_DTFT), end
   subplot(320+i), stem(tn,xn,'.'), hold on, plot(t,xt,':')
   subplot(322+i), plot(fa,abs(X_DTFT),'b', fa,abs(X_CTFT/T),'r:'), hold on
   plot(fa,abs(Sum_X_CTFTs),'k:'), axis([-2.5 2.5 0 8*i]), 
   subplot(324+i), plot(fa,angle(X_DTFT)); hold on
   Discrepancy_between_CTFT_and_DTFT=norm(X_DTFT-Sum_X_CTFTs)/norm(X_DTFT)
end
