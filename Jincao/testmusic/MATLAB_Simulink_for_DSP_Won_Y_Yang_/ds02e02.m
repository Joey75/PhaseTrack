%ds02e02.m
syms z  % Declare z as a symbolic variable
Gz = sqrt(3)/(z-0.5); % System function G[z] in symbolic form
g = iztrans(Gz) % Inverse z-transform of G[z]
%-------------------------------------------------
B = [0 sqrt(3)]; A=[1  -0.5]; % G[z]=B[z]/A[z] in rational form
NB = length(B); NA = length(A); 
% Solve the difference eqn iteratively to get the impulse response
gn(1:NA-1)=0; g_izt(1:NA-1)=0; % Zero initial conditions
Nx=32; nn=[0:Nx]; % Time range
x=zeros(1,Nx+1); x(NA-1)=1; % Unit impulse input x[n]=delta[n]
for n=1:Nx-NA+2 % Numerical solution (E2.2.4)
   xn = x(n+NA-1:-1:max(n+NA-NB,1));  Bn = B(1:length(xn)); 
   gnn = gn(n-1+[NA-1:-1:1]);  An=A(1+[1:length(gnn)]);
   gn(n+NA-1) = -An*gnn.' + Bn*xn.';
   g_izt(n+NA-1)= sqrt(3)*0.5^(n-1); % Analytical solution (E2.2.3)
end
gn_filter=filter(B,A,x); % Impulse response using filter()
Discrepancy1=norm(gn-g_izt), Discrepancy2=norm(gn-gn_filter)
subplot(511), stem(nn,gn), ylabel('g[n]'), hold on
stem(nn,g_izt,'ks'), pause, stem(nn,gn_filter,'rx')
%---------------------------------
N=32; kk=[0:N]; W=2*pi/N*kk; % Frequency range
GW = freqz(B,A,W);  % Eq.(E2.2.1) : G[z]=B[z]/A[z] with z=exp(j*W)
GW_DTFT = DTFT(gn,W); % Eq.(2.7) : DTFT of g[n]
subplot(512), plot(W,abs(GW), W,abs(GW_DTFT),':rx') 
ylabel('G(W)'), set(gca,'xtick',[0 pi/3 pi 2*pi])
set(gca,'XTickLabel',{'0','pi/3','pi','2pi'})
%------------------------------------------
W1=[0 pi/3 pi]; GW1=freqz(B,A,W1); % Frequency response at some freqs
for i=1:2, text(W1(i),abs(GW1(i)),num2str(abs(GW1(i)),'%4.2f')); end
GW1_polar=[abs(GW1); angle(GW1)] % Magnitude and phase
%------------------------------------------
syms  z  % Declare z as a symbolic variable
Gz = sqrt(3)/(z-0.5); % Transfer function in symbolic form
Yz = Gz*ztrans(sym(1)); % or Gz*z/(z-1): Y[z]=G[z]X[z]
y_step = iztrans(Yz) % Step response
%--------------------------------------------------
% Use filter() and conv() to get the step response
for n=1:Nx, y_izt(n+NA-1) = eval(y_step); end   % (E2.2.5)
x=ones(1,Nx+1); yn=filter(B,A,x); % Step response using filter()
yn_=conv(gn,x); yn_conv=yn_(1:Nx+1); % Step response by Eq.(2.3)
Discrepancy1=norm(yn-y_izt(1:Nx+1)), Discrepancy2=norm(yn-yn_conv)
subplot(513), stem(nn,yn), ylabel('ystep[n]')
%--------------------------------------------------
y_sin = iztrans(Gz*ztrans(cos(pi*n/3))) % Sinusoidal response
%--------------------------------------------------
% Use filter() to get a sinusoidal response
Nx=32; nn=[0:Nx]; x=cos(pi/3*nn); % A sinusoidal input cos(pi/3*n)
yn=filter(B,A,x); % Sinusoidal response using filter()
subplot(514), stem(nn,yn), ylabel('ysin[n]')
%--------------------------------------------------
disp('(f) Step response with nonzero initial condition')
yn(1:NA-1)=-2;  % Nonzero initial conditions with recent one last
Nx=32; nn=[0:Nx]; 
x=[zeros(1,NB-1) ones(1,Nx-NB+2)]; % Delayed input x[n]=us[n-NB+1]
for n=1:Nx-NA+2 % Numerical solution 
   xn = x(n+NA-1:-1:max(n+NA-NB,1));  Bn = B(1:length(xn));
  ynn = yn(n-1+[NA-1:-1:1]);  An=A(1+[1:length(ynn)]);
  yn(n+NA-1) = -An*ynn.' + Bn*xn.';
end
yp=[-2]; % Generally, yp = [y(-1) y(-2) .. y(-NA+1)] Recent one first
xp=[0]; % Generally, xp = [x(-1) x(-2) .. x(-NB+1)]
w0=filtic(B,A,yp,xp); % Initial state vector for filter()
x=ones(1,Nx-NB+2); % Delayed Unit step input x[n]=us[n-NB+1]
yn_filter=filter(B,A,x,w0); % Step response with nonzero IC 
% To include the initial condition as the past history
yn_filter=[fliplr(yp) yn_filter]; 
Discrepancy1 = norm(yn-yn_filter)
subplot(515), stem(nn,yn), ylabel('y[n]')
