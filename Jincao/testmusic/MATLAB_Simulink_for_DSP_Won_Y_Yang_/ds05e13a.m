%ds05e13a.m to get the frequency response
clear, clf 
format short e
Fs=5e4; T=1/Fs; % Sampling frequency and sampling period
f=[0:200]/200; W=f*pi; % Frequency vector
q=2^-7; % Quantum (LSB value) for quantization
Fs=5e4; T=1/Fs; % Sampling frequency and Sampling period
wp=2*pi*6000; ws=2*pi*15000; Rp=2; As=25; % LPF design specification

% Digital Butterworth LPF design
fp=wp*T/pi; fs=ws*T/pi; % Normalize into [0,1] (1: pi[rad/sample])
[Nb,fcb]= buttord(fp,fs,Rp,As) % Order of digital BW LPF
[Bd,Ad]= butter(Nb,fcb) % num/den of digital BW LPF system ftn
Gd=dfilt.df2t(Bd,Ad); % Filter object
GdW_dB=10*log10(abs(freqz(Gd,W))+1e-10); % Frequency response
Bdq=quant(Bd,q);  Adq=quant(Ad,q); % Quantization of coefficients
Gdq=dfilt.df2t(Bdq,Adq); % Quantized filter object
GdqW_dB=10*log10(abs(freqz(Gdq,W))+1e-10); % Frequency response
subplot(4,3,1), plot(f,GdW_dB, f,GdqW_dB,'r') 

% Cascade form realization
[SOS,Kc]= tf2sos(Bd,Ad)  % Cascade form realization 
BBc=Kc^(1/size(SOS,1))*SOS(:,1:3); AAc=SOS(:,4:6); % Filter coefficients
Gc1=dfilt.df2t(BBc(1,1:2),AAc(1,1:2)); % Filter objects Gc2=dfilt.df2t(BBc(2,:),AAc(2,:));
Gc = dfilt.cascade(Gc1,Gc2); % Cascade connection
GcW_dB=10*log10(abs(freqz(Gc,W))+1e-10); % Frequency response
BBcq = quant(BBc,q); AAcq = quant(AAc,q); % Quantization of coefficients
Gc1q=dfilt.df2t(BBcq(1,1:2),AAcq(1,1:2)); % Quantized filter objects Gc2q=dfilt.df2t(BBcq(2,:),AAcq(2,:));
Gcq=dfilt.cascade(Gc1q,Gc2q); % Cascade connection
GcqW_dB=10*log10(abs(freqz(Gcq,W))+1e-10); % Frequency response
subplot(4,3,4), plot(f,GcW_dB, f,GcqW_dB,'r')

% Parallel form realization
[BBp,AAp,Kp]= tf2par_z(Bd,Ad) % Parallel form filter coefficients
BBp = BBp(2:3,:); AAp = AAp(2:3,:);  
Gp0=dfilt.df2t(Kp,1); Gp1=dfilt.df2t(BBp(1,:),AAp(1,:)); %Filter objects Gp2=dfilt.df2t(BBp(2,2:3),AAp(2,2:3));
Gp=dfilt.parallel(Gp0,Gp1,Gp2); % Parallel connection
GpW_dB=10*log10(abs(freqz(Gp,W))+1e-10); % Frequency response
BBpq=quant(BBp,q);  AApq=quant(AAp,q); % Quantization of coefficients 
Kpq = quant(Kp,q);  Gp0q=dfilt.df2t(Kpq,1); % Quantized filter objects
Gp1q=dfilt.df2t(BBpq(1,:),AApq(1,:)); Gp2q=dfilt.df2t(BBpq(2,2:3),AApq(2,2:3));
Gpq=dfilt.parallel(Gp0q,Gp1q,Gp2q); % Parallel connection GpqW_dB=10*log10(abs(freqz(Gpq,W))+1e-10); % Frequency response
subplot(4,3,7), plot(f,GpW_dB, f,GpqW_dB,'r') 

% Lattice form realization
[r,p] = tf2latc(Bd,Ad); % Lattice form filter coefficients
Glat=dfilt.latticearma(r,p); % Filter objects
GlatW_dB=10*log10(abs(freqz(Glat,W))+1e-10); % Frequency response
rq = quant(r,q);  pq = quant(p,q); % Quantization of coefficients
Glatq=dfilt.latticearma(rq,pq); % Quantized filter objects GlatqW_dB=10*log10(abs(freqz(Glatq,W))+1e-10); % Frequency response
subplot(4,3,10), plot(f,GlatW_dB, f,GlatqW_dB,'r')
