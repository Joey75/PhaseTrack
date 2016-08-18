%ds10e01.m 
% to see the effect of decimation/interpolation on signal spectrum
N=64; M=2; % Signal length and Decimation/Interpolation factor
Fs=1; Ts=1/Fs; % Sampling frequency and Sampling interval of x[n]=x(n*Ts) 
X=zeros(1,N);
for k=2:N/4-3,   X(k)=-20*(k-1)/N; X(N+2-k)=conj(X(k));  end
X([N/4+9 N-N/4-7])=1.7*[1+2i 1-2i]; 
x=ifft(X,N); %x=real(ifft(X,N)); 
x1=zeros(1,N);
for m=0:N/M-1
   x1(m*M+1) = x(m*M+1); % Discrete-time sampling
   y(m+1) = x(m*M+1); % Decimation/Downsampling (contraction on t-axis)
end
X=fftshift(X); X1=fftshift(fft(x1)); Y=fftshift(fft(y));
y_decimated_FIR=decimate(x,M,'fir'); 
Y_decimated_FIR=fftshift(fft(y_decimated_FIR));
t=[0:N-1]*Ts; t1=[0:N/M-1]*M*Ts; % Time vectors for original/decimated
f=[-N/2:N/2]/N; % Frequency vector for original/reconstructed signal 
f1=[-N/M/2:N/M/2]/(N/M); % Frequency vector for decimated signal
subplot(421), stem(t,x), title('Original signal x[n]')
subplot(422), stem(f,abs(X([1:end 1]))), title('Spectrum |X(k)|')
set(gca,'xtick',[-0.5 0 5],'xticklabel','-pi|0|pi')
subplot(423), stem(t,x1), title('Discrete-time sampled version x''[n]')
subplot(424), stem(f,abs(X1([1:end 1]))), title('Spectrum |X''(k)|')
subplot(425), stem(t1,y), hold on, stem(t1,y_decimated_FIR,'rx')
legend('downsampled','decimate with FIR')
subplot(426), stem(f1,abs(Y([1:end 1])))
hold on, stem(f1,abs(Y_decimated_FIR([1:end 1])),'rx')
z_interpolated = interp(y,M); 
Z_interpolated = fftshift(fft(z_interpolated));
z_interpolated_FIR = interp(y_decimated_FIR,M);
Z_interpolated_FIR = fftshift(fft(z_interpolated_FIR));
subplot(427), stem(t,z_interpolated)
hold on, stem(t,z_interpolated_FIR,'rx'), plot(t,x,'k')
legend('interpolated','interpolated-FIR','original')
reconstruction_errors=[norm(x-z_interpolated) norm(x-z_interpolated_FIR)]
subplot(428), stem(f,abs(Z_interpolated([1:end 1])))
hold on, stem(f,abs(Z_interpolated_FIR([1:end 1])),'rx'), shg
