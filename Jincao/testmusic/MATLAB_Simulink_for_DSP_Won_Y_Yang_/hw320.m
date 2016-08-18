%sig315.m : to plot Fig.3.15 
N =1024;  x =rand(1,N);
t0 =clock;  
X1 =DFS(x,N);
DFS_time =etime(clock, t0)
t0 =clock;
X2 =fft(x,N);
FFT_time =etime(clock, t0)
t0 =clock;
X3 =fft(x([1:N-1]), N-1);
DFT_time =etime(clock, t0)
abs((X1-X2)*(X1-X2)')
n1 =[0: 31];
x1 =cos(5*pi*n1/16);
X1 =fft(x1, 32);
subplot(521), stem(n1, x1)
subplot(522), stem(n1, abs(X1))
n2 =[0: 63];
x2 =cos(5*pi*n2/32);
X2 =fft(x2, 64);
subplot(523), stem(n2, x2)
subplot(524), stem(n2, abs(X2))

tr =1-2*abs(n1-15.5)/31;
tr1= [tr tr];
n3 =n1;
x3 =cos(2*pi*n3/24);
X3 =fft(x3, 32);
subplot(525), stem(n3, x3)
subplot(526), stem(n3, abs(X3))

n4= [0:63];
x4= [x3 x3];
X4 =fft(x3, 64);
subplot(527), stem(n4, x4)
subplot(528), stem(n4, abs(X4))

n5= n4;
x5= [x3 x3].*tr1;
X5 =fft(x5, 64);
subplot(529), stem(n5, x5)
subplot(5,2,10), stem(n5, abs(X5))