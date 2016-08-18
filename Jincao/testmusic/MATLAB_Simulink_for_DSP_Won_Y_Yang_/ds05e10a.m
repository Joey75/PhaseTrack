%ds05e10a.m 
% CLS (constrained least squares) design of FIR LPFs using fircls1()
% in Example 5.10(a).
clear
N=30; fc=0.3; % Filter order and Cutoff frequency
fp=0.28; fs=0.32; % Passband/Stopband edge frequencies
rp=0.05; rs=0.02; % Tolerances on passband and stopband ripple 
% FIR LPF design using fircls1()
B1_LPF_fircls1 = fircls1(N,fc,rp,rs); 
Kw=10; % For more weighting on the stopband ripple condition
B2_LPF_fircls1 = fircls1(N,fc,rp,rs,fp,fs,Kw); 
% Use filter visualization tool to see the filter
fvtool(B1_LPF_fircls1,1, B2_LPF_fircls1,1) 
