%ds10e06.m
% Uses firpr2chfb() to design 4 odd-order FIR filters 
% for analysis (H0/H1) and synthesis (G0/G1) sections 
% of a 2-channel CQF (conjugate quadrature filter) bank with PR property,
% corresponding to so-called orthogonal filter bank 
% also known as power-symmetric filter bank.
clear
N=20; [h0,h1,g0,g1] = firpr2chfb(N-1,.45);
n=0:N-1;  nn=0:2*(N-1);
h0_=(-1).^n.*h0; h1_=(-1).^n.*h1; g0_=(-1).^n.*g0; g1_=(-1).^n.*g1;
Discrepancy_h1_h0=norm(h1-fliplr(h0_)) % Eq.(10.44b) h1=fliplr(h0_);
Discrepancy_g0_h0=norm(g0-2*fliplr(h0)) % Eq.(10.45a) g0=2*fliplr(h0);
Discrepancy_g1_h0=norm(g1-2*h0_) % Eq.(10.45b) g1=2*h0_; 
figure(1), clf
f=[0:0.001:1]; W=pi*f; % Frequency vector
H0mag=abs(freqz(h0,1,W)); H1mag=abs(freqz(h1,1,W));
G0mag=abs(freqz(g0,1,W)); G1mag=abs(freqz(g1,1,W));
plot(f,H0mag,'b', f,H1mag,'r', f,G0mag,'b:', f,G1mag,'r:')
hold on, plot(f,H0mag.^2+H1mag.^2,'k:')
legend('|H0(f)|','|H1(f)|','|G0(f)|','|G1(f)|','|H0(f)|^2+|H1(f)|^2')
% The following plots can be used to verify Eq.(10.39).
figure(2), clf
subplot(321), stem(nn,conv(g0,h0)+conv(g1,h1),'.')
title('g0[n]*h0[n]+g1[n]*h1[n]=2delta[-(N-1)]')
subplot(322), stem(nn,conv(g0,h0_)+conv(g1,h1_),'.')
title('g0[n]*h0_ [n]+g1[n]*h1_ [n]=0 for G0[z]H0[-z]+G1[z]H1[-z]=0')
subplot(323), stem(nn,conv(g0_,h0)+conv(g1_,h1),'.')
title('g0_ [n]*h0[n]+g1_ [n]*h1[n]=0 for G0[-z]H0[z]+G1[-z]H1[z]=0')
subplot(324), stem(nn,conv(g0_,h0_)+conv(g1_,h1_),'.')
title('g0_ [n]*h0_ [n]+g1_ [n]*h1_ [n]=2delta[-(N-1)')
det_H = conv(h0,h1_)-conv(h0_,h1) % Eq.(10.41)
subplot(325), stem(nn,det_H,'.') % det(H)=H0[z]H1[-z]-H0[-z]H1[z]=c*z^-l
title('h0[n]*h1_ [n]-h0_ [n]*h1[n]=-delta[-(N-1)]')
figure(3), clf
Nx=64; n=0:Nx-1;  
x = zeros(1,Nx);  x(1:Nx/2) = rand(1,Nx/2)-0.5;
x0 = filter(h0,1,x); y0 = filter(g0,1,upsample(downsample(x0,2),2));
x1 = filter(h1,1,x); y1 = filter(g1,1,upsample(downsample(x1,2),2));
y = y0 + y1;
% Note that the reconstruction y[n] is delayed by N-1 compared with x[n]
Discrepancy = norm(x(1:end-N+1)-y(N:end))/norm(x(1:end-N+1))
subplot(421), stem(n,x,'.'), title('x[n]')
subplot(423), stem(n,x0,'.'), title('x0[n]')
subplot(424), stem(n,x1,'.'), axis([n([1 end]) -0.6 0.6])
title('x1[n]'), set(gca,'fontsize',9)
subplot(425), stem(n,y0,'.'), title('y0[n]')
subplot(426), stem(n,y1,'.'), title('y1[n]')
subplot(427), stem(n,y,'.'), title('y[n]=x[n-(N-1)]?')
%h0[n] is orthogonal in the sense that its autocorrelation is the impulse.
h0_2=downsample(h0,2); phi_h0_2=xcorr(h0_2);
phih0=xcorr(h0); phih0_2=downsample(phih0(2:end-1),2);
figure(4), stem(phi_h0_2), hold on, stem(phih0_2,'r')
% Run the corresponding Simulink model 'ds10e06_sim.mdl'
sim('ds10e06_sim')
