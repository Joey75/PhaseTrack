%ds04e08.m
N=8; Gd=[1 1 0 0 0]; sym=1; r=0.99;
B=FRS_nr_realization(Gd,N,sym), A=1; % Nonrecursive FRS (FIR) filter
ND=64; g=filter(B,A,[1 zeros(1,ND-1)]); % Impulse response
W=[-ND:ND]*(pi/ND); G=DTFT(g,W,0); Gmag=abs(G); % Frequency response 
subplot(222), Wk=2*pi/N*[-N/2:N/2];
plot(W,Gmag, Wk,Gd([N/2+1:-1:2 1:N/2+1]),'-k.'); axis([-pi pi 0 1.3])
