%ds05e06.m to design standard band FIR filters
clear, clf
Fs= 5e4; T=1/Fs; % Sampling frequency and sampling period
N=30; M=N/2; % Filter order and its half
nn=[-M:M]; nn1=nn+M; % Duration of filter impulse response 
fn=[0:512]/512; W= fn*pi; % normalized and digital frequency ranges
% LPF design
fc_LP= 5000*T*2; % Normalized 6dB cutoff frequency corresponding to 5kHz
gLP= fc_LP*sinc(fc_LP*nn); % Eq.(5.24)
gLP1= fir1(N,fc_LP); % filter impulse response or tap coefficients
GLP= abs(freqz(gLP,1,W))+eps; 
GLP1= abs(freqz(gLP1,1,W))+eps; 
subplot(421), stem(nn1,gLP), hold on, stem(nn1,gLP1,'r.')
subplot(422), plot(fn,20*log10(GLP), fn,20*log10(GLP1),'r:')
% BPF design
fc_BP=[7500 17500]*T*2; % Normalized 6dB band edge frequencies
fp= sum(fc_BP)/2*pi; % Passband center frequency[rad/sample]
gBP= 2*gLP.*cos(fp*nn); % Eq.(5.25)
gBP1= fir1(N,fc_BP); % filter impulse response or tap coefficients
GBP= abs(freqz(gBP,1,W))+eps; 
GBP1= abs(freqz(gBP1,1,W))+eps; 
subplot(423), stem(nn1,gBP), hold on, stem(nn1,gBP1,'r.')
subplot(424), plot(fn,20*log10(GBP), fn,20*log10(GBP1),'r:')
% HPF design
impulse_delayed= zeros(1,N+1); impulse_delayed(M+1)= 1; % Impulse
fc_HP= 20000*T*2; % Normalized 6dB cutoff frequency 20kHz
gHP= impulse_delayed-fc_HP*sinc(fc_HP*nn); % Eq.(5.26)
gHP1=fir1(N,fc_HP,'high'); %filter impulse response/tap coefficients
GHP= abs(freqz(gHP,1,W))+eps; 
GHP1= abs(freqz(gHP1,1,W))+eps; 
subplot(425), stem(nn1,gHP), hold on, stem(nn1,gHP1,'r.')
subplot(426), plot(fn,20*log10(GHP), fn,20*log10(GHP1),'r:')
% BSF design
fc_BS=[7500 17500]*T*2; % Normalized 6dB band edge frequencies
Ws= sum(fc_BS)/2*pi; % Stopband center frequency[rad/sample]
fc_LP= (fc_BS(2)-fc_BS(1))/2; gLP= fc_LP*sinc(fc_LP*nn);
gBS= impulse_delayed-2*gLP.*cos(Ws*nn); % Eq.(5.27)
gBS1=fir1(N,fc_BS,'stop'); % filter impulse response/tap coefficients
GBS= abs(freqz(gBS,1,W))+eps;  GBS1= abs(freqz(gBS1,1,W))+eps; 
subplot(427), stem(nn1,gBS), hold on, stem(nn1,gBS1,'r.')
subplot(428), plot(fn,20*log10(GBS), fn,20*log10(GBS1),'r:')
