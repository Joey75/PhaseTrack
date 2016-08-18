%DoA_Estimation.m
% DoA Estimation using various algorithms
clear all; close all;
% OFDM parameters
Nfft=128; Ncp=Nfft/8; Nbps=2; % FFT size, # of CP, # of bits per QAM symbol
d_norm=0.5; % Normalized antenna spacing
M=8; p=M-2; % Number of antennas, Subarray size for spatial smoothing
% Simulation parameters
SNRdB = 5;
phs=[0:360]*(pi/360);  phs_deg=180/pi*phs; % Range of azimuth angle
tap=[1 1]; tap=tap/sqrt(tap*tap'); ch_tap_num=size(tap,2); % Channel taps
tap_phi_deg=[20 50]; % True azimuth angles of incoming signals
% Initializes correlation matrices and channel buffer
Ru=zeros(M,M); Re=zeros((M-1)*2,(M-1)*2); Rsm=zeros(p,p); 
ch_buf=zeros(1,ch_tap_num); 
Nsym=2;     % Number of OFDM symbols to transmit
for nsym=1:Nsym
   % Transmitter
   Tx_int=randint(1,Nfft,2^Nbps);            % generates random integers
   Tx=modulate(modem.qammod(2^Nbps),Tx_int); % 2^Nbps-QAM modulation
   tx_sym=addcp(ifft(Tx,Nfft),Ncp); % IFFT and add Cyclic Prefix
   [u,ch_buf]=sp_channel(tx_sym,tap,tap_phi_deg,M,d_norm,ch_buf); % Channel 
   u = AWGN(u,SNRdB,'measured'); % AWGN added
   % Estimation of received signal correlation matrix
   for n=1:Nfft
      Ru = Ru + u(:,n)*u(:,n)';  % General correlation matrix (7.28)
      u12 = u([1:end-1 2:end],n);  
      Re = Re + u12*u12';        % Correlation matrix for ESPRIT (7.37) 
   end    
   Rsm = Rsm + spatial_smoothing(u,p,'b'); % Smoothed correlation matrix
end % nsym loop 
Ru = Ru/(Nfft*Nsym);  Re = Re/(Nfft*Nsym);  
Rsm = Rsm/Nsym; % Eq.(7.42)/(7.43) for forward/for-backward smoothing

% DoA estimation Algorithms
P_DAS = DoA_DAS(Ru,d_norm,phs);  % DAS (Delay and Sum)
P_Capon = DoA_Capon(Ru,d_norm,phs);  % Capon's MV/MVDR
P_MUSIC = DoA_MUSIC(Ru,d_norm,phs);  % MUSIC
phi_deg_RM = DoA_Root_MUSIC(Ru,d_norm)
P_sm = DoA_MUSIC(Rsm,d_norm);      % MUSIC + Spatial smoothing
phi_deg_ES = DoA_ESPRIT(Re,d_norm) % ESPRIT

% plot_DoA to plot the results of DOA estimation
P_DAS_dB=10*log10(abs(P_DAS)); P_DAS_dB=P_DAS_dB-max(P_DAS_dB);
P_Capon_dB=10*log10(abs(P_Capon)); P_Capon_dB=P_Capon_dB-max(P_Capon_dB);
P_MUSIC_dB=10*log10(abs(P_MUSIC)); P_MUSIC_dB=P_MUSIC_dB-max(P_MUSIC_dB);
P_sm_dB=10*log10(abs(P_sm));  P_sm_dB=P_sm_dB-max(P_sm_dB);
figure, plot(phs_deg,P_DAS_dB,'k', phs_deg,P_Capon_dB,':'), hold on
plot(phs_deg,P_MUSIC_dB,'r:', phs_deg,P_sm_dB,'r-.')
plot(phi_deg_RM(1)*[1 1],[-50 0], phi_deg_RM(2)*[1 1],[-50 0],'b')
plot(phi_deg_ES(1)*[1 1],[-50 0],'r--', phi_deg_ES(2)*[1 1],[-50 0],'r--')
axis([0 180 -50 0]),  grid on
xlabel('Azimuth angle[deg]'),  ylabel('Power[dB]')
legend('Delay and Sum','Capon','MUSIC','MUSIC+spatial smoothing', ...
'Root MUSIC','','ESPRIT');  set(gcf,'Color','w')
