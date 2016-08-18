%test_Welch_periodogram.m
clear, clf
Nw=32; Noverlap=8; % Window size and Number of overlapped samples
Nfft=32; Fs=1; % FFT size and Sampling frequency 
Nx=128; % Length of signal x
x=cos(2*pi*5/32*[0:Nx-1])+randn(1,Nx); %+j*randn(1,Nx);
w=hamming(Nw).'; U=w*w.'/Nw; % Hamming window and its power by Eq.(6.8)
M=floor((Nx-Noverlap)/(Nw-Noverlap));
for m=0:M-1
   windowed_x= w.*x(m*(Nw-Noverlap)+[1:Nw]); % Each windowed segment
   X2s(m+1,:)= abs(fft(windowed_x,Nfft)).^2; % and its periodogram
end
Px = sum(X2s(:,1:Nfft/2+1))/(M*Nw*U); % Eq.(6.7)
if norm(imag(x))<eps  % For real-valued signals
 Px(2:Nfft/2) = 2*Px(2:Nfft/2); % regard the PSD existing for (0,pi)
end
% Using MATLAB built-in functions cpsd(), pwelch(), spectrum.welch()
Px_cpsd = 2*pi*cpsd(x,x,Nw,Noverlap,Nfft);
Px_pwelch = 2*pi*pwelch(x,Nw,Noverlap,Nfft);
h = spectrum.welch('Hamm',Nw,100*Noverlap/Nw); % Welch spectral estimator
hpsd = psd(h,x,'NFFT',Nfft,'Fs',Fs);
Px_welch = hpsd.Data;  Fw = hpsd.Frequencies;
Discrepancies= ...
[norm(Px-Px_cpsd.') norm(Px-Px_pwelch.') norm(Px-Px_welch.')]
ff=[0:Nfft/2]/Nfft; % Frequency range
stem(ff,Px), hold on, pause, stem(ff,Px_pwelch,'r')
legend('Periodogram by Eq.(6.7)','Periodogram using cpsd()/pwelch()')
