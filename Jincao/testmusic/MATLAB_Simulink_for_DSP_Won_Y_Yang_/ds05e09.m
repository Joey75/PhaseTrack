%ds05e09.m 
% CLS (constrained least squares) design of multiband filters 
% using fircls() in Example 5.9.
clear, refresh(1)
N=30; % Filter order
f= [0 0.3 0.5 0.7 0.8 1]; % Band edge frequency vector 
A= [ 0  0.5  0   1   0 ]; % Magnitude response vector
ub1= [0.01 0.54 0.02 1.05 0.02]; lb1= [-0.01 0.46 -0.02 0.95 -0.02]; 
B1_fircls= fircls(N,f,A,ub1,lb1); % stricter on stopband ripple condition
ub2= [0.05 0.51 0.05 1.02 0.05]; lb2= [-0.05 0.49 -0.05 0.98 -0.05];
B2_fircls= fircls(N,f,A,ub2,lb2); % stricter on passband ripple condition
fvtool(B1_fircls,1, B2_fircls,1) %Filter Visualization tool to see filter
% Click any point on the frequency curve to add data markers
