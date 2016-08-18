%ds10e03.m
clear, clf
M=3; N=6; % Decimation factor and FIR filter order for anti-aliasing
% (a) Decimation
u=sin(0.05*pi*[0:60]); % Original signal
[y,H,lag]=decimate_polyphase(u,M,N); % Using decimate_polyphase()
h=fir1(N,1/M); % design an FIR filter with order N, cutoff freq pi/M
NM2=floor(N/M/2); zeros1=zeros(1,NM2);
y1 = downsample(filter(h,1,[u zeros1]),M); % FIR filtering and downsample
Ny=min(length(y),length(y1));
Discrepancy1 = norm(y(1:Ny)-y1(1:Ny))/norm(y(1:Ny)) 
y2 = decimate(u,M,N,'fir'); % Using the MATLAB SP toolbox function
n = 0:length(u)-1;  m = [0:length(y)-1]*M-lag; 
m1 = [0:length(y1)-1]*M-lag; m2 = [0:length(y2)-1]*M+mod(N,2)/2; 
subplot(211), plot(m,y,'r+', m1,y1,'rx', m2,y2,'^', n,u,'-ko')
axis([n([1 end]) -1.2 1.2])
legend('decimate polyphase()','FIR&downsample','decimate()','original')
% (b) Interpolation
M=3; N=6; % Interpolation factor and FIR filter order for anti-imaging
y=sin(0.05*pi*[0:M:60]); % Original signal
[x,G]=interpolate_polyphase(y,M,N); % Using interpolate_polyphase()
g=M*fir1(2*M*N,1/M); % FIR filter with order 2*M*N, cutoff freq pi/M
x1=filter(g,1,upsample(y,M)); % upsample and FIR filtering
x1 = x1(N*M+1:end);
Discrepancy2 = norm(x(1:length(x1))-x1) 
x2 = interp(y,M,N,1/M); % Using the MATLAB SP toolbox function
m = [0:length(y)-1]*M;  n = 0:length(x)-1;  
n1 = 0:length(x1)-1; n2 = 0:length(x2)-1;
subplot(212), plot(n,x,'r+', n1,x1,'rx', n2,x2,'^', m,y,'k-o')
axis([m([1 end]) -1.2 1.2]), shg
legend('interpolate polyphase()','upsample&FIR','interp()','original')
