%ds05e11.m 
% use cfirpm() to design FIR filters 
%  having an arbitrary complex frequency response (with nonlinear phase) 
clear, refresh
for N=[30 40]
% Frequency/magnitude vectors describing desired frequency response
f=[-1 -0.5 -0.4 0.3 0.4 0.9]; 
A=[14  0    6   6   6   0  ]; %[5 1 2 2 2 1](dB)
   Kw=[1 10 5]; % A vector having the weighting factor for each band
   B_cfirpm= cfirpm(N,f,A,Kw); 
   % Use filter visualization tool to see the filter
   fvtool(B_cfirpm,1) 
end   
