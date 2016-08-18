%ds05e08b.m 
% to design differentiators as anti-symmetric FIR filters
% by using firpm() or firls() in Example 5.8(b).
clear, clf
fn=[0:512]/512; W=fn*pi; % normalized and digital frequency ranges
% Differentiator using firpm()or firls()
B20_d_firpm= firpm(20,[0 0.95],[0 0.95*pi],'d'); % Type III 
G20_d_firpm= freqz(B20_d_firpm,1,W); % G(0)=0, G(pi)=0
B20_d_firls= firls(20,[0 0.95],[0 0.95*pi],'d'); % Type III 
G20_d_firls= freqz(B20_d_firls,1,W); % G(0)=0, G(pi)=0
B21_d_firpm= firpm(21,[0 1],[0 pi],'d'); % Type IV with G(0)=0
G21_d_firpm= freqz(B21_d_firpm,1,W);
B21_d_firls= firls(21,[0 1],[0 pi],'d'); % Type IV with G(0)=0
G21_d_firls= freqz(B21_d_firls,1,W);
subplot(421)
nn=[0:20]; % Duration of filter impulse response
stem(nn,B20_d_firpm), hold on, stem(nn,B20_d_firls,'r:.')
subplot(422), plot(fn,abs(G20_d_firpm), fn,abs(G20_d_firls),'r:')
subplot(423)
nn=[0:21]; % Duration of filter impulse response
stem(nn,B21_d_firpm), hold on, stem(nn,B21_d_firls,'r:.')
subplot(424), plot(fn,abs(G21_d_firpm), fn,abs(G21_d_firls),'r:')
% Use filter visualization tool to see the filter
fvtool(B20_d_firpm,1,B20_d_firls,1)
fvtool(B21_d_firpm,1,B21_d_firls,1)
