%ds09e04.m
% FIR filter with desired frequency response Gds at digital frequency Ws
clear, clf
Ws = [0   pi/2]; % Frequency points
Gds = [2  sqrt(2)*exp(-j*pi/4)]; % Desired frequency responses
M=1; mu=0.01; % Filter order, Adaptation stepsize
N = length(Ws);  % Number of desired frequency response values 
for m=1:M+1
   for l=1:M+1,  R(l,m)=sum(cos((l-m)*Ws))/2; end  % (E9.4.2)
   p(m,1) = abs(Gds)*cos(Ws*(m-1)+angle(Gds)).'/2; % (E9.4.3)
end
bo = R\p % Optimal coefficient vector by Eq.(E9.4.4)
% Adaptive filter using LMS method
b= zeros(M+1,1); % Initial value of adaptive filter coefficients
nf=200; x=zeros(M+1,1);
for n=1:nf
   dn1 = 2 + sqrt(2)*sin(pi/2*(n-1)-pi/4); % Desired output
   xn = 1 + sin(pi/2*(n-1)); % Input
   x = [xn; x(1:M)]; % Information signal vector
   yn1 = b'*x; % Actual output of adaptive filter
   e(n) = dn1-yn1; % Error signal between desired output and actual one
   b = b + mu*e(n)*x; % Adaptive filter coefficient: LMS method (9.22)
end
b
subplot(221), plot([0:nf-1],abs(e))
W=[0:200]*(pi/200); GW=freqz(b,1,W); % Frequency response for W=[0,pi]
subplot(222), plot(W,abs(GW),'b', W,angle(GW),'r'), hold on
stem(Ws,abs(Gds),'b:.') % Desired magnitude of frequency response
stem(Ws,angle(Gds),'r:.') % Desired phase of frequency response
set(gca,'xtick',[0 pi/2 pi],'xtickLabel',{'0','pi/2','pi'})
% To run the Simulink model 'ds09e04_sim'
T=0.01; tf=(nf-1)*T; sim('ds09e04_sim',tf)
b_sim  % Coefficient vector obtained from Simulink model 'ds09e04_sim'
