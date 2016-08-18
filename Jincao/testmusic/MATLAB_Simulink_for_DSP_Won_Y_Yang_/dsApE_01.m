%dsApE_01.m: % To practice using dfilt()
Fs=5e4; T=1/Fs; % Sampling frequency and sampling period
ws1=2*pi*6e3; wp1=2*pi*1e4; wp2=2*pi*12e3; ws2=2*pi*15e3; Rp=2; As=25; 
fp=[wp1 wp2]*T/pi; fs=[ws1 ws2]*T/pi; %Normalize edge freq into [0,1]
[N,fc]=cheb1ord(fp,fs,Rp,As) % Order & critical passband edge freq
[B,A]= cheby1(N,Rp,fc) % numerator/denominator of Chebyshev I BPF
fn=[0:511]/512; W=pi*fn;  
plot(fn,20*log10(abs(freqz(B,A,W))+eps)) % Frequency response
[SOS,Kc]= tf2sos(B,A)  % Cascade form realization
[BBc,AAc]= tf2cas(B,A) % Alternative
[BBp,AAp,Kp]= tf2par_z(B,A) % Parallel form realization: dir2par(B,A)
[r,p]= tf2latc(B,A) % Lattice/Ladder coefficients of lattice filter
G_df1sos= dfilt.df1sos(SOS,Kc); % Direct I form (Fig. 7.23(a))
pause, plot(fn,20*log10(abs(freqz(G_df1sos,W))+eps),'r')
G_df1tsos=dfilt.df1tsos(SOS,Kc); % Direct I transposed form (Fig.7.23(b))
pause, plot(fn,20*log10(abs(freqz(G_df1tsos,W))+eps))
G_df2sos= dfilt.df2sos(SOS,Kc); % Direct II form (Fig. 7.23(c))
pause, plot(fn,20*log10(abs(freqz(G_df2sos,W))+eps),'r')
G_df2tsos=dfilt.df2tsos(SOS,Kc); %Direct II transposed form (Fig.7.23(d))
pause, plot(fn,20*log10(abs(freqz(G_df2tsos,W))+eps))
G_latticeARMA= dfilt.latticearma(r,p); % Lattice ARMA (Fig.7.23(e))
pause, plot(fn,20*log10(abs(freqz(G_latticeARMA,W))+eps),'r')
[A,B,C,D]=tf2ss(B,A); G_ss=dfilt.statespace(A,B,C,D); % State space
 pause, plot(fn,20*log10(abs(freqz(G_ss,W))+eps),'m')
G1=dfilt.df2tsos(BBc(1,:),AAc(1,:)); G2=dfilt.df2tsos(BBc(2,:),AAc(2,:));
G3=dfilt.df2tsos(BBc(3,:),AAc(3,:))
G_cascade= dfilt.cascade(G1,G2,G3); % Cascade form
plot(fn,20*log10(abs(freqz(G_cascade,W))+eps)), hold on
G1=dfilt.df2tsos(BBp(1,:),AAp(1,:)); G2=dfilt.df2tsos(BBp(2,:),AAp(2,:))
G3=dfilt.df2tsos(Kp,1);
G_parallel= dfilt.parallel(G1,G2,G3); % Parallel form
pause, plot(fn,20*log10(abs(freqz(G_parallel,W))+eps),'r')
G_latticeAR_allpass=dfilt.latticeallpass(r); %Lattice Allpass Fig.7.23(f)
G_latticeAR_allpole= dfilt.latticear(r); % Lattice Allpole Fig.7.23(f)
G_dffir= dfilt.dffir(B); 
G_dfsymfir= dfilt.dfsymfir(B);   G_dfasymfir= dfilt.dfasymfir(B);
G_latticeMA_maxphase=dfilt.latticemamax(r); % MA max phase Fig.7.23(g)
G_latticeMA_minphase= dfilt.latticemamin(r); % MA min phase Fig.7.23(g)
