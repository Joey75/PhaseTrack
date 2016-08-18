%ds04e06.m
% Linear-phase characteristic of (anti-)symmetric sequences
clear, clf
N=360; W=pi/N*[-N:N]; % Frequency range
for i=1:2
   if i==1, B=[1 -2.5 5.25 -2.5 1]; A=1; 
    else B=[-1 2 -2 1]; A=1; % Numerator/denominator of G[z]=B[z]/A[z]
   end
   figure(1), subplot(220+i), zplane(B,A)
   GW= freqz(B,A,W); % Frequency response
   GW_mag=abs(GW); % Magnitude of freq response
   GW_phase=angle(GW); % Phase of freq response
   figure(2), subplot(220+i), plot(W,GW_mag)
   subplot(222+i), plot(W,GW_phase) 
end  
