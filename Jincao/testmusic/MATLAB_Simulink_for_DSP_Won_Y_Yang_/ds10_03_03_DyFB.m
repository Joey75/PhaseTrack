%ds10_03_03_DyFB.m
% test a 3-level asymmetric dyadic (octave) filter bank 
clear
L = 3;             % Number of levels
N = 20; fp = 0.4;  % Length and passband edge frequency of FIR filter
[h0,h1,g0,g1] = firpr2chfb(N-1,fp);  % Orthogonal FIR filter bank 
lag=(N-1)*(2^L-1); % Expected lag (in samples) of output w.r.t. input
x=rand(1,50)-0.5; Nx=length(x); % A test input signal and its length
T=0.01; % Sample time
xt=[[0:Nx-1].'*T  x.']; % To drive a sample-based Simuink model
[y,V]=dyadic_filterbank(h0,h1,g0,g1,L,[x zeros(1,lag)]); 
% Discrepancy_between original signal x[n] and reconstructed one y[n]
discrepancy1 = norm(x-y(lag+[1:Nx]))/norm(x)
figure(1), clf
% Plot the frequency response of (cascaded) filters.
subplot(211), f=[0:0.001:1]; W=pi*f; plot(f,abs(DTFT(h1,W))), hold on
gss=['k:';'b:';'r:';'m:';'k.';'b.';'r.';'m.'];
Hlp=DTFT(h0,W);
for level=1:L-1
   W2=2*W; plot(f,abs(DTFT(h1,W2).*Hlp),gss(level,:)); 
   W=W2; Hlp=Hlp.*DTFT(h0,W);
end
plot(f,abs(Hlp),gss(L,:))
% Plot the original signal and reconstructed one.
T=0.01; tx=[0:length(x)-1+lag]*T; ty=[0:length(y)-1]*T; % Time range
subplot(313), stem(tx,[zeros(1,lag) x],'k.')
hold on, stairs(ty,y), axis([(lag-1)*T,(lag+Nx)*T,min(x),max(x)])
