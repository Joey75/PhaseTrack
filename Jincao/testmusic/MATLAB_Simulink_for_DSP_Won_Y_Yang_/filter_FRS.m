function y=filter_FRS(Bc,Ac,B,A,x)
% Recursive Frequency Sampling (FRS) filtering 
y=filter_par(B,A,filter(Bc,Ac,x));
