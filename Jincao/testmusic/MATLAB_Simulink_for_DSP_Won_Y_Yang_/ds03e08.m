%ds03e08.m
% Example 3.8 for MSC-based Commonality Test of Two Signals 
clear, clf
Ny=2^10; N=64; % Number of data samples and FFT size for simulation
B=[0.2 0]; A=[1 -1.2  0.72]; % Numerator/Denominator of G[z]=B[z]/A[z]
for i_P=1:3
   if i_P==1,  Pw=10; P1=0; P2=0;  
    elseif i_P==2,  Pw=10; P1=0.2; P2=0.2; 
    else Pw=0; P1=0.5; P2=0.5;
   end   
   rand('twister',5489);
   w=sqrt(12*Pw)*(rand(1,Ny)-0.5); % A white noise input to system G[z]
   s= filter(B,A,w);  % The output of the system G[z]
   y1= s + sqrt(12*P1)*(rand(1,Ny)-0.5); % Input to Sensor 1  
   y2= s + sqrt(12*P2)*(rand(1,Ny)-0.5); % Input to Sensor 2
   ff=[0:N/2]/N; Gf= freqz(B,A,2*pi*ff); % Frequency response
   Ps= Gf.*conj(Gf)*Pw; Gy1y2_true=Ps.*Ps./(Ps+P1)./(Ps+P2); % Eq.(3.50)
   Noverlap=0; Nsection=floor((Ny-Noverlap)/(N-Noverlap));
   wdw=[]; %Hamming window of size to obtain 8 equal sections by default
   [Py1,W1] = cpsd(y1,y1,wdw,Noverlap,N); % Auto-PSD of y1[n]
   [Py2,W1] = cpsd(y2,y2,wdw,Noverlap,N); % Auto-PSD of y2[n]
   [Py1y2,W1] = cpsd(y1,y2,wdw,Noverlap,N); % Cross-PSD of y1 and y2
   Gy1y2= abs(Py1y2).^2./Py1./Py2; % MSC Eq.(3.41)
   Gy1y2_msc= mscohere(y1,y2,wdw,Noverlap,N); % MSC using 'mscohere()'
   Discrepancy = norm(Gy1y2-Gy1y2_msc)
   subplot(1,3,i_P)
   plot(ff,abs(Gf),'k:', ff,Gy1y2_true,'-ro', ff,Gy1y2(kk),'-x')
   title(['Pw=' num2str(Pw) ', P1=' num2str(P1) ', P2=' num2str(P2)])
   legend('G(f)','Gy1y2-true','Gy1y2-est')
end
