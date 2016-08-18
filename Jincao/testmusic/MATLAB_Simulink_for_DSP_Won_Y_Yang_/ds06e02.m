%ds06e02.m: Try various spectral analysis methods
Nfft=256; f=[0:Nfft/2]/(Nfft/2); W=pi*f; % Normalized/Radian freq vectors
fs=2; N=1024; w=randn(1,N); % Sampling frequency, Input signal
for iter=1:2
   figure(iter), clf
   if iter==1, r=0.99; Pm=50;  else  r=0.5; Pm=20;  end
   p = r*exp(j*[0.2  -0.2  0.4  -0.4]*pi); % Poles
   B=1; A=poly(p) % Numerator/Denominator of system function
   y = filter(B,A,w); % Output to a white Gaussian noise input with PSD=1
   GW=freqz(B,A,W); Np=length(A)-1; % True frequency response, Model order
   PSD_true=abs(GW.*conj(GW)); PSDdB_true=10*log10(PSD_true); % True PSD
   PSDpi_true=PSD_true/pi; PSDpidB_true=10*log10(PSDpi_true);
   subplot(421), Nw=Nfft; Noverlap=Nw/4; pwelch(y,Nw,Noverlap,Nfft,fs)
   hold on, plot(f,PSDdB_true,'k:')
   subplot(422), pmtm(y), hold on, plot(f,PSDpidB_true,'k:')
   subplot(423), pyulear(y,Np), hold on, plot(f,PSDpidB_true,'k:')
   subplot(424), pburg(y,Np), hold on, plot(f,PSDpidB_true,'k:')
   subplot(425)
   [P_cov,f_cov]=pcov(y,Np,Nfft,fs); [P_mcov,f_mcov]=pmcov(y,Np,Nfft,fs);
   plot(f_cov,10*log10(abs(P_cov)), f_mcov,10*log10(abs(P_mcov)),'r:')
   hold on, plot(f,PSDdB_true,'k:'), legend('Covariance','Modified cov')
   subplot(426)
   [P_mus,f_mus]=pmusic(y,Np,Nfft,fs); [P_eig,f_eig]=peig(y,Np,Nfft,fs);
   plot(f_mus,10*log10(abs(P_mus)), f_eig,10*log10(abs(P_eig)),'r:')
   hold on, plot(f,PSDpidB_true,'k:'), legend('MUSIC','Eigenvector')
   subplot(427), [Bp,Ap]=prony(impz(B,A,N),length(B)-1,length(A)-1)
   Gp=freqz(Bp,Ap,W); plot(f,10*log10(abs(Gp.*conj(Gp))),'r')
   hold on, plot(f,PSDdB_true,'k:'), ylabel('Prony')
   subplot(428), [Bs,As]=stmcb(y,w,length(B)-1,length(A)-1)
   Gs=freqz(Bs,As,W); plot(f,10*log10(abs(Gs.*conj(Gs))),'r')
   hold on, plot(f,PSDdB_true,'k:'), ylabel('STMCB')
end
