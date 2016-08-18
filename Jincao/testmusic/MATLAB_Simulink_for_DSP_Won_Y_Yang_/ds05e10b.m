%ds05e10b.m 
% CLS (constrained least squares) design of FIR HPFs using fircls1() 
% in Example 5.10(b).
clear
N=30; fc=0.3; % Filter order and Cutoff frequency
fp=0.32; fs=0.28; % Passband/Stopband edge frequencies
rp=0.05; rs=0.02; % Tolerances on passband and stopband ripple 
% FIR HPF design using fircls1()
B_HPF_fircls1 = fircls1(N,fc,rp,rs,'high'); 
Kw=0.1; % more weighting on passband ripple condition
% To ensure error(ft)<rp with ft within the passband 
ft=fp+0.02; 
B1_HPF_fircls1 = fircls1(N,fc,rp,rs,fp,fs,Kw,ft,'high'); 
% To ensure error(ft)<rs with ft within the stopband
ft=fs-0.02; 
B2_HPF_fircls1 = fircls1(N,fc,rp,rs,fp,fs,Kw,ft,'high'); 
% Use filter visualization tool to see the filter
fvtool(B_HPF_fircls1,1, B1_HPF_fircls1,1, B2_HPF_fircls1,1)
