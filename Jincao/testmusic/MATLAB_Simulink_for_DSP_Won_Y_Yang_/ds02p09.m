%ds02p09.m
Bc=[1 zeros(1,7) -1];  Ac=8; 
B1=1; A1=[1 -1];  B2=-2*cos(pi/8)*[1 -1]; A2=[1 -2*cos(pi/4) 1];
B=conv(poly(exp(j*2*pi/8*[2:6])),conv(B1,A2)+conv(B2,A1));  A=8;
G1=dfilt.df2t(B,A);
G_comb=dfilt.df2t(Bc,Ac);
G_resonator=parallel(dfilt.df2t(B1,A1),dfilt.df2t(B2,A2));
G2=cascade(G_comb,G_resonator); % FRS structure
N=32; f=[0:N]/N; W=f*pi; % Frequency response
G1W_freqz_mag=abs(freqz(G1,W)); % using freqz()
G1W_DTFT_mag=abs(DTFT(impz(G1,1e5),W,0)); % using impz() and DTFT()
subplot(221), plot(f,G1W_freqz_mag, f,G1W_DTFT_mag,'r:')
