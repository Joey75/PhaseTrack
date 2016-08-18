%ds10_04_03_DWTFB.m
% DWT - Analysis and IDWT - Synthesis
clear, clf
wname='haar'; %coif2' 'sym3' 'db4' % specify a wavelet name
[h0,h1,g0,g1]=wfilters(wname); % DWT filter coefficients using Haar wavelet
T=0.01; t=[0:150]*T; Ts=0.1; % Continuous time vector and sampling period
xt=0.5+[2*sin(2.5*pi*t(1:80)) sin(8*pi*t(1:71))]; % A test signal x(t)
xn=downsample(xt,round(Ts/T)); Lx=length(xn); % its sampled version x[n]
xn=[xn zeros(1,2^nextpow2(Lx)-Lx)]; % make the length a power of 2
tn=t(1)+[0:length(xn)-1]*Ts; % Discrete time vector
M=3; % Number of levels for DWT analysis (decomposition)
% DWT analysis using DWT_filterbank
[xh,app_detail0]=DWT_filterbank(h0,h1,g0,g1,M,xn);
app_detail0  % To compare with the result of DWT analysis using wavedec()
% DWT analysis using wavedec()
[app_detail,lengths_of_ad]=wavedec(xn,M,wname) % wavelet decomposition
% All frequency components in a matrix obtained from DWT decomposition
xad = DWT_dec(app_detail,lengths_of_ad,wname);
subplot(M+2,2,1)
plot(t,xt,'k:'), hold on
stairs(tn,xn), legend('x(t)','x[n]=x(nTs)')
for m=1:M+1
   subplot(M+2,2,2*m+1)
   if m<=1, stairs(tn,xn,':');
    else stairs(tn,xn-sum(xad(M+3-m:M+1,:),1),':')   
   end
   hold on, stairs(tn,xad(M+2-m,:))
   stairs(tn,xn-sum(xad(M+2-m:M+1,:),1),'r-o')
end
subplot(M+2,2,2)
xh1 = waverec(app_detail,lengths_of_ad,wname); % wavelet reconstruction
stairs(tn,xn), hold on, stairs(tn,sum(xad),'ro')
stairs(tn,xh(1:length(tn)),'x')
stairs(tn,xh1,'+')
legend('x[n]','IDWT using DWT__dec','IDWT using DyFB','IDWT using wavedec')
for m=1:M+1
   subplot(M+2,2,2*m+2)
   stairs(tn,xad(m,:)), hold on
   if m>1
     stairs(tn,sum(xad(1:m-1,:),1),':')
     stairs(tn,sum(xad(1:m,:),1),'r-o')
   end
end
N=length(h0); % Filter length
