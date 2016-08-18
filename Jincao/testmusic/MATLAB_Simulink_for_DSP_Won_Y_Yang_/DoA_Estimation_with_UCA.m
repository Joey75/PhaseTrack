%DoA_Estimation_with_UCA.m
% DoA Estimation using various algorithms
clear all; close all;
% OFDM parameters
Nfft=128; Ncp=Nfft/8; % FFT size, CP size,
Nbps=2; % # of bits per QAM symbol
M=8; p=M-2; % Number of antennas, Subarray size for spatial smoothing
d = 0.1; lambda = 0.2; % Antenna spacing and wavelength
r_norm = d/(2*sin(pi/M))/lambda; % Normalized radius of UCA
% Simulation parameters
SNRdB = 5;
phs=[0:360]*(pi/360);  phs_deg=180/pi*phs; % Range of azimuth angle
tap=[1 1]; tap=tap/sqrt(tap*tap'); ch_tap_num=size(tap,2); %Channel taps
tap_phi_deg=[20 50]; % True azimuth angles of incoming signals
% Initializes correlation matrices and channel buffer
Ru=zeros(M,M); Re=zeros((M-1)*2,(M-1)*2); Rsm=zeros(p,p); 
ch_buf=zeros(1,ch_tap_num); 
Nsym=2;     % Number of OFDM symbols to transmit
for nsym=1:Nsym
   Tx_int=randint(1,Nfft,2^Nbps);       % generates random integers
   Tx=modulate(modem.qammod(2^Nbps),Tx_int); % 2^Nbps-QAM modulation
   tx=ifft(Tx,Nfft);               % IFFT
   tx_sym=[tx(end-Ncp+1:end) tx];  % adds Cyclic Prefix of length Ncp 
   [u,ch_buf]=sp_channel_UCA(tx_sym,tap,tap_phi_deg,M,r_norm,ch_buf); 
   u = awgn(u,SNRdB,'measured'); % AWGN added
   for n=1:Nfft, Ru = Ru+u(:,n)*?(:,n)'; end  % Correlation matrix
end % nsym loop 
Ru = Ru/(Nfft*Nsym);       
% DoA estimation Algorithms
P_MUSIC = DoA_MUSIC_UCA(Ru,r_norm,phs); % MUSIC algorithm 
P_MUSIC_dB=10*log10(abs(P_MUSIC)); 
P_MUSIC_dB=P_MUSIC_dB-max(P_MUSIC_dB);
plot(phs_deg,P_MUSIC_dB,'r:')
