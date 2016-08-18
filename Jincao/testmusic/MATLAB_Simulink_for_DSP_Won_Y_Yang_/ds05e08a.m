%ds05e08a.m 
% to design Hilbert transformers as anti-symmetric FIR filters 
% by using firpm() or firls() in Example 5.8(a).
clear, clf
fn=[0:512]/512; W= fn*pi; % normalized and digital frequency ranges
% Hilbert transformer using firpm() or firls()
%  Type III (anti-symmetric and even order) with G(0)=0 and G(pi)=0
B20_H_firpm= firpm(20,[0.05 0.95],[1 1],'h'); % Type III 
G20_H_firpm= freqz(B20_H_firpm,1,W);
B20_H_firls= firls(20,[0.05 0.95],[1 1],'h'); % Type III 
G20_H_firls= freqz(B20_H_firls,1,W);
% Type IV (anti-symmetric and odd order) with G(0)=0
B21_H_firpm= firpm(21,[0.05 1],[1 1],'h'); % Type IV
G21_H_firpm= freqz(B21_H_firpm,1,W);
B21_H_firls= firls(21,[0.05 1],[1 1],'h'); % Type IV
G21_H_firls= freqz(B21_H_firls,1,W);
subplot(421)
nn=[0:20]; % Duration of filter impulse response
stem(nn,B20_H_firpm), hold on, stem(nn,B20_H_firls,'r:.')
subplot(422), plot(fn,abs(G20_H_firpm), fn,abs(G20_H_firls),'r:')
subplot(423)
nn=[0:21]; % Duration of filter impulse response
stem(nn,B21_H_firpm), hold on, stem(nn,B21_H_firls,'r:.')
subplot(424), plot(fn,abs(G21_H_firpm), fn,abs(G21_H_firls),'r:')
% Use filter visualization tool to see the filter
fvtool(B20_H_firpm,1,B20_H_firls,1)
fvtool(B21_H_firpm,1,B21_H_firls,1)
