%ds03e07.m : for Example 3.7 
% Auto/Cross-Periodogram of Two noisy 2-Tone Signals
clear, clf
k1=10; k2=15; k3=20; % Frequency indices of 2 tones
N=64; Om1=2*pi*k1/N; Om2=2*pi*k2/N; Om3=2*pi*k3/N; % 3 frequencies
P=2;  Noise_Amp=sqrt(12*P);  % Noise power and amplitude
Nx=64;   n=0:Nx-1;  % Time index vector
rand('twister',5489); 
x =  1.6*sin(Om1*n)+0.8*cos(Om2*n) + Noise_Amp*(rand(1,Nx)-0.5); 
y =  1.3*sin(Om1*n)+1.1*cos(Om3*n) + Noise_Amp*(rand(1,Nx)-0.5); 
subplot(511), stem(n,x,'o'), hold on, stem(n,y,'x'), ylabel('x and y')
N=64; k=[0:N-1]; W=k*2*pi/N; X=fft(x,N); Y=fft(y,N); 
Pxx=X.*conj(X)/N; Pyy=Y.*conj(Y)/N; % Auto-Periodograms of x and y
Pxy=X.*conj(Y)/N; % Cross-Periodogram of x and y
subplot(512), stem(k,abs(X)), hold on, stem(k,abs(X))
ylabel('|X(k)|&|Y(k)|')
window = ones(Nx,1); % A window vector as a column vector
Noverlap = 0; % Number of overlap
[Pxx1,W1]=cpsd(x,x,window,Noverlap,N,'twosided'); % Whole APSD of x 
[Pyy1,W1]=cpsd(y,y,window,Noverlap,N,'twosided'); % Whole APSD of y [Pxy1,W1]=cpsd(x,y,window,Noverlap,N,'twosided'); % Whole CPSD of x & y 
subplot(513), stem(k,Pxx), ylabel('Pxx')
hold on, stem(k,2*pi*Pxx1,'rx') % compare with Pxx obtained using cpsd()
subplot(514), stem(k,Pyy), ylabel('Pyy')
hold on, stem(k,2*pi*Pyy1,'rx') % compare with Pyy obtained using cpsd()
subplot(515), stem(k,abs(Pxy)), ylabel('|Pxy|')
hold on, stem(k,2*pi*abs(Pxy1),'rx') % To compare with Pxy from cpsd()
