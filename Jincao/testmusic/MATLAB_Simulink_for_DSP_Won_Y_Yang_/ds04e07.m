%ds04e07.m
Gd=[1 1 0 0 0]; N=8; sym=1; r=0.99;  
[Bc,Ac,B,A]=FRS_realization(Gd,N,sym,r)
ND=64; g=filter_FRS(Bc,Ac,B,A,[1 zeros(1,ND-1)]); % FRS filtering
W=[-ND:ND]*(pi/ND); G=DTFT(g,W,0); Gmag=abs(G); % Frequency response 
subplot(221), Wk=2*pi/N*[-N/2:N/2];
plot(W,Gmag, Wk,Gd([N/2+1:-1:2 1:N/2+1]),'-k.'); axis([-pi pi 0 1.3])
