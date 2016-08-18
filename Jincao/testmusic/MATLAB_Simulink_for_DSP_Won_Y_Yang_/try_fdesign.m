%try_fdesign.m
clear, clf
% create a BPF specification object
d=fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',...
0.4,0.5,0.6, 0.7, 30,  2, 30);
designmethods(d)
help(d,'butter')
% create a BPF implementation object
Gd=design(d,'butter', 'FilterStructure','df2sos', ...
'MatchExactly','passband');
fvtool(Gd)
cost(Gd)

% To find the impulse responses of unquantized and quantized filters
Fs=5e4; T=1/Fs; ND=200; t=[0:ND]*T; % Sampling frequency, Time vector
u = [1 zeros(1,ND)]; % Input vector corresponding to an impulse input
y = filter(Gd,u); % Unquantized filtering
% fixed-point object with sign, word/fraction length 16/15[bits]
uq = fi(u,true,16,15); 
Gdq=Gd; Gdq.Arithmetic='fixed'; % fixed-point arithmetic with 16 bits
yq = filter(Gdq,uq); % Quantized filtering
stairs(t,y), hold on, stairs(t,yq,'r'), grid on
legend('Unquantized','Quantized')
realizemdl(Gdq) % To generate the Simulink block for the quantized filter
generatehdl(Gdq) % To generate the HDL code
