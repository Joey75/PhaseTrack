%%ds01f14.m : to plot Fig. 1.14 
clear, clf
T=0.1; Fs=1/T; % Sampling period and Sampling frequency
w1=25*pi/16; w2=30*pi/16; w3=40*pi/16; w4=60*pi/16; 
n=[0:31]; x=[cos(w1*T*n) sin(w2*T*n) cos(w3*T*n) sin(w4*T*n)]; 
Nx=length(x); nn=0:Nx-1; % Length and duration (period) of the signal
N=32; kk=0:N/2; ff=kk*Fs/N; % DFT size and frequency range (Eq.(1.47a))
wnd= hamming(N).'; % Hamming window of length N
Noverlap=N/4; % Number of overlap
M=N-Noverlap; % Time spacing between DFT computations
for i=1:fix((Nx-Noverlap)/M)
   xiw= x((i-1)*M+[1:N]).*wnd; % ith windowed segment
   Xi= fft(xiw); % DFT X(k,i) of ith windowed segment
   X(:,i)= Xi(kk+1).'; % insert X(0:N/2,i) into the ith column
   tt(i)=(N/2+(i-1)*M)*T; % Eq.(1.47b)
end
% Use the MATLAB signal processing toolbox function specgram()
[X_sp,ff1,tt1] = spectrogram(x,wnd,Noverlap,N,Fs,'yaxis'); 
% Any discrepancy between the above result and spectrogram()? 
discrepancy= norm(X-X_sp)/norm(X_sp) 
figure(2), clf, colormap(gray(256)); 
subplot(221), imagesc(tt,ff,log10(abs(X))), axis xy
subplot(222), imagesc(tt1,ff1,log10(abs(X_sp))), axis xy
set(gcf,'color','white'), set(gca,'fontsize',9)
% specgram(x,N,Fs,wnd,noverlap) in MATLAB of version 6.x
